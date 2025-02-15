function new_audio = p4_4(audio_file,speed)
    [audio,fs] = audioread(audio_file); 
    
    new_audio = zeros(length(0:speed:length(audio)-1),1);
    index = 0 ;
    
    for i=0:speed:length(audio)-1
        c = ceil(i) ; f = floor(i);
        if (c == f)
            new_audio(index+1) = audio(i+1);
        else
            new_audio(index+1) = (c-i) * audio(f+1) + (i-f) * audio(c+1) ;
        end
        index = index + 1 ;
    end
    
    sound(new_audio,fs);

end