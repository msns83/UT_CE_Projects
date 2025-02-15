function message = decoding_amp(signal,bit_rate,frequency)

    frequency = double(frequency);
    T = 1/frequency;
    t = 0:T:1;
    t = t(1:end-1);
    template = sin(2*pi*t);

    signal = reshape(signal,frequency,length(signal)/frequency)';
    bincode = [];
    for i = 1:size(signal,1)
        bincode = [bincode dec2bin(round(correlate(template,signal(i,:), frequency,bit_rate)),bit_rate)];
    end
    message = BinToMsg(bincode);

end

