#ifndef GATE
#define GATE

#include <vector>
#include <string>
#include "module.hpp"

class Gate : public Module
{
public:
    void validate_io_num(std::vector<std::string> io_list);

protected:
    Gate(std::string gate_name) : Module(gate_name) {};
    int and_or_func(int sensitiv, int insensitive, std::vector<int> input_values);
};

class And : public Gate
{
public:
    And() : Gate("and") {};
    int calculate(std::vector<int> input_values);
};

class Or : public Gate
{
public:
    Or() : Gate("or") {};
    int calculate(std::vector<int> input_values);
};

class Not : public Gate
{
public:
    Not() : Gate("not") {};
    int calculate(std::vector<int> input_values);
    void validate_io_num(std::vector<std::string> io_list);
};

class Xor : public Gate
{
public:
    Xor() : Gate("xor") {};
    int calculate(std::vector<int> input_values);
};

class Nand : public Gate
{
public:
    Nand() : Gate("nand") {};
    int calculate(std::vector<int> input_values);
};

class Nor : public Gate
{
public:
    Nor() : Gate("nor") {};
    int calculate(std::vector<int> input_values);
};

#endif