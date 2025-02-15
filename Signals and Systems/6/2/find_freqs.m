function frequency = find_freqs(note)
    load("MAPSET.mat","Mapset");
    idx = [Mapset{1,:}]==note;
    frequency = Mapset{2,idx};
end