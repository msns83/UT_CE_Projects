function binMsg = msgToBin(msg)
    GenerateMapset();
    load MAPSET.mat Mapset;
    msg = char(msg);
    if msg(1,end) ~= ';'
        msg = [msg ';'];
    end
    binMsg = [];
    for c = msg
        tmp = [Mapset{1,:}]==c;
        binMsg = [binMsg Mapset{2,tmp}];
    end
end