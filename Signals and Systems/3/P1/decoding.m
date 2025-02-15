function result = decoding(image, mapset, threshold)
    
    clone = double(image);
    clone(:,2:end) = clone(:,2:end) - clone(:,1:end-1);

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

    result = '';
    chr = ' ';
    segment = 1;
    while chr ~= ';'
        temp = 0;
        [r,c] = find(segmentation==segment);
        c = min(c);
        r = min(r);
        while temp <= 4 && chr ~= ';'
            chr = '00000';
            for n = 0:4
                q = image(r+temp,c+n);
                if mod(q,2)==1
                    chr(n+1) = '1';
                end
            end
            for i = 1:length(mapset)
                if mapset{2,i} == chr
                    chr = mapset{1,i};
                end
            end
            result = [result chr];
            temp = temp + 1;
        end
        segment = segment + 1;
    end
end