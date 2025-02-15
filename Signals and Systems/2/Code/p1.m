clear;clc;close all;

[file,path] = uigetfile({'*.jpg;*.png'},'Select your image');
image = imread([path file]);
image = imresize(image, [300 500]);

figure;
subplot(2,2,1)
imshow(image)
title('Base')

subplot(2,2,2)
image = mygrayfun(image);
imshow(image)
title('Gray')

subplot(2,2,3)
image = mybinaryfun(image, 100);
imshow(image)
title('Binary')

subplot(2,2,4)
image = myremovecom(image,300)-myremovecom(image,2300);
imshow(image)
title('Cleaned')

[L,maxSegment] = mysegmentation(image);
maxSegment = maxSegment+1;
hold on

label_positions = zeros(2,maxSegment-1);
for i = 1:maxSegment-1
    [r,c] = find(L == i);
    mc = min(c,[],'all');
    mr = min(r,[],'all');
    Mc = max(c,[],'all');
    Mr = max(r,[],'all');
    label_positions(1,i) = i;
    label_positions(2,i) = mc;
    rectangle('Position',[mc,mr,Mc-mc,Mr-mr],'EdgeColor','b','LineWidth',2)
end

[temp,indexs] = sort(label_positions(2,:));
label_positions(1,:) = label_positions(1,indexs);
label_positions(2,:) = label_positions(2,indexs);

files=dir('English_Set');
len=length(files)-2;
TRAIN=cell(2,len);
for i=1:len
   TRAIN{1,i}=imread(['English_Set','/',files(i+2).name]);
   TRAIN{2,i}=files(i+2).name(1);
end

figure
result = [];

for i = 1:maxSegment-1
    [r,c] = find(L == label_positions(1,i));
    character = image(min(r):max(r), min(c):max(c));
    subplot(1,maxSegment-1,i)
    imshow(character)
    decision = cell(2,1);
    decision{1,1} = 0;
    decision{2,1} = '';

    for j = 1:length(TRAIN)
        temp = corr2(imresize(TRAIN{1,j},size(character)), character);
        if temp >= 0.45 && temp >= decision{1,1}
            decision{1,1} = temp;
            decision{2,1} = TRAIN{2,j};
        end
    end

    result = [result decision{2,1}];
end

disp(result)
file = fopen('result.txt', 'wt');
fprintf(file,'%s\n',result);
fclose(file);
