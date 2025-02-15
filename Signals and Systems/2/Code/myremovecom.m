function cleared_image = myremovecom(image, n)
    
    [L, num] = mysegmentation(image);
    cleared_image = false(size(image));
 
    for label = 1:num
        component = (L == label);
        if sum(component(:)) >= n
            cleared_image = cleared_image | component;
        end
    end

end
