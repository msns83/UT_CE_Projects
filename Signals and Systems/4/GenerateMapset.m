function GenerateMapset()

Mapset = cell(2,32);
a_code = double('a');
for i = 0:25
    Mapset{1,i+1} = char(i+a_code);
    Mapset{2,i+1} = dec2bin(i,5);
end

Mapset{1,27} = ' ';
Mapset{2,27} = dec2bin(26,5);
Mapset{1,28} = '.';
Mapset{2,28} = dec2bin(27,5);
Mapset{1,29} = ',';
Mapset{2,29} = dec2bin(28,5);
Mapset{1,30} = '!';
Mapset{2,30} = dec2bin(29,5);
Mapset{1,31} = '"';
Mapset{2,31} = dec2bin(30,5);
Mapset{1,32} = ';';
Mapset{2,32} = dec2bin(31,5);

save('MAPSET.mat',"Mapset");
end