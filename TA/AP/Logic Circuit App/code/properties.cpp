#include <vector>
#include <string>
#include "properties.hpp"

const int Props::z = -1;
const std::string Props::z_sign = "z";
const std::string Props::prototype_id = "-";
const std::string Props::input_wire_id = "in";
const std::string Props::output_wire_id = "out";
const std::vector<std::string> Props::command_types = {"new_module", "add", "connect", "end_module", "put", "print"};
const std::vector<std::string> Props::error_types = {"gate/module not found", "duplicate ID", "this module already exists",
                                                     "incompatible inputs", "ID not found", "invalid connection",
                                                     "value not valid"};