#include <vector>
#include <string>
#include "Interface.hpp"
#include "app.hpp"
#include "properties.hpp"
using namespace std;

int main(int argc, char *argv[])
{
    Interface terminal(argc, argv, KERNELS_COMMANDS);
    terminal.takeFilePaths();

    App filterApplier(terminal.getFilters(), terminal.getFiltersProp(), terminal.getFilePaths());
    filterApplier.applyFilters();

    return 0;
}