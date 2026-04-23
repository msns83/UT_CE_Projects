#ifndef GAME_H
#define GAME_H

#include "player.h"
#include "maploader.h"
#include "gameview.h"
#include "hud.h"

#include <QObject>
#include <QList>
#include <QPointer>
#include <QTimer>
#include <QDebug>
#include <QPixmap>
#include "ClientManager.h"

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

public slots:
    void update();

private:
    void connectGameTimer();
    void loadMap();
    void setFocusOnPlayer();
    void setupNetwork();
private:
    GameView *m_gameView;
    QTimer *gameTimer;
    MapLoader *mapLoader;
    HUD *hud;


    int selectedPlayer;
    QString protocol;
    static constexpr int FrameRate = 30;
    ClientManager *_client = new  ClientManager();


};

#endif // GAME_H
