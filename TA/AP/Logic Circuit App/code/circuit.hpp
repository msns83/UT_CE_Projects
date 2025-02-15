#ifndef CIRCUIT
#define CIRCUIT

#include <vector>
#include <string>
#include "module.hpp"
#include "gate.hpp"

class Circuit
{
public:
    Circuit();
    ~Circuit();
    void read_commands(std::vector<std::vector<std::string>> *commands);
    std::vector<std::string> *get_responses() { return &responses; }

private:
    Module *circuit;
    std::vector<Module *> module_types;
    Module *current_module;

    std::vector<std::string> responses;
    std::vector<void (Circuit::*)(std::vector<std::string>)> commands_functions = {
        &Circuit::create_module, &Circuit::add_module, &Circuit::connect_wires,
        &Circuit::change_current_module, &Circuit::put_value_wire, &Circuit::show_output_value};

    void create_module(std::vector<std::string> new_module_props);
    void add_module(std::vector<std::string> selected_module_props);
    void connect_wires(std::vector<std::string> wires_props);
    void put_value_wire(std::vector<std::string> value_props);
    void show_output_value(std::vector<std::string> module_props);
    void change_current_module(std::vector<std::string> empty_command) { current_module = circuit; }
    Module *find_module_type(std::string selected_module_type);
    std::string check_new_module_name(std::string selected_name);
};

#endif