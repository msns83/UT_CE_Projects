function threshold = cal_threshold(image, alpha)

    clone = double(image);
    clone(:,2:end) = clone(:,2:end) - clone(:,1:end-1);
    
    r=1;
    threshold_options = [];
    
    while r+4 <= size(image,1)
        c=1;
        while c+4 <= size(image,2)
            temp = clone(r:r+4,c:c+4);
            threshold_options = [threshold_options sum(abs(temp),'all')];
            c = c + 5;
        end
        r = r + 4;
    end
    
    threshold_options = sort(threshold_options);
    threshold = threshold_options( ceil(alpha*length(threshold_options)) );
end