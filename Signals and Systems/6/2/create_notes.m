function [notes,durations] = create_notes(signal,fs)

    [temp,durations] = extract_signals(signal,fs);
    
    
    notes = [];
    for i = 1:length(temp)
        notes = [notes find_note(temp{i},fs,durations(i))];
    end
    notes = string(notes);

    durations = durations * 2 ;

end