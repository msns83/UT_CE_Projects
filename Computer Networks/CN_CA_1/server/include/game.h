#ifndef GAME_H
#define GAME_H

#include "player.h"
#include "gameview.h"
#include "hud.h"

#include <QObject>
#include <QList>
#include <QPointer>
#include <QTimer>
#include <QDebug>
#include <QPixmap>
#include "udpmanager.h"
#include "ServerManager.h"

class QTimer;
class MapLoader;
class GameView;
class HUD;

class Game : public QObject {
    Q_OBJECT
public:
    explicit Game(int selectedPlayer, const QString &protocol, QObject *parent = nullptr);
    void start();
    QList<QPointer<Player>> players;

    MapLoader *getMapLoader() const { return mapLoader; }
    UDPManager *getUdpManager() const { return udpManager; }
    QString getProtocol() const { return protocol; }
    int getSelectedPlayer() const { return selectedPlayer; }

public slots:
    void update();
    void processIncomingData(const QByteArray &data);
    void sendBomb();
    void sendPlayerMovement(int key, bool status);

signals:
    void dataReady(const QByteArray &data, int selectedPlayer);

private:
    void connectGameTimer();
    void loadMap();
    void setFocusOnPlayer();
    void setupNetwork();
    void sendPlayerPosition();
    void sendMapState();
    void sendHealthes();
    void setupUDP();
    void setupTCP();

    Player* findPlayer(int id);
    QList<QRectF> getlocalBlocks();
    void replaceBlocks(QList<QRectF> remoteBlocks);
    void trigOthers();

    void syncMovement(QDataStream &stream);
    void syncBlocks(QDataStream &stream);

private:
    GameView *m_gameView;
    QTimer *gameTimer;
    MapLoader *mapLoader;
    HUD *hud;
    static constexpr int FrameRate = 30;
    QString protocol;
    
    
    ServerManager *_server ;
    UDPManager *udpManager;
    
    int sendCounter = 0;
    int selectedPlayer;
};

#endif
