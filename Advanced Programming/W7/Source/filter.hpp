#ifndef FILTER
#define FILTER

#include <vector>
#include <string>
#include "bmp.hpp"

class Filter
{
public:
    Filter(std::vector<int> _view);
    virtual void apply(int x, int y) = 0;
    void applyOnArea(Bmp *photo, Bmp *newPhoto);
    virtual ~Filter() = default;

protected:
    Bmp *picture;
    Bmp *prePicture;
    std::vector<int> view;
};

class KernelFilter : public Filter
{
public:
    KernelFilter(int KernelType, std::vector<int> view);
    void apply(int x, int y);

private:
    float validRGB(float number);
    void createNeighbourMatrix(int x, int y, std::vector<float> &RGB);
    std::vector<std::vector<float>> kernel;
    std::vector<std::vector<Pixel>> matrix;
};

class InvertFilter : public Filter
{
public:
    InvertFilter(std::vector<int> view) : Filter(view){};
    void apply(int x, int y);
};

class GarayscaleFilter : public Filter
{
public:
    GarayscaleFilter(std::vector<int> _view) : Filter(_view){};
    void apply(int x, int y);
};

#endif