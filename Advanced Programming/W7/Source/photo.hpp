#ifndef PHOTO
#define PHOTO

#include <vector>
#include <string>
#include "bmp.hpp"
#include "filter.hpp"

class Photo
{
public:
    Photo(std::string photoAddress, std::string _outputPath);
    void applyFilter(Filter *filter);
    void save();

private:
    Bmp bmp;
    Bmp preBmp;
    std::string outputPath;
};

#endif