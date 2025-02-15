function [tones,durations] = extract_signals(signal,fs)
    tones = {};
    durations = [];
    ts = 1/fs;
    
    while ~isempty(signal)
        first = find(signal);
        if isempty(first)
            break;
        end
        first = first(1)-1;
        last = first;
        if last == length(signal)-5
            break;
        end
        
        while any(signal(last:last+5))
            last = last + 1;
        end
        last = last - 1;
        tones{end+1} = [signal(first:last)];
        signal = signal(last+1:end);
        durations = [durations ts*(last-first++1)];
    end
end