clear;close;clc;

frequency = 100;
original_message = 'signal';
flag = true;
br = [];
noise = [];

for noise_amp = 0:0.01:2
    for bit_rate = 1:3
        coded_signal = coding_amp(original_message,bit_rate,frequency);
        coded_signal = coded_signal + noise_amp*randn(size(coded_signal));
        decoded_signal = decoding_amp(coded_signal,bit_rate,frequency);
        if convertCharsToStrings(decoded_signal) ...
            ~= convertCharsToStrings(original_message)
            br = [br bit_rate];
            noise = [noise noise_amp];
        end
    end
end

scatter(noise,br)