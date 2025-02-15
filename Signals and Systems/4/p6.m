clear;close;clc;

message = cell(2,3);
noise_str = 1.2ا ;
for bit_rate = 1:3
    signal = coding_amp('signal',bit_rate,100);
    signal = signal + noise_str*randn(size(signal));
    message{1,bit_rate} = ['Bit Rate: ' char(double('0')+bit_rate)];
    message{2,bit_rate} = decoding_amp(signal,bit_rate,100);
end

message


