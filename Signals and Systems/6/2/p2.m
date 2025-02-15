clc;clear;close;

Mapset = cell(2,12);
Mapset{1,1} = "A";
Mapset{1,2} = "A#";
Mapset{1,3} = "B";
Mapset{1,4} = "C";
Mapset{1,5} = "C#";
Mapset{1,6} = "D";
Mapset{1,7} = "D#";
Mapset{1,8} = "E";
Mapset{1,9} = "F";
Mapset{1,10} = "F#";
Mapset{1,11} = "G";
Mapset{1,12} = "G#";
Mapset{2,1} = 880;
Mapset{2,2} = 932.33;
Mapset{2,3} = 987.77;
Mapset{2,4} = 523.25;
Mapset{2,5} = 554.37;
Mapset{2,6} = 587.33;
Mapset{2,7} = 622.25;
Mapset{2,8} = 659.25;
Mapset{2,9} = 698.46;
Mapset{2,10} = 739.99;
Mapset{2,11} = 783.99;
Mapset{2,12} = 830.61;

save("MAPSET","Mapset");


st1 = 'DDGF#D|DEEDF#DE|DEF#E|DEEDF#DE|DEDF#E|DEDF#E|DDEF#EF#|F#EF#F#D|' ;
coefficients1 =[0.5 0.5 1 1 1, 0.5 0.5 0.5 0.5 0.5 0.5 1, 1 1 1 1, 0.5 0.5 0.5 0.5 0.5 0.5 1, 1 0.5 0.5 1 1, 1 0.5 0.5 1 1, 0.5 0.5 1 0.5 0.5 1, 0.5 0.5 1 1 1 ];

track1 = create_music(st1,coefficients1);
% sound(track1, 8000);

%%

st2 = 'CBAA#C#|CBAA#F|A#FCC#B|BC#CFA#|C#CFA#B|' ;
coefficients2 = [0.5 1 0.5 0.5 1,0.5 1 0.5 0.5 1,0.5 0.5 0.5 0.5 1,1 0.5 0.5 0.5 1,1 0.5 0.5 0.5 1];

track2 = create_music(st2,coefficients2);
% sound(track2, 8000);

audiowrite('mysong.wav',track2,8000);

%%

[decoded_notes, decoded_coefficients] = create_notes(track1,8000);


st1
decoded_notes
coefficients1
decoded_coefficients

