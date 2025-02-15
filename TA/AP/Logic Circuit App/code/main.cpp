#include "interface.hpp"
#include "circuit.hpp"
using namespace std;

int main()
{
    // In "print" command properties in pdf file there are
    // two different error texts for incorrect id, "Invalid ID" and "ID not found"
    // in this code "ID not found" has been used.

    Interface terminal;
    Circuit circuit;

    terminal.read_inputs();
    circuit.read_commands(terminal.get_commands());
    terminal.print_results(circuit.get_responses());

    return 0;

    // make file
}