clear;clc;close all;

pcb = imread("PCB.jpg");
ic = imread('IC.png');

figure
subplot(2,3,1)
imshow(pcb)

pcb_2 = im2gray(imgaussfilt(pcb,3));
subplot(2,3,2)
imshow(pcb_2);

pcb_2 = im2bin(pcb_2, 70);
subplot(2,3,3)
imshow(pcb_2);
pcb_2 = bwareaopen(pcb_2,1000);
subplot(2,3,4)
imshow(pcb_2)

ic_2 = im2bin(im2gray(ic) , 70);
subplot(2,3,5)
imshow(ic_2)

pcb_3 = im2bin(pcb, 70);
subplot(2,3,6);
imshow(pcb_3);

[Labeled,num]=bwlabel(pcb_2);
boxes = regionprops(Labeled,'BoundingBox');

figure
subplot(1,1,1)
imshow(pcb)
hold on
treshold = 0.75;
for n=1:size(boxes,1)
    part = imcrop(pcb_3, boxes(n).BoundingBox) ;
    part = imresize(part, size(ic_2)) ;
    first_coeff = correlate_coeff(part,ic_2) ;
    second_coeff = correlate_coeff(part,imrotate(ic_2,180)) ; 
    if first_coeff >= treshold || second_coeff >= treshold
        rectangle('Position',boxes(n).BoundingBox, 'EdgeColor','r','LineWidth',3)
    end
end
hold off
