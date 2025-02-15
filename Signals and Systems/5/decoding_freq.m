function output_message = decoding_freq(input_signal, bit_rate, Mapset)
    N = 100;
    signal = reshape(input_signal, N, [])';
    fs = 100;
    num = fs/(2*2^bit_rate);

    sections = [];
    for i = 1:2^(bit_rate)-1
        sections = [sections i*num];
    end
   
    my_message = [];
    my_binary = [];
    for i = 1:size(signal, 1)
        y = fftshift(fft(signal(i, :)));
        y = abs(y);
        y = y/max(y);
        [b, ~] = max(y);
        b = find(y == b);
        b = b(end);
        b = b - 51;
        
        for j = 1:length(sections)
            if b < sections(j)
                temp = j - 1;
                break;
            elseif j == 2^(bit_rate)-1
                temp = j;
                break;
            end
        end
        my_binary = [my_binary dec2bin(temp, bit_rate)];
    end

    for i = 1:mod(length(my_binary), 5)
        my_binary = my_binary(1:end-1);
    end
    my_binary = reshape(my_binary, 5, [])';
    for i = 1:size(my_binary, 1)
        for j = 1:size(Mapset, 2)
            if my_binary(i, :) == Mapset{2, j}
                select = j;
                break;
            end
        end

        my_message = [my_message Mapset{1, select}];
    end
    output_message = my_message;    
end