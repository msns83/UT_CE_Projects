function signal = coding_amp(msg, bit_rate, freq)

freq = double(freq);
T = 1/freq;
t = 0:T:1;
t = t(1:end-1);
template = sin(2*pi*t);
signal = [];

msg = msgToBin(msg);
msg = [msg repmat('0',1,mod(bit_rate-mod(length(msg),bit_rate),bit_rate))];
msg = reshape(msg,bit_rate,length(msg)/bit_rate)';
coefficient = 1/(2^bit_rate-1);

for c = 1:size(msg,1)
    signal = [signal double(bin2dec(msg(c,:)))*coefficient*template];
end

end

