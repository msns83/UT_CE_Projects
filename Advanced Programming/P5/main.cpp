#include "./Import/properties.hpp"
#include "./Libraries/interface.hpp"
#include "./Libraries/game.hpp"

int main()
{
    Game bomberMan(Map_Address);
    Interface window(&bomberMan);

    return 0;
}