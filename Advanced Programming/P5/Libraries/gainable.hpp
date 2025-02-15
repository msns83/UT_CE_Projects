#ifndef GAINABLE_ITEMS
#define GAINABLE_ITEMS

#include <SFML/Graphics.hpp>
#include "../Import/properties.hpp"
#include <vector>

class Gainable
{
public:
    void draw(sf::RenderWindow &window);
    sf::FloatRect getBound();
    void create(std::vector<int> inputCordinates, std::string picAddress);

private:
    sf::Texture texture;
    sf::Sprite shape;
    std::vector<int> cordinates;
    std::string picAddress;
};

#endif