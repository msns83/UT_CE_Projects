#include <vector>
#include <string>
#include <iostream>
#include <SFML/Graphics.hpp>
#include "player.hpp"
#include "bomb.hpp"

using namespace std;
using namespace sf;

Player ::Player()
{
    lives = LIVES_COUNT;
    cordinates = {0, 0+(3*Resolution)};
    if (!texture.loadFromFile(Player_PIC))
        abort();
    shape.setTexture(texture);
    shape.scale(Resolution / (float)texture.getSize().x, Resolution / (float)texture.getSize().y);
    shape.setPosition(cordinates[0], cordinates[1]);
    keys = 0;
}

void Player ::move(Direction direction, vector<vector<string>> &map)
{
    int x = cordinates[0] + delta_x[direction];
    int y = cordinates[1] + delta_y[direction];

    if (x < 0 || y < (3*Resolution) || (map[0].size() - 1) * Resolution < x || (map.size()+2) * Resolution < y)
        return;
    if (map[(y / Resolution)-3][x / Resolution] == BLOCK || map[(y / Resolution)-3][x / Resolution] == TEMP_BLOCK)
        return;

    cordinates = {x, y};
    shape.setPosition(x, y);
}

void Player ::draw(RenderWindow &window, vector<int> boardSize)
{
    for (int i = 0; i < bombs.size(); i++)
        bombs[i].draw(window);

    writeInfos(boardSize, window);
    window.draw(shape);
}

void Player ::plantBomb()
{
    if (bombs.size() < BOMB_LIMIT)
        bombs.push_back(Bomb(cordinates[0], cordinates[1]));
}

vector<int> Player ::checkBombs()
{
    for (int i = 0; i < bombs.size(); i++)
        if (bombs[i].isExplode())
        {
            vector<int> producedCordinates = bombs[i].getCordinates();
            bombs.erase(bombs.begin() + i);
            return producedCordinates;
        }

    return {-1, -1};
}

FloatRect Player ::getBound()
{
    return shape.getGlobalBounds();
}

void Player ::die()
{
    lives--;
    cordinates = {0, 0+(3*Resolution)};
    shape.setPosition(cordinates[0], cordinates[1]);
}

void Player ::writeInfos(vector<int> distances, RenderWindow &window)
{
    Font font;
    Text text;

    if (!font.loadFromFile(FontAddress))
        abort();

    text.setFont(font);
    text.setFillColor(Color::Black);
    text.setCharacterSize(Resolution / FONT_SCALE);

    writeTextOnWindow(window, text, distances, "Lives: " + to_string(lives), 0);
    writeTextOnWindow(window, text, distances, "Keys: " + to_string(keys), 1);
}

void Player ::writeTextOnWindow(RenderWindow &window, Text &text, vector<int> distances, string textValue, int rowNumber)
{
    text.setString(textValue);
    text.setPosition(distances[0] * Resolution / 3, (rowNumber) * Resolution);
    window.draw(text);
}

void Player ::explode(vector<int> damagedCordinate)
{
    if (cordinates[0] == damagedCordinate[0] && cordinates[1] == damagedCordinate[1])
        lives--;
}

void Player ::increaseLives()
{
    lives++;
}

int Player ::getLives()
{
    return lives;
}

void Player::increaseKeys()
{
    keys++;
}

bool Player::isKeysFull()
{
    return keys == KEYS_COUNT;
}