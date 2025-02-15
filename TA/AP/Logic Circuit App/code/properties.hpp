#ifndef PROPS
#define PROPS

#include <vector>
#include <string>

class Props
{
public:
    static const int z;
    static const std::string prototype_id;
    static const std::string input_wire_id;
    static const std::string output_wire_id;
    static const std::string z_sign;
    static const std::vector<std::string> command_types;
    static const std::vector<std::string> error_types;
};

#endif
