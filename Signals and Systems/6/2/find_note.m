function note = find_note(signal,fs,T)

    load("MAPSET.mat","Mapset");
    resol = 1/T;
    freq = -fs/2:resol:fs/2-resol;
    FT = abs(fftshift(fft(signal)));

    FT = FT(freq>=0);
    freq = freq(freq>=0);
    [~,fc] = max(FT);
    fc = freq(fc);

    tones = [Mapset{2,:}];
    tones = abs(tones - fc);
    [~,idx] = min(tones);
    note = char(Mapset{1,idx});

end