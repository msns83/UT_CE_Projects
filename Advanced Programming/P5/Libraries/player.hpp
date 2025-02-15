#ifndef PLAYER
#define PLAYER

#include <vector>
#include <string>
#include <SFML/Graphics.hpp>
#include "../Import/properties.hpp"
#include "bomb.hpp"
class Player
{
public:
    Player();
    void move(Direction direction, std::vector<std::vector<std::string>> &map);
    void draw(sf::RenderWindow &window, std::vector<int> boardSize);
    void plantBomb();
    std::vector<int> checkBombs();
    sf::FloatRect getBound();
    void die();
    void explode(std::vector<int> damagedCordinate);
    int getLives();
    void increaseLives();
    void increaseKeys();
    bool isKeysFull();

private:
    void writeInfos(std::vector<int> distances, sf::RenderWindow &window);
    void writeTextOnWindow(sf::RenderWindow &window, sf::Text &text, std::vector<int> distances, std::string textValue, int rowNumber);
    sf::Texture texture;
    sf::Sprite shape;
    int lives;
    int keys;
    std::vector<Bomb> bombs;
    std::vector<int> cordinates;
};

#endif