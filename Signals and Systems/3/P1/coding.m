function result = coding(msg, image, mapset, threshold)

    clone = double(image);
    clone(:,2:end) = clone(:,2:end) - clone(:,1:end-1);

    % Segment image 

    segmentation = zeros(size(image));
    seg_idx = 1;
    r=1;
    while r+4 <= size(image,1)
        c=1;
        while c+4 <= size(image,2)
            temp = clone(r:r+4,c:c+4);
            if ( sum(abs(temp),'all') >= threshold && ~any(segmentation(r:r+4,c:c+4), 'all') )
                segmentation(r:r+4,c:c+4) = seg_idx;
                seg_idx = seg_idx + 1;
            end
            c = c + 5;
        end
        r = r + 4;
    end

    % Check num of segments

    if (seg_idx-1)*5 < length(msg)
        close;
        error('large threshold value or long message length')
    end

    % Put code in image
    
    result = image;
    msg = char(msg);

    bit = 1;
    segment = 1;
    while bit <= length(msg)
        temp = 0;
        [r,c] = find(segmentation==segment);
        c = min(c);
        r = min(r);
        while temp <= 4 && bit <= length(msg)
            ch = mapset{2,[mapset{1,:}] == msg(bit)};
            for n = 0:4
                temp_result = floor(double(result(r+temp,c+n))/2)*2;
                if ch(n+1) == '1'
                    temp_result = temp_result + 1;
                end
                result(r+temp,c+n) = uint8(temp_result);
            end
            temp = temp + 1;
            bit = bit + 1;
        end
        segment = segment + 1;
    end
end
