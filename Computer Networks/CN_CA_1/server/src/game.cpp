#include "../include/game.h"
#include "include/maploader.h"

Game::Game(int selectedPlayer, const QString &protocol, QObject *parent): QObject(parent), m_gameView(new GameView(this)), gameTimer(new QTimer(this)), mapLoader(new MapLoader()), protocol(protocol), selectedPlayer(selectedPlayer) {
    qDebug() << "Game started with selected player:" << selectedPlayer << "and protocol:" << protocol;
    m_gameView->initialize();
    QPixmap bgImage(":/assets/Background.png");
    QSize bgSize = bgImage.size();
    hud = new HUD(m_gameView->scene(), bgSize.width());
    connectGameTimer();
}

void Game::connectGameTimer() {
    connect(gameTimer, &QTimer::timeout, this, &Game::update);
    gameTimer->setInterval(1000 / FrameRate);
}

void Game::start() {
    loadMap();
    setFocusOnPlayer();
    gameTimer->start();

    if (protocol == "TCP") {
        setupTCP();
    } else if (protocol == "UDP")
        setupUDP();
}

void Game::loadMap() {
    if (!mapLoader->loadMap(":/assets/map.txt", m_gameView->scene(), m_gameView->view()->size(), 31, 13, this))
        qDebug() << "Map loading failed!";
}

void Game::setFocusOnPlayer() {
    Player *focusPlayer = nullptr;
    for (const QPointer<Player>& player : players) {
        if (player && player->getPlayerId() == selectedPlayer) {
            focusPlayer = player;
            break;
        }
    }
    if (!focusPlayer && !players.isEmpty())
        focusPlayer = players.first();
    if (focusPlayer){
        focusPlayer->setFlag(QGraphicsItem::ItemIsFocusable, true);
        focusPlayer->setFocus();
    }
}

void Game::update() {

    if (!(m_gameView->scene()->focusItem()))
        setFocusOnPlayer();

    players.removeIf([](const QPointer<Player>& player) { return player.isNull(); });

    for (const auto &player : players)
        if (player)
            player->updateMovement();

    hud->updateHealth(players);
}

void Game::setupUDP(){
    udpManager = new UDPManager(selectedPlayer);

    connect(udpManager, &UDPManager::dataReceived, this, &Game::processIncomingData);
    connect(this, &Game::dataReady, udpManager, &UDPManager::sendData);

    for (const QPointer<Player>& player : players) 
        if (player->getPlayerId() == selectedPlayer) {
            connect(player, &Player::bombPlanted, this, &Game::sendBomb);
            connect(player, &Player::movmentCaptured, this, &Game::sendPlayerMovement);
            break;
        }
}

void Game::setupTCP(){
    _server = new ServerManager();
    connect(players[0], &Player::pressKey, _server, &ServerManager::handleServerEvent);
    connect(_server, &ServerManager::clientEventReceived, players[1], &Player::handleClientEvent);
}

Player* Game::findPlayer(int id){
    Player* foundedPlayer = nullptr;

    for (const QPointer<Player>& player : players)
        if (player && player->getPlayerId() == id) {
            foundedPlayer = player;
            break;
        }

    return foundedPlayer;
}

QList<QRectF> Game::getlocalBlocks(){
    QList<QRectF> breakableBlocks;
    for (QGraphicsItem *item : m_gameView->scene()->items())
    if (BreakableBlock *block = dynamic_cast<BreakableBlock*>(item))
        breakableBlocks.append(block->boundingRect().translated(block->pos()));
    
    return breakableBlocks;
}

void Game::sendPlayerPosition()
{
    Player *currentPlayer = findPlayer(selectedPlayer);
    QByteArray data = currentPlayer->serializeState();
    emit dataReady(data, selectedPlayer);
}

void Game::sendMapState() {
    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    QList<QRectF> breakableBlocks = getlocalBlocks();
    int blockCounts = breakableBlocks.size();

    stream << QChar('C') << blockCounts;
    for (const QRectF &rect : breakableBlocks)
        stream << rect.x() << rect.y() << rect.width() << rect.height();

    emit dataReady(data, selectedPlayer);
}

void Game::sendHealthes() {
    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << QChar('H');

    for (const QPointer<Player> &player : players)
        stream << player->getPlayerId() << player->getHealth();

    emit dataReady(data, selectedPlayer);
}

void Game::sendBomb() {
    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << QChar('B') << selectedPlayer ;
    emit dataReady(data, selectedPlayer);
}

void Game::sendPlayerMovement(int key, bool status) {
    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << QChar('M') << key << status;
    emit dataReady(data, selectedPlayer);
    
    trigOthers();
}

void Game::trigOthers(){
    sendCounter++;
    if (sendCounter >= 10) {
        sendMapState();
        sendHealthes();
        sendPlayerPosition();
        sendCounter = 0;
    }
}

void Game::processIncomingData(const QByteArray &data) {
    QDataStream stream(data);
    QChar type;
    stream >> type;
    
    if (type == QChar('P')) {
        for (const QPointer<Player> &player : players)
            if (player && player->getPlayerId() != selectedPlayer) {
                player->deserializeState(data);
                break;
            }
    } else if (type == QChar('B')) {
        for (const QPointer<Player> &player : players)
            if (player && player->getPlayerId() != selectedPlayer) {
                player->placeBomb();
                break;
            }
    } else if (type == QChar('M')) {
        syncMovement(stream);
    } else if (type == QChar('C')) {
        syncBlocks(stream);
    } else if (type == QChar('H')) {
        int id, health;
        for (const QPointer<Player> &player : players) {
            stream >> id >> health;
            if (player->getPlayerId() == id)
                player->setHealth(health);
        }
    }
    
}

void Game::syncBlocks(QDataStream &stream){
    int remoteBlockCount;
    stream >> remoteBlockCount;
    QList<QRectF> remoteBlocks;

    for (int i = 0; i < remoteBlockCount; ++i) {
        qreal x, y, w, h;
        stream >> x >> y >> w >> h;
        remoteBlocks.append(QRectF(x, y, w, h));
    }

    QList<QRectF> localBlocks = getlocalBlocks();

    if (remoteBlockCount < localBlocks.size())
        replaceBlocks(remoteBlocks);
}

void Game::syncMovement(QDataStream &stream) {
    int key;
    bool status;
    stream >> key >> status;

    for (const QPointer<Player> &player : players)
        if (player && player->getPlayerId() != selectedPlayer) {
            player->updateDirectionState(key, status);
            break;
        }
}

void Game::replaceBlocks(QList<QRectF> remoteBlocks){
    QList<QGraphicsItem*> sceneItems = m_gameView->scene()->items();

    for (QGraphicsItem *item : sceneItems) {
        if (BreakableBlock *bBlock = dynamic_cast<BreakableBlock*>(item)) {
            m_gameView->scene()->removeItem(bBlock);
            delete bBlock;
        }
    }

    for (const QRectF &rect : remoteBlocks) {
        BreakableBlock *newBlock = new BreakableBlock();
        newBlock->setPos(rect.topLeft());
        m_gameView->scene()->addItem(newBlock);
    }
}