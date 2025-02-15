clc;clear;close all

[x,fs] = audioread("voice.wav");
disp(['fs = ',num2str(fs)]);

figure;
plot((0:length(x)-1) * (1/fs),x);
xlabel('t (s)');

sound(x,fs);
audiowrite('x.wav',x,fs);


speed = 1.2 ;
new_audio1 = p4_3('voice.wav',2);
new_audio2 = p4_4('voice.wav',speed);
figure;
plot((0:length(new_audio2)-1) * (1/(fs)),new_audio2);








