#include "gate.hpp"
using namespace std;

void Gate ::validate_io_num(vector<string> io_list)
{
    if (io_list.size() - 1 < 2)
        throw Props::error_types[3];
}

void Not ::validate_io_num(vector<string> io_list)
{
    if (io_list.size() - 1 != 1)
        throw Props::error_types[3];
}

int Not::calculate(vector<int> input_values)
{
    if (input_values[0] == 0)
        return 1;
    else if (input_values[0] == Props::z)
        return Props::z;
    return 0;
}

int Gate::and_or_func(int sensitiv, int insensitive, vector<int> input_values)
{
    bool has_z = false;
    for (int value : input_values)
    {
        if (value == sensitiv)
            return sensitiv;
        if (value == Props::z)
            has_z = true;
    }
    if (has_z)
        return Props::z;
    return insensitive;
}

int And::calculate(vector<int> input_values)
{
    return and_or_func(0, 1, input_values);
}

int Or::calculate(vector<int> input_values)
{
    return and_or_func(1, 0, input_values);
}

int Nand::calculate(vector<int> input_values)
{
    Not not_gate;
    And and_gate;
    return not_gate.calculate({and_gate.calculate(input_values)});
}

int Nor::calculate(vector<int> input_values)
{
    Not not_gate;
    Or or_gate;
    return not_gate.calculate({or_gate.calculate(input_values)});
}

int Xor::calculate(vector<int> input_values)
{
    int count_of_ones = 0;
    for (int value : input_values)
    {
        if (value == 1)
            count_of_ones++;
        if (value == Props::z)
            return Props::z;
    }
    return count_of_ones % 2;
}