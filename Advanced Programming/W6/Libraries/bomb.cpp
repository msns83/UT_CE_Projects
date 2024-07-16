#include "bomb.hpp"
#include "../Import/properties.hpp"
#include <vector>
#include <SFML/Graphics.hpp>
using namespace std;
using namespace sf;

Bomb ::Bomb(int x, int y)
{
    cordinates = {x, y};
    if (!texture.loadFromFile(BOMB_PIC))
        abort();
    shape.setTexture(texture);
    shape.scale(Resolution / (float)texture.getSize().x, Resolution / (float)texture.getSize().y);
    shape.setPosition(cordinates[0], cordinates[1]);
};

void Bomb ::draw(RenderWindow &window)
{
    if (!texture.loadFromFile(BOMB_PIC))
        abort();
    shape.setTexture(texture);
    window.draw(shape);
}

bool Bomb ::isExplode()
{
    if (seconds(BOMB_TIMER) <= timer.getElapsedTime())
    {
        return true;
    }
    return false;
}

vector<int> Bomb ::getCordinates()
{
    return cordinates;
}