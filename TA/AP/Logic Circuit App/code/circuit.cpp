#include <string>
#include <vector>
#include <algorithm>
#include "circuit.hpp"
using namespace std;

Circuit ::Circuit()
{
    circuit = new Module("circuit", 0);
    module_types = {new And, new Or, new Not, new Xor, new Nand, new Nor};
    current_module = circuit;
}

Circuit ::~Circuit()
{
    circuit->clean_module();
    for (auto module_type : module_types)
        module_type->clean_module();
}

void Circuit::read_commands(vector<vector<string>> *commands)
{
    for (auto command : *commands)
        for (int i = 0; i < Props::command_types.size(); i++)
            if (Props::command_types[i] == command[0])
                (this->*commands_functions[i])(command);
}

string Circuit::check_new_module_name(string selected_name)
{
    for (auto type : module_types)
        if (type->get_name() == selected_name)
            throw Props::error_types[2];
    return selected_name;
}

void Circuit::create_module(vector<string> new_module_props)
{
    try
    {
        Module *new_module = new Module(check_new_module_name(new_module_props[1]), stoi(new_module_props[2]));
        module_types.push_back(new_module);
        current_module = new_module;
    }
    catch (const string &error)
    {
        responses.push_back(error);
    }
}

Module *Circuit::find_module_type(string selected_module_type)
{
    for (auto type : module_types)
        if (type->get_name() == selected_module_type)
            return type;
    throw Props::error_types[0];
}

void Circuit::add_module(vector<string> selected_module_props)
{
    try
    {
        Module *selected_module_type = NULL;
        vector<string> io_list(selected_module_props.begin() + 3, selected_module_props.begin() + selected_module_props.size());
        current_module->add_sub_module(find_module_type(selected_module_props[1]), selected_module_props[2], io_list);
    }
    catch (const string &error)
    {
        responses.push_back(error);
    }
}

void Circuit::connect_wires(vector<string> wires_props)
{
    try
    {
        current_module->connect_wire(wires_props[1], wires_props[2]);
    }
    catch (const string &error)
    {
        responses.push_back(error);
    }
}

void Circuit::put_value_wire(std::vector<std::string> value_props)
{
    try
    {
        current_module->put_value_wire(value_props[1], stoi(value_props[2]));
    }
    catch (const string &error)
    {
        responses.push_back(error);
    }
}

void Circuit::show_output_value(vector<string> module_props)
{
    try
    {
        responses.push_back(current_module->show_output_value(module_props[1]));
    }
    catch (const string &error)
    {
        responses.push_back(error);
    }
}