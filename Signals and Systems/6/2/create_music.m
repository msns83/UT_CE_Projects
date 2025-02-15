function signal = create_music(st,coefficients)

st = char(st);
mtx = [];
while ~isempty(st)
    temp = st(1);
    if temp == '|'
        st = st(length(temp)+1:end);
        continue
    end
    if length(st) > 1
        if st(2) == '#'
        temp = [temp '#'];
        end
    end
    mtx = [mtx;string(temp)];
    st = st(length(temp)+1:end);
end
signal = [];
for s=1:length(mtx')
    signal = [signal create_signal(find_freqs(mtx(s,1)),coefficients(s))];
end
end