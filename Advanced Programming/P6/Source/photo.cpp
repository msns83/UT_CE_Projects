#include "photo.hpp"
#include <iostream>

using namespace std;

Photo ::Photo(string photoAddress, string _outputPath)
{
    read(bmp, photoAddress);
    create(preBmp, bmp.infoHdr.width, bmp.infoHdr.height);
    preBmp = bmp;
    outputPath = _outputPath;
}

void Photo::applyFilter(Filter *filter)
{
    filter->applyOnArea(&bmp, &preBmp);
    bmp = preBmp;
}

void Photo::save()
{
    write(bmp, outputPath);
    delete bmp.fileData;
}