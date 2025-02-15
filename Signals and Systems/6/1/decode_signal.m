function [V,R] = decode_signal(signal,fs,fc,p,B,t_start,t_end)

resol = 1/(t_end-t_start);
freq = -fs/2:resol:fs/2-resol;
FT = fftshift(fft(signal));

absolute = abs(FT);
phase = angle(FT);

absolute = absolute(freq>=0);
phase = phase(freq>=0);
freq = freq(freq>=0);

[~,f_new] = max(absolute);
t_d = abs(phase(f_new)/(2*pi*freq(f_new)));
f_d = freq(f_new)-fc;

V = f_d/B;
R = t_d/p;

end