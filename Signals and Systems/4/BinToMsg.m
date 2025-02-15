function message = BinToMsg(coded)

    GenerateMapset();
    load MAPSET.mat Mapset
    
    coded = coded(1:floor(length(coded)/5)*5);
    coded = reshape(coded,5,length(coded)/5)';
    while coded(end,:) ~= '11111'
        coded = coded(1:end-1,:);
    end
    coded = coded(1:end-1,:);
    message = [];

    for rw = 1:size(coded,1)
        bincode = coded(rw,:);
        bincode = convertCharsToStrings(bincode);
        tmp = [convertCharsToStrings(Mapset(2,:))]==bincode;
        if sum(tmp,"all") == 0
            errordlg(['The message contains characters not defined ' ...
                'in the map set'])
        close;
        error('The message contains characters not defined in the map set')
        end
        message = [message Mapset{1,tmp}];
    end

end