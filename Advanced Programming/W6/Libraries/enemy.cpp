#include <vector>
#include <SFML/Graphics.hpp>
#include "../Import/properties.hpp"
#include "enemy.hpp"

using namespace std;
using namespace sf;

Enemy ::Enemy(Direction inputDirection, int x, int y)
{
    cordinates = {x, y};
    direction = inputDirection;
    if (!texture.loadFromFile(ENEMY_PIC))
        abort();
    shape.setTexture(texture);
    shape.scale(Resolution / (float)texture.getSize().x, Resolution / (float)texture.getSize().y);
    shape.setPosition(cordinates[0], cordinates[1]);
}

void Enemy ::draw(sf::RenderWindow &window)
{
    if (!texture.loadFromFile(ENEMY_PIC))
        abort();
    shape.setTexture(texture);
    window.draw(shape);
}

bool Enemy ::checkValidation(vector<vector<string>> &map, bool logic)
{
    const vector<Direction> reverseDirection = {RIGHT, DOWN, LEFT, UP};
    if (logic)
    {
        direction = reverseDirection[direction];
        move(map);
        return false;
    }
    return true;
}

bool Enemy ::changeDirection(vector<vector<string>> &map, int x, int y)
{
    bool outOfWindow = y < (3*Resolution) || (map.size()+2) * Resolution < y || x < 0 || (map[0].size() - 1) * Resolution < x;
    if (!checkValidation(map, outOfWindow))
        return true;

    bool blockInWay = map[(y / Resolution)-3][x / Resolution] == BLOCK || map[(y / Resolution)-3][x / Resolution] == TEMP_BLOCK;
    if (!checkValidation(map, blockInWay))
        return true;

    return false;
}

void Enemy ::move(vector<vector<string>> &map)
{
    if (!changeDirection(map, cordinates[0] + delta_x[direction], cordinates[1] + delta_y[direction]))
    {
        cordinates = {cordinates[0] + delta_x[direction], cordinates[1] + delta_y[direction]};
        shape.setPosition(cordinates[0], cordinates[1]);
    }
}

FloatRect Enemy ::getBound()
{
    return shape.getGlobalBounds();
}

vector<int> Enemy ::getCordinates()
{
    return cordinates;
}