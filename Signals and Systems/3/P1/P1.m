clc; close all; clear;

% Part 1

Mapset = cell(2,32);
a_code = double('a');
for i = 0:25
    Mapset{1,i+1} = char(i+a_code);
    Mapset{2,i+1} = dec2bin(i,5);
end

Mapset{1,27} = ' ';
Mapset{2,27} = dec2bin(26,5);

Mapset{1,28} = '.';
Mapset{2,28} = dec2bin(27,5);

Mapset{1,29} = ',';
Mapset{2,29} = dec2bin(28,5);

Mapset{1,30} = '!';
Mapset{2,30} = dec2bin(29,5);

Mapset{1,31} = '"';
Mapset{2,31} = dec2bin(30,5);

Mapset{1,32} = ';';
Mapset{2,32} = dec2bin(31,5);

% Part 2

msg = "signal;" ;
image = im2gray(imread('image.jpg'));
threshold_alpha = 0.75 ;


threshold = cal_threshold(image, threshold_alpha) ;
coded_img = coding(msg, image, Mapset, threshold);

% Part 3

subplot(1,2,1)
imshow(image)
title("Initial")
subplot(1,2,2)
imshow(coded_img)
title("Final")

% Part 4

decoding(coded_img,Mapset,threshold)
