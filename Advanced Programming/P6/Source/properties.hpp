#include <vector>
#include <string>

const int KERNEL_FILTER_COUNT = 3;

const std::vector<std::string> KERNELS_COMMANDS = {"-B", "-S", "-E", "-I", "-G"};

const std::vector<std::vector<std::vector<float>>> KERNELS =
    {{{1.0 / 16.0, 1.0 / 8.0, 1.0 / 16.0}, {1.0 / 8.0, 1.0 / 4.0, 1.0 / 8.0}, {1.0 / 16.0, 1.0 / 8.0, 1.0 / 16.0}},
     {{0.0, -1.0, 0.0}, {-1.0, 5.0, -1.0}, {0.0, -1.0, 0.0}},
     {{-2.0, -1.0, 0.0}, {-1.0, 1.0, 1.0}, {0.0, 1.0, 2.0}}};