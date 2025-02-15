#ifndef ENEMY
#define ENEMY

#include <vector>
#include <string>
#include <SFML/Graphics.hpp>
#include "../Import/properties.hpp"

class Enemy
{
public:
    Enemy(Direction inputDirection, int x, int y);
    void draw(sf::RenderWindow &window);
    void move(std::vector<std::vector<std::string>> &map);
    std::vector<int> getCordinates();
    sf::FloatRect getBound();

private:
    bool changeDirection(std::vector<std::vector<std::string>> &map, int x, int y);
    bool checkValidation(std::vector<std::vector<std::string>> &map, bool logic);
    Direction direction;
    sf::Texture texture;
    sf::Sprite shape;
    std::vector<int> cordinates;
};

#endif