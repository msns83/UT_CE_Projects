#include <vector>
#include <string>
#include <random>
#include <algorithm>
#include <SFML/Graphics.hpp>
#include "board.hpp"
#include "gainable.hpp"
#include "../Import/properties.hpp"
using namespace std;
using namespace sf;

void Board ::putObjectsOnBoard(vector<vector<string>> &map)
{
    freezeState = false;
    vector<int> randoms;

    setItemFromMap(map, randoms);
    generateRandomPlaces(randoms);
    setRandomItems(randoms);
}

void Board ::setItemFromMap(vector<vector<string>> &map, vector<int> &randomNums)
{
    for (int j = 0; j < map.size(); j++)
        for (int i = 0; i < map[0].size(); i++)
        {
            identifyBlock(map[j][i], i, j);
            identifyEnemy(map[j][i], i, j);
            identifyDoor(map[j][i], i, j, randomNums);
        }
}

void Board ::setRandomItems(vector<int> &randomNums)
{
    setRandomItem(keys, randomNums, KEYS_COUNT, KEY_PIC);
    setRandomItem(powerupsType1, randomNums, POWERUP_TYPE_COUNT, POWERUP1_PIC);
    setRandomItem(powerupsType2, randomNums, POWERUP_TYPE_COUNT, POWERUP2_PIC);
}

void Board ::identifyDoor(string &cell, int x, int y, vector<int> &randomPlaces)
{
    if (cell == DOOR)
    {
        door.create({x * Resolution, (y+3) * Resolution}, DOOR_PIC);
        cell = TEMP_BLOCK;
        randomPlaces.push_back(tempBlocksCordinates.size() - 1);
    }
}

void Board ::setRandomItem(vector<Gainable> &randomGainables, vector<int> &randomPlaces, int GainablesCount, string picAddress)
{
    for (int i = 0; i < GainablesCount; i++)
    {
        randomGainables.push_back(Gainable());
        randomGainables[i].create(tempBlocksCordinates[randomPlaces[randomPlaces.size() - 1]], picAddress);
        randomPlaces.pop_back();
    }
}

void Board::generateRandomPlaces(vector<int> &randoms)
{
    while (randoms.size() < (KEYS_COUNT + 2 * POWERUP_TYPE_COUNT + 1))
    {
        int random = getRandomInt(tempBlocksCordinates.size());
        if (randoms.end() != find(randoms.begin(), randoms.end(), random))
            continue;
        randoms.push_back(random);
    }
}

void Board ::identifyBlock(string cell, int x, int y)
{
    if (cell == BLOCK)
        blocksCordinates.push_back({x * Resolution, (y+3) * Resolution});
    else if (cell == TEMP_BLOCK || cell == DOOR)
        tempBlocksCordinates.push_back({x * Resolution, (y+3) * Resolution});
}

void Board ::identifyEnemy(string cell, int x, int y)
{
    vector<Direction> horizontalSide = {LEFT, RIGHT};
    vector<Direction> verticalSide = {UP, DOWN};

    if (cell == VER_ENEMY)
        enemies.push_back(Enemy(verticalSide[getRandomInt(2)], x * Resolution, (y+3) * Resolution));
    else if (cell == HOR_ENEMY)
        enemies.push_back(Enemy(horizontalSide[getRandomInt(2)], x * Resolution, (y+3) * Resolution));
}

void Board ::draw(RenderWindow &window)
{
    door.draw(window);

    for (auto gainables : {keys, powerupsType1, powerupsType2})
        for (auto &gainable : gainables)
            gainable.draw(window);

    for (auto &enemy : enemies)
        enemy.draw(window);

    drawBlocks(tempBlocksCordinates, TEMP_BLOCK_PIC, window);
    drawBlocks(blocksCordinates, BLOCK_PIC, window);
}

void Board ::drawBlocks(vector<vector<int>> blocks, string picAddress, RenderWindow &window)
{
    for (int i = 0; i < blocks.size(); i++)
    {
        Texture texture;
        Sprite shape;
        if (!texture.loadFromFile(picAddress))
            abort();
        shape.setTexture(texture);
        shape.scale(Resolution / (float)texture.getSize().x, Resolution / (float)texture.getSize().y);
        shape.setPosition(blocks[i][0], blocks[i][1]);
        window.draw(shape);
    }
}

void Board ::enemyMove(vector<vector<string>> &map)
{
    if (seconds(FREEZE_TIME) <= freezeTimer.getElapsedTime())
        freezeState = false;

    if (!freezeState)
        for (int i = 0; i < enemies.size(); i++)
            enemies[i].move(map);
}

bool Board ::doesEnemyCrashed(FloatRect playerBound)
{
    for (int i = 0; i < enemies.size(); i++)
        if (playerBound.intersects(enemies[i].getBound()))
            return true;

    return false;
}

Gained Board::isGained(FloatRect playerBound)
{
    if (playerBound.intersects(door.getBound()))
        return DOOR_OBJ;

    if (checkGainablesIntersect(playerBound, keys))
        return KEY_OBJ;

    if (checkGainablesIntersect(playerBound, powerupsType1))
        return POWERUP_OBJ;

    if (checkGainablesIntersect(playerBound, powerupsType2))
    {
        freezeState = true;
        freezeTimer.restart();
    }

    return NULL_OBJ;
}

bool Board ::checkGainablesIntersect(FloatRect playerBound, vector<Gainable> &gainablesGroup)
{
    for (int i = 0; i < gainablesGroup.size(); i++)
        if (playerBound.intersects(gainablesGroup[i].getBound()))
        {
            gainablesGroup.erase(gainablesGroup.begin() + i);
            return true;
        }

    return false;
}

int Board ::getRandomInt(int upTo)
{
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<int> distribution(0, upTo - 1);
    return distribution(gen);
}

void Board ::destroyBlock(std::vector<int> damagedcordinate, std::vector<std::vector<string>> &map)
{
    for (int i = 0; i < tempBlocksCordinates.size(); i++)
        if (damagedcordinate[0] == tempBlocksCordinates[i][0] && damagedcordinate[1] == tempBlocksCordinates[i][1])
        {
            tempBlocksCordinates.erase(tempBlocksCordinates.begin() + i);
            map[(damagedcordinate[1] / Resolution)-3][damagedcordinate[0] / Resolution] = EMPTY;
        }
}

void Board ::killEnemy(std::vector<int> damagedcordinate)
{
    for (int i = 0; i < enemies.size(); i++)
        if (damagedcordinate[0] == enemies[i].getCordinates()[0] && damagedcordinate[1] == enemies[i].getCordinates()[1])
            enemies.erase(enemies.begin() + i);
}