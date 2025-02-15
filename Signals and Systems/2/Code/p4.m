clear; clc; close all;

select1 = 6;
select2 = 17;
vidObj = VideoReader('video.mov');
figure
subplot(2,2,1)
frame1 = read(vidObj, select1);
imshow(frame1)
subplot(2,2,2)
frame2 = read(vidObj, select2); 
imshow(frame2)


image1 = rgb2gray(frame1);
image1 = mybinaryfun(image1,200);
image1 = ~image1 ;
image1 = bwareaopen(image1, 10000);
[L1, n1] = bwlabel(image1);
stats1 = regionprops(L1, 'BoundingBox', 'Area');

subplot(2,2,3)
imshow(image1)
hold on
for i = 1:n1
    bbox = stats1(i).BoundingBox;
    rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2); 
end
hold off

image2 = rgb2gray(frame2);
image2 = mybinaryfun(image2,200);
image2 = ~image2 ;
image2 = bwareaopen(image2, 10000);
[L2, n2] = bwlabel(image2);
stats2 = regionprops(L2, 'BoundingBox', 'Area');

subplot(2,2,4)
imshow(image2)
hold on
for i = 1:n2
    bbox = stats2(i).BoundingBox;
    rectangle('Position', bbox, 'EdgeColor', 'b', 'LineWidth', 2); 
end
hold off

scale = stats2(2).BoundingBox(4)/stats1(2).BoundingBox(4);
scale = scale -1;
measure_m_px = 3 / stats2(1).BoundingBox(4);
distance_px = ceil(stats2(2).BoundingBox(2) + scale*stats1(2).BoundingBox(4) - stats1(2).BoundingBox(2));
distance_m =ceil(distance_px * measure_m_px);
time_s = (select2-select1+1)* (1/vidObj.FrameRate);
speed_m_s = ceil(distance_m / time_s);

disp(['speed is about ' , num2str(speed_m_s) , ' m/s !'])


main_image = frame2;
main_image = imresize(main_image, [10000 6000]); % you should change these numbers for different picture kinds
image = rgb2gray(main_image);
image = mybinaryfun(image, 108);
image = bwareaopen(image, 4000); % you should change these numbers for different picture kinds

figure
subplot(1,2,1)
imshow(main_image)
subplot(1,2,2)
imshow(image)
hold on

[labeled_img, num] = bwlabel(image);
stats = regionprops(labeled_img, 'BoundingBox', 'Area');

y_coords = arrayfun(@(x) x.BoundingBox(2), stats);  
[y_coords_sorted, sortIndex] = sort(y_coords);  
sorted_stats = stats(sortIndex);
cords = {};

for k = 1:num
    bbox = sorted_stats(k).BoundingBox;
    if bbox(3) < bbox(4)*1.1
        rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
        cords{end+1} = bbox ;    
    end
end
hold off

tresh = 10;

for i = 1:length(cords)-2
    if abs(cords{i}(2) -cords{i+1}(2)) < tresh && abs(cords{i}(2) -cords{i+2}(2)) < tresh && abs(cords{i+1}(2) -cords{i+2}(2)) < tresh
        plate_cord = [cords{i}(1)-cords{i}(3), cords{i}(2)-2*tresh,13*cords{i}(3),cords{i}(4)+4*tresh];
        break ;
    end
end

plate = imcrop(main_image,plate_cord);
figure 
imshow(plate)

image = plate;

image = imresize(image, [300 500]);

figure;
subplot(2,2,1)
imshow(image)
title('Base')

subplot(2,2,2)
image = rgb2gray(image);
imshow(image)
title('Gray')

subplot(2,2,3)
image = imbinarize(image);
image = ~image;
imshow(image)
title('Binary')

subplot(2,2,4)
image = bwareaopen(image,500) - bwareaopen(image,8000);
imshow(image)
title('Cleaned')

[L,maxSegment] = bwlabel(image);
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

files=dir('Persian_Set');
len=length(files)-2;
TRAIN=cell(2,len);
for i=1:len
   TRAIN{1,i}=imread(['Persian_Set','/',files(i+2).name]);
   TRAIN{2,i}=files(i+2).name(1);
end

figure
result = [];
file = fopen('result.txt', 'wt');

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
        if temp >= 0.5 && temp >= decision{1,1}
            decision{1,1} = temp;
            decision{2,1} = TRAIN{2,j};
        end
    end

    disp(decision{2,1});
    fprintf(file,'%c\n',decision{2,1});
    result = [result decision{2,1}];
end


fclose(file);
