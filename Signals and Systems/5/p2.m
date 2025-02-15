clc;
clear;
close all;

Mapset = cell(2, 32);

for i = 1:26
    Mapset{1, i} = char(uint8('a') + i - 1);
    Mapset{2, i} = dec2bin(i - 1, 5);
end

Mapset{1, 27} = ' ';
Mapset{2, 27} = dec2bin(26 , 5);

Mapset{1, 28} = '.';
Mapset{2, 28} = dec2bin(27 , 5);

Mapset{1, 29} = ',';
Mapset{2, 29} = dec2bin(28 , 5);

Mapset{1, 30} = '!';
Mapset{2, 30} = dec2bin(29 , 5);

Mapset{1, 31} = '"';
Mapset{2, 31} = dec2bin(30 , 5);

Mapset{1, 32} = ';';
Mapset{2, 32} = dec2bin(31 , 5);

user_message = 'signal;';
t1 = 0:0.01:(length(user_message)*5)-0.01;
t5 = 0:0.01:(length(user_message))-0.01;

signal1 = coding_freq(user_message, 1, Mapset);
signal5 = coding_freq(user_message, 5, Mapset);

figure;
subplot(2,1,1);
plot(t1,signal1);
title('Bit Rate = 1');
subplot(2,1,2);
plot(t5,signal5);
title('Bit Rate = 5');

recieved_message1 = decoding_freq(signal1, 1, Mapset);
recieved_message5 = decoding_freq(signal5, 5, Mapset);
disp(recieved_message1);
disp(recieved_message5);


signal5 = signal5 + 0.01*randn(1, length(signal5));
signal1 = signal1 + 0.01*randn(1, length(signal1));

recieved_message1 = decoding_freq(signal1, 1, Mapset);
recieved_message5 = decoding_freq(signal5, 5, Mapset);
disp(recieved_message1);
disp(recieved_message5);


user_message = 'signal;';

bit_rate = [1, 5] ;
noise_coef = 0.01:0.01:2;
result = zeros(3, length(noise_coef));
test_repeat = zeros(1, 50);
for i = 1:length(bit_rate)
    signal = coding_freq(user_message, bit_rate(i), Mapset);
    for j = 1:length(noise_coef)
        for k = 1:50
            noisy_signal = signal + noise_coef(j) * randn(1, length(signal));
            my_message = decoding_freq(noisy_signal, bit_rate(i), Mapset);
            test_repeat(k) = strcmp(my_message, user_message); 
        end
        result(i,j) = sum(test_repeat, "all")/length(test_repeat);
        result(3,j) = noise_coef(j) ;
    end
end