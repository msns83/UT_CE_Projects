#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <SFML/Graphics.hpp>
#include "../Import/properties.hpp"
#include "game.hpp"

using namespace std;
using namespace sf;

Game ::Game(string address)
{
    win = false;
    vector<string> fileRows = extractRowFromFile(address);
    gameTime = stof(fileRows[0]);
    readMap(fileRows);

    board.putObjectsOnBoard(map);
}

void Game::readMap(vector<string> &fileRows)
{
    for (int i = 1; i < fileRows.size(); i++)
        map.push_back(makeRowFromString(fileRows[i], SEPERATOR));
}

void Game ::draw(RenderWindow &window)
{
    window.clear(Color::White);
    writeTimer(window);
    board.draw(window);
    player.draw(window, getBoardSize());
}

void Game ::writeTimer(RenderWindow &window)
{
    Font font;
    Text text;
    if (!font.loadFromFile(FontAddress))
        abort();
    text.setFont(font);
    text.setFillColor(Color::Black);
    text.setCharacterSize(Resolution / FONT_SCALE);
    text.setPosition(getBoardSize()[0] * Resolution / 3, 2 * Resolution);

    Time remain = seconds(gameTime * 60) - gameStopwatch.getElapsedTime();
    text.setString("Remain Time: " + to_string(((int)remain.asSeconds()) / 60) + ":" + to_string(((int)remain.asSeconds()) % 60));

    window.draw(text);
}

void Game ::playerMove(Direction direction)
{
    player.move(direction, map);

    Gained gainedItem = board.isGained(player.getBound());

    if (gainedItem == DOOR_OBJ)
        if (player.isKeysFull())
            win = true;

    if (gainedItem == KEY_OBJ)
        player.increaseKeys();

    if (gainedItem == POWERUP_OBJ)
        player.increaseLives();
}

void Game ::CheckEnemyCollision()
{
    if (board.doesEnemyCrashed(player.getBound()))
        player.die();
}

void Game ::enemyMove()
{
    if (milliseconds(ENEMY_MOVE_DURATION) <= enemyMovementTime.getElapsedTime())
    {
        board.enemyMove(map);
        enemyMovementTime.restart();
    }
}

void Game ::plantBomb()
{
    player.plantBomb();
}

void Game ::checkBombs()
{
    vector<int> explodedCordinate = player.checkBombs();
    if (explodedCordinate[0] != -1)
        damageAround(explodedCordinate);
}

void Game ::damageAround(vector<int> explodedCordinate)
{
    vector<Direction> directions = {UP, DOWN, RIGHT, LEFT, SAME};
    for (int i = 0; i < directions.size(); i++)
    {
        int xDamaged = explodedCordinate[0] + delta_x[directions[i]];
        int yDamaged = explodedCordinate[1] + delta_y[directions[i]];

        player.explode({xDamaged, yDamaged});
        board.destroyBlock({xDamaged, yDamaged}, map);
        board.killEnemy({xDamaged, yDamaged});
    }
}

vector<string> Game ::extractRowFromFile(string address)
{
    fstream File;
    File.open(address, ios::in);

    vector<string> rows;
    string rowKeeper;

    while (getline(File, rowKeeper))
        rows.push_back(rowKeeper);

    File.close();
    return rows;
}

vector<string> Game ::makeRowFromString(string inputRow, char separator)
{
    stringstream rowStream(inputRow);
    string cell;
    vector<string> row;

    while (getline(rowStream, cell, separator))
        row.push_back(cell);

    return row;
}

vector<int> Game ::getBoardSize()
{
    return {(int)(map[0].size()), (int)(map.size())};
}

bool Game ::isOver()
{

    if (player.getLives() <= 0)
    {
        cout << DYING_BY_LIVES_TEXT << endl;
        return true;
    }
    if (win == true)
    {
        cout << WINING_TEXT << endl;
        return true;
    }
    if (seconds(60 * gameTime) <= gameStopwatch.getElapsedTime())
    {
        cout << DYING_BY_TIME_TEXT << endl;
        return true;
    }

    return false;
}

vector<int> Game ::getGameWindowSize()
{
    return {getBoardSize()[0] * Resolution, (getBoardSize()[1] + 3) * Resolution};
}