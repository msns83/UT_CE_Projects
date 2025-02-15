function output_waveform = coding_freq(input_message, bit_rate, Mapset)
    fs = 100;
    binary_array = [];
    
    for i = 1:length(input_message)
        binary_array = [binary_array Mapset{2, [Mapset{1, :}] == input_message(i)}];
    end

    if mod(length(binary_array), bit_rate) ~= 0
        for i = 1:(bit_rate - mod(length(binary_array), bit_rate))
            binary_array = [binary_array '1'];
        end
    end
    
    binary_array = reshape(binary_array, bit_rate, [])';
    signal = [];
    fs = 100;
    T_start = 0;
    T_end = 1;
    T = T_end - T_start;
    N = fs * T;
    ts = T/N;
    t = T_start:ts:T_end - ts;

    num = fs/(2*2^bit_rate);

    for i = 1:size(binary_array, 1)
        temp = bin2dec(binary_array(i, :));
        freq = round((temp + 1) * num - num/2);
        partial = sin(2*pi*t*freq);
        signal = [signal partial];
    end
    output_waveform = signal;
end
