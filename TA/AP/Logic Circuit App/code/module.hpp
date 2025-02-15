#ifndef MODULE
#define MODULE

#include <vector>
#include <string>
#include "properties.hpp"

class Wire
{
public:
    Wire(std::string id_, std::string connected_module_id_);
    std::string get_id() { return id; }
    int get_value() { return value; }
    void connect_to(Wire *target_wire);
    std::string set_module_in_val(int value_);
    std::string spread_module_val(int value_);

private:
    std::string id;
    int value;
    Wire *joint_wire;
    std::string connected_module_id;
};

class Module
{
public:
    Module(std::string module_name, int num_of_inputs);
    void add_sub_module(Module *module_type, std::string module_id, std::vector<std::string> io_id);
    void clean_module();
    void put_value_wire(std::string wire_id, int value);
    void connect_wire(std::string id_from, std::string id_to);
    std::string show_output_value(std::string module_id);
    std::string get_name() { return name; }
    virtual void validate_io_num(std::vector<std::string> io_list);

protected:
    std::string id = Props::prototype_id;
    std::string name;
    Module *type = NULL;
    std::vector<Module *> sub_modules;
    Wire *output;
    std::vector<Wire *> inputs;
    std::vector<Wire *> whole_wires;

    Module(std::string module_name) { name = module_name; }
    Module(Module *type_, std::string id_, std::string name_);
    void check_duplicate_id(std::string id);
    void create_new_io(Module *new_module, std::vector<std::string> io_list);
    void create_io(int num_of_inputs);
    void process(Module *module_parent);
    virtual int calculate(std::vector<int> input_values);
    std::vector<int> get_input_values();
    Wire *find_wire_id(std::string wire_id);
    Module *search_module_id(std::string search_id);
};

#endif