#ifndef GAME
#define GAME

#include <vector>
#include <string>
#include <SFML/Graphics.hpp>
#include "board.hpp"
#include "player.hpp"
#include "../Import/properties.hpp"

class Game
{
public:
    Game(std::string address);
    void draw(sf::RenderWindow &window);
    void playerMove(Direction direction);
    void plantBomb();
    void enemyMove();
    bool isOver();
    std::vector<int> getBoardSize();
    void checkBombs();
    void CheckEnemyCollision();
    std::vector<int> getGameWindowSize();

private:
    std::vector<std::string> extractRowFromFile(std::string address);
    std::vector<std::string> makeRowFromString(std::string inputRow, char separator);
    void writeTimer(sf::RenderWindow &window);
    void damageAround(std::vector<int> explodedCordinate);
    void readMap(std::vector<std::string> &fileRows);
    float gameTime;
    sf::Clock gameStopwatch;
    sf::Clock enemyMovementTime;
    bool win;
    std::vector<std::vector<std::string>> map;
    Board board;
    Player player;
};

#endif