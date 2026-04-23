#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <vector>
#include <time.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string.h>
#include <pthread.h>

using namespace std;

#define MNIST_IMG_FILE "data/t10k-images-idx3-ubyte"
#define MNIST_LBL_FILE "data/t10k-labels-idx1-ubyte"
#define HIDDEN_WEIGHTS_FILE "net_params/hidden_weights.txt"
#define HIDDEN_BIASES_FILE "net_params/hidden_biases.txt"
#define OUTPUT_WEIGHTS_FILE "net_params/out_weights.txt"
#define OUTPUT_BIASES_FILE "net_params/out_biases.txt"

#define IN_CELLS 784
#define HIDDEN_CELLS 256
#define OUT_CELLS 10
#define MAX_TEST 10000

struct Hidden_Node {
    double weights[IN_CELLS];
    double bias;
    double output;
};

struct Output_Node {
    double weights[HIDDEN_CELLS];
    double bias;
    double output;
};

struct MNIST_Image {
    uint8_t pixel[IN_CELLS];
};

struct MNIST_ImageFileHeader {
    uint32_t magicNumber, maxImages, imgWidth, imgHeight;
};

struct MNIST_LabelFileHeader {
    uint32_t magicNumber, maxImages;
};

typedef uint8_t MNIST_Label;

vector<Hidden_Node> hidden_nodes(HIDDEN_CELLS);
vector<Output_Node> output_nodes(OUT_CELLS);
pthread_barrier_t hidden_barrier;

void locateCursor(int row,int col){
    printf("%c[%d;%dH",27,row,col);
}

void clearScreen(){
    printf("\e[1;1H\e[2J");
}

void displayLoadingProgress(int idx, int y, int x){
    float p = float(idx+1)/MAX_TEST*100;
    if(y&&x)
        locateCursor(y,x);
    printf("Testing image %5d/%5d [%2d%%]\n", idx+1, MAX_TEST, int(p));
}

void displayProgress(int idx,int err,int y,int x){
    double success = 1.0 - double(err)/(idx+1);
    if(y&&x)
        locateCursor(y,x);

    printf("Correct=%5d  Incorrect=%5d  Rate=%5.2f%%\n", idx+1-err, err, success*100);
}

uint32_t flipBytes(uint32_t n){
    return ((n&0xFF)<<24)|((n&0xFF00)<<8) | ((n&0xFF0000)>>8)|((n&0xFF000000)>>24);
}

void readImageHeader(FILE* file, MNIST_ImageFileHeader* header){
    fread(&header->magicNumber, 4, 1, file);
    fread(&header->maxImages, 4, 1, file);
    fread(&header->imgWidth, 4, 1, file);
    fread(&header->imgHeight, 4, 1, file);
    header->magicNumber = flipBytes(header->magicNumber);
    header->maxImages = flipBytes(header->maxImages);
    header->imgWidth = flipBytes(header->imgWidth);
    header->imgHeight = flipBytes(header->imgHeight);
}

void readLabelHeader(FILE* file, MNIST_LabelFileHeader* header){
    fread(&header->magicNumber, 4, 1, file);
    fread(&header->maxImages, 4, 1, file);
    header->magicNumber = flipBytes(header->magicNumber);
    header->maxImages = flipBytes(header->maxImages);
}

FILE* openImageFile(const char* name){
    FILE* f=fopen(name,"rb");
    MNIST_ImageFileHeader h;
    readImageHeader(f,&h);
    return f;
}

FILE* openLabelFile(const char* name){
    FILE* f=fopen(name,"rb");
    MNIST_LabelFileHeader h;
    readLabelHeader(f,&h);
    return f;
}

MNIST_Image getImage(FILE* file){
    MNIST_Image image;
    fread(&image, sizeof(image),1,file);
    return image;
}

MNIST_Label getLabel(FILE* file){
    MNIST_Label label;
    fread(&label, sizeof(label), 1, file);
    return label;
}


void allocateHiddenParameters(){
    int idx = 0;
    int bidx = 0;

    ifstream weights(HIDDEN_WEIGHTS_FILE);

    for(string line; getline(weights, line); )  {
        stringstream in(line);
        for (int i = 0; i < 28*28; ++i){
            in >> hidden_nodes[idx].weights[i];
      }
      idx++;
    }
    weights.close();

    ifstream biases(HIDDEN_BIASES_FILE);
    for(string line; getline(biases, line); ) 
    {
        stringstream in(line);
        in >> hidden_nodes[bidx].bias;
        bidx++;
    }
    biases.close();

}

void allocateOutputParameters(){
    int idx = 0;
    int bidx = 0;
    ifstream weights(OUTPUT_WEIGHTS_FILE);
    for(string line; getline(weights, line); ) 
    {
        stringstream in(line);
        for (int i = 0; i < 256; ++i){
            in >> output_nodes[idx].weights[i];
      }
      idx++;
    }
    weights.close();

    ifstream biases(OUTPUT_BIASES_FILE);
    for(string line; getline(biases, line); )
    {
        stringstream in(line);
        in >> output_nodes[bidx].bias;
        bidx++;
    }
    biases.close();

}

int getNNPrediction(){
    double m = output_nodes[0].output;
    int mi = 0 ;

    for(int i=1;i<OUT_CELLS;i++){
      if(output_nodes[i].output>m){
        m=output_nodes[i].output; mi=i;
      }
    }
    return mi;
}

struct HiddenArgs { MNIST_Image* img; int tid; };
struct OutputArgs { int oid; };

void* hiddenThread(void* vp){

    HiddenArgs* a = static_cast<HiddenArgs*>(vp);
    MNIST_Image* img = a->img;

    int start = a->tid * (HIDDEN_CELLS/HIDDEN_CELLS) * 0 + a->tid*32;
    start = a->tid*32;
    int end = start+32;

    for(int i=start;i<end;i++){
        double sum = hidden_nodes[i].bias;

        for(int j=0;j<IN_CELLS;j++)
            sum += img->pixel[j] * hidden_nodes[i].weights[j];

        hidden_nodes[i].output = sum>0 ? sum : 0;
    }

    pthread_barrier_wait(&hidden_barrier);
    return nullptr;
}

void* outputThread(void* vp){

    OutputArgs* a = static_cast<OutputArgs*>(vp);
    int i = a->oid;
    double sum = output_nodes[i].bias;

    for(int j=0;j<HIDDEN_CELLS;j++)
        sum += hidden_nodes[j].output * output_nodes[i].weights[j];

    output_nodes[i].output = 1.0/(1.0+exp(-sum));

    return nullptr;
}

struct ResultArgs {
    int idx;
    MNIST_Label label;
    int* errCount;
};

void* resultThread(void* vp){
    auto* arg = static_cast<ResultArgs*>(vp);
    int pred = getNNPrediction();
    if(pred != arg->label) 
        ++*(arg->errCount);
    displayProgress(arg->idx, *(arg->errCount), 1, 40);
    return nullptr;
}

void testNN_parallel(){
    FILE* imageFile = openImageFile(MNIST_IMG_FILE);
    FILE* labelFile = openLabelFile(MNIST_LBL_FILE);

    int errCount = 0;

    pthread_barrier_init(&hidden_barrier, nullptr, 8);

    for(int idx=0; idx < MAX_TEST; idx++){
        displayLoadingProgress(idx,1,1);

        MNIST_Image image = getImage(imageFile);
        MNIST_Label label = getLabel(labelFile);

        pthread_t hiddenTid[8];
        HiddenArgs hiddenArg[8];
        for(int t=0; t<8; t++){
            hiddenArg[t]= {&image,t};
            pthread_create(&hiddenTid[t], nullptr, hiddenThread, &hiddenArg[t]);
        }

        for(int t=0; t<8; t++)
            pthread_join(hiddenTid[t], nullptr);

        pthread_t outTid[OUT_CELLS];
        OutputArgs outArg[OUT_CELLS];
        for(int i=0; i<OUT_CELLS; i++){
            outArg[i] = {i};
            pthread_create(&outTid[i], nullptr, outputThread, &outArg[i]);
        }

        for(int i=0; i<OUT_CELLS; i++)
            pthread_join(outTid[i], nullptr);

        pthread_t rtid;
        ResultArgs rarg{ idx, label, &errCount };
        pthread_create(&rtid, nullptr, resultThread, &rarg);
        pthread_join(rtid, nullptr);
    }

    pthread_barrier_destroy(&hidden_barrier);
    fclose(imageFile);
    fclose(labelFile);
}

int main(){
    time_t start = time(NULL);
    clearScreen();

    allocateHiddenParameters();
    allocateOutputParameters();

    testNN_parallel();

    locateCursor(2,1);
    double secs = difftime(time(NULL),start);
    printf("Done in %.1f sec \n",secs);
    return 0;
}