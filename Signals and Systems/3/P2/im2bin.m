function result = im2bin(img, thresh)
    result = false(size(img,1),size(img,2));
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            if img(i,j)<= thresh
                result(i,j) = 1;
            end
        end
    end
end