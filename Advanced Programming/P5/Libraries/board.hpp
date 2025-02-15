#ifndef BOARD
#define BOARD

#include <vector>
#include <string>
#include <SFML/Graphics.hpp>
#include "enemy.hpp"
#include "gainable.hpp"
class Board
{
public:
    void putObjectsOnBoard(std::vector<std::vector<std::string>> &inputMap);
    void draw(sf::RenderWindow &window);
    void enemyMove(std::vector<std::vector<std::string>> &map);
    void destroyBlock(std::vector<int> damagedcordinate, std::vector<std::vector<std::string>> &map);
    void killEnemy(std::vector<int> damagedcordinate);
    Gained isGained(sf::FloatRect playerBound);
    bool doesEnemyCrashed(sf::FloatRect playerBound);

private:
    int getRandomInt(int upTo);
    void identifyBlock(std::string cell, int x, int y);
    void identifyEnemy(std::string cell, int x, int y);
    void identifyDoor(std::string &cell, int x, int y, std::vector<int> &randomPlaces);
    void generateRandomPlaces(std::vector<int> &randoms);
    void setRandomItem(std::vector<Gainable> &randomGainables, std::vector<int> &randomPlaces, int GainablesCount, std::string picAddress);
    void setRandomItems(std::vector<int> &randomNums);
    void setItemFromMap(std::vector<std::vector<std::string>> &map, std::vector<int> &randomNums);
    void drawBlocks(std::vector<std::vector<int>> blocks, std::string picAddress, sf::RenderWindow &window);
    bool checkGainablesIntersect(sf::FloatRect playerBound, std::vector<Gainable> &gainablesGroup);
    std::vector<std::vector<int>> blocksCordinates;
    std::vector<std::vector<int>> tempBlocksCordinates;
    std::vector<Enemy> enemies;
    std::vector<Gainable> keys;
    Gainable door;
    sf::Clock freezeTimer;
    bool freezeState;
    std::vector<Gainable> powerupsType1;
    std::vector<Gainable> powerupsType2;
};

#endif