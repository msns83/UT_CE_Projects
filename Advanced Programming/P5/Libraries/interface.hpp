#ifndef INTERFACE
#define INTERFACE

#include <vector>
#include <SFML/Graphics.hpp>
#include "../Import/properties.hpp"
#include "game.hpp"

class Interface
{
public:
    Interface(Game *InputGame);

private:
    void CheckWhichKeyPressed(sf::Event &event);
    void checkForEvent();
    void ticWindow();
    sf::RenderWindow window;
    Game *game;
};

#endif