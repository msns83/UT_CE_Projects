#include "module.hpp"
using namespace std;

Module ::Module(string module_name, int num_of_inputs)
{
    name = module_name;
    type = NULL;
    id = Props::prototype_id;
    create_io(num_of_inputs);
}

void Module::create_io(int num_of_inputs)
{
    vector<string> io_list;
    for (int i = 0; i < num_of_inputs; i++)
        io_list.push_back(Props::input_wire_id + to_string(i));
    io_list.push_back(Props::output_wire_id);
    this->create_new_io(this, io_list);
}

void Module::create_new_io(Module *new_module, vector<string> io_list)
{
    for (int i = 0; i < io_list.size() - 1; i++)
    {
        new_module->inputs.push_back(new Wire(io_list[i], new_module->id));
        whole_wires.push_back(new_module->inputs[i]);
    }
    new_module->output = new Wire(io_list[io_list.size() - 1], new_module->id);
    whole_wires.push_back(new_module->output);
}

Module::Module(Module *type_, string id_, string name_)
{
    type = type_;
    id = id_;
    name = name_;
}

Wire::Wire(string id_, string connected_module_id_)
{
    id = id_;
    connected_module_id = connected_module_id_;
    joint_wire = NULL;
    value = Props::z;
}

void Module::check_duplicate_id(string id)
{
    for (auto sub_module : sub_modules)
        if (sub_module->id == id)
            throw Props::error_types[1];
}

void Module ::validate_io_num(vector<string> io_list)
{
    if (io_list.size() - 1 != inputs.size())
        throw Props::error_types[3];
}

void Module::add_sub_module(Module *module_type, string module_id, vector<string> io_list)
{
    check_duplicate_id(module_id);
    module_type->validate_io_num(io_list);
    Module *new_module = new Module(module_type, module_id, module_type->name);
    create_new_io(new_module, io_list);
    this->sub_modules.push_back(new_module);
}

Wire *Module ::find_wire_id(string wire_id)
{
    for (auto wire : whole_wires)
        if (wire->get_id() == wire_id)
            return wire;
    throw Props::error_types[4];
    return NULL;
}

void Module::connect_wire(string id_from, string id_to)
{
    if (id_from == id_to)
        throw Props::error_types[5];
    find_wire_id(id_from)->connect_to(find_wire_id(id_to));
}

void Wire::connect_to(Wire *target_wire)
{
    this->joint_wire = target_wire;
    target_wire->joint_wire = this;
}

void Module::clean_module()
{
    for (auto sub_module : sub_modules)
        sub_module->clean_module();
    for (auto wire : whole_wires)
        delete wire;
    delete this;
}

void Module::put_value_wire(std::string wire_id, int value)
{
    if (value != 0 && value != 1)
        throw Props::error_types[6];
    string connected_module_id = find_wire_id(wire_id)->set_module_in_val(value);
    search_module_id(connected_module_id)->process(this);
}

Module *Module::search_module_id(string search_id)
{
    for (auto module : sub_modules)
        if (module->id == search_id)
            return module;
    return NULL;
}

vector<int> Module::get_input_values()
{
    vector<int> input_values;
    for (auto input_wire : inputs)
        input_values.push_back(input_wire->get_value());
    return input_values;
}

string Wire::set_module_in_val(int value_)
{
    value = value_;
    return connected_module_id;
}

void Module ::process(Module *module_parent)
{
    int result_of_calc = type->calculate(get_input_values());
    string next_module_id = output->spread_module_val(result_of_calc);
    Module *next_module = module_parent->search_module_id(next_module_id);
    if (next_module == NULL)
        return;
    next_module->process(module_parent);
}

string Wire::spread_module_val(int value_)
{
    value = value_;
    if (joint_wire == NULL)
        return Props::prototype_id;
    joint_wire->value = value_;
    return joint_wire->connected_module_id;
}

int Module ::calculate(vector<int> input_values)
{
    for (int i = 0; i < input_values.size(); i++)
    {
        string starting_module_id = inputs[i]->spread_module_val(input_values[i]);
        search_module_id(starting_module_id)->process(this);
    }
    return this->output->get_value();
}

string Module::show_output_value(std::string module_id)
{
    Module *founded_module = search_module_id(module_id);
    if (founded_module == NULL)
        throw Props::error_types[4];
    int value = founded_module->output->get_value();
    if (value == Props::z)
        return Props::z_sign;
    return to_string(value);
}