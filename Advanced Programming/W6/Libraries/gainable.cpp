#include "gainable.hpp"
#include "../Import/properties.hpp"
#include <SFML/Graphics.hpp>
using namespace std;
using namespace sf;

void Gainable ::create(vector<int> inputCordinates, string inputPicAddress)
{
    cordinates = inputCordinates;
    picAddress = inputPicAddress;
    if (!texture.loadFromFile(picAddress))
        abort();
    shape.setTexture(texture);
    float size = 1.4;
    float space = (2 * size) / (size - 1);
    shape.scale((Resolution / size) / (float)texture.getSize().x, (Resolution / size) / (float)texture.getSize().y);
    shape.setPosition(cordinates[0] + (Resolution / space), cordinates[1] + (float)(Resolution / space));
};

void Gainable ::draw(RenderWindow &window)
{
    if (!texture.loadFromFile(picAddress))
        abort();
    shape.setTexture(texture);
    window.draw(shape);
}

FloatRect Gainable ::getBound()
{
    return shape.getGlobalBounds();
}