function tone = create_signal(frequency,coefficient)
    fs = 8000;
    ts = 1/fs;
    T = 0.5*coefficient;
    t = 0:ts:T-ts;
    tone = sin(2*pi*frequency*t);
    t_rest = 0:ts:0.025-ts;
    tone = [tone zeros(1,length(t_rest))];
end