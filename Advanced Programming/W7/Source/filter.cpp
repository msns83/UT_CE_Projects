#include "filter.hpp"
#include "properties.hpp"
#include <vector>
using namespace std;

Filter ::Filter(vector<int> _view)
{
    for (int i = 0; i < _view.size(); i++)
        view.push_back(_view[i]);
}

void Filter ::applyOnArea(Bmp *photo, Bmp *newPhoto)
{
    picture = photo;
    prePicture = newPhoto;
    vector<int> area = view;

    if (view[0] == -1)
        view = {0, 0, photo->infoHdr.width, photo->infoHdr.height};

    for (int i = view[1]; i < view[1] + view[3]; i++)
        for (int j = view[0]; j < view[0] + view[2]; j++)
            apply(j, i);
    
    view = area ;
}

KernelFilter ::KernelFilter(int KernelType, vector<int> view) : Filter(view)
{
    kernel = KERNELS[KernelType];
}

void KernelFilter ::apply(int x, int y)
{
    vector<float> RGB = {0, 0, 0};
    createNeighbourMatrix(x, y, RGB);
    prePicture->data[y][x] = Pixel(validRGB(RGB[0]), validRGB(RGB[1]), validRGB(RGB[2]));
}

void KernelFilter ::createNeighbourMatrix(int x, int y, vector<float> &RGB)
{
    for (int i = -1; i < 2; i++)
        for (int j = -1; j < 2; j++)
        {
            vector<int> neighbourXY = {x + j, y + i};
            if (x + j < view[0] || view[0]+view[2] - 1 < x + j || y + i < view[1] || view[1]+view[3] - 1 < y + i)
                neighbourXY = {x, y};

            RGB[0] += (picture->data[neighbourXY[1]][neighbourXY[0]].red) * kernel[i + 1][j + 1];
            RGB[1] += (picture->data[neighbourXY[1]][neighbourXY[0]].grn) * kernel[i + 1][j + 1];
            RGB[2] += (picture->data[neighbourXY[1]][neighbourXY[0]].blu) * kernel[i + 1][j + 1];
        }
}

float KernelFilter ::validRGB(float number)
{
    number = (number < 0.0) ? 0.0 : number;
    number = (255.0 < number) ? 255.0 : number;
    return number;
}

void InvertFilter ::apply(int x, int y)
{
    prePicture->data[y][x] = Pixel(255.0 - picture->data[y][x].red, 255.0 - picture->data[y][x].grn, 255.0 - picture->data[y][x].blu);
}

void GarayscaleFilter::apply(int x, int y)
{
    float average = (picture->data[y][x].red + picture->data[y][x].grn + picture->data[y][x].blu) / 3.0;
    prePicture->data[y][x] = Pixel(average, average, average);
}