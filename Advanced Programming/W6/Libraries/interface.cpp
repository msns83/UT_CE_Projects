#include <SFML/Graphics.hpp>
#include "./interface.hpp"
#include "../Import/properties.hpp"
using namespace std;
using namespace sf;

Interface::Interface(Game *inputGame) : window(VideoMode(inputGame->getGameWindowSize()[0], inputGame->getGameWindowSize()[1]), Game_Name)
{
    game = inputGame;
    while (window.isOpen())
    {
        checkForEvent();
        if (game->isOver())
            break;
        ticWindow();
    }
}

void Interface ::CheckWhichKeyPressed(Event &event)
{
    if (event.key.code == Keyboard::Down)
        game->playerMove(DOWN);
    else if (event.key.code == Keyboard::Up)
        game->playerMove(UP);
    else if (event.key.code == Keyboard::Left)
        game->playerMove(LEFT);
    else if (event.key.code == Keyboard::Right)
        game->playerMove(RIGHT);
    else if (event.key.code == Keyboard::X)
        game->plantBomb();
}

void Interface ::ticWindow()
{
    game->enemyMove();
    game->CheckEnemyCollision();
    game->checkBombs();
    game->draw(window);
    window.display();
}

void Interface ::checkForEvent()
{
    Event event;
    while (window.pollEvent(event))
    {
        if (event.type == Event::Closed)
            window.close();
        if (event.type == Event::KeyPressed)
            CheckWhichKeyPressed(event);
    }
}