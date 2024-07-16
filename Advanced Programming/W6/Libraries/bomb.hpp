#ifndef BOMB
#define BOMB

#include <vector>
#include <SFML/Graphics.hpp>
#include "../Import/properties.hpp"

class Bomb
{
public:
    Bomb(int x, int y);
    void draw(sf::RenderWindow &window);
    bool isExplode();
    std::vector<int> getCordinates();

private:
    sf::Clock timer;
    sf::Texture texture;
    sf::Sprite shape;
    std::vector<int> cordinates;
};

#endif