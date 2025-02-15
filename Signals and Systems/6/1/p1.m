clc;clear;close;

fs = 100;
ts = 1/fs;
t = 0:ts:1-ts;
fc = 5;
w = 2*pi*fc;
plot(t,cos(w*t));

%%

clc;clear;close;

t_start = 0;
t_end = 1;
fc = 5;
fs = 100;
V = 180;
R = 250;
B = 0.3;
A = 0.5;
C = 3e8;
p = 2/C;

V = V / 3.6;
R = R * 1000;
ts = 1/fs;
t = t_start:ts:t_end-ts;

signal = A*cos(2*pi*(fc+B*V)*(t-p*R));

plot(t,signal)

%%

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

V = f_d/B
R = t_d/p

%%

noise_power = 0.01:0.01:1.5;
V_errors = zeros(size(noise_power));
R_errors = zeros(size(noise_power));

for i = 1:1:length(noise_power)
    v_err=0;
    r_err=0;
    for j = 1:50
        amp = noise_power(i);
        noisy_signal = signal + A*amp*randn(size(signal));
        [v1,r1] = decode_signal(noisy_signal,fs,fc,p,B,t_start,t_end);
        v_err = v_err + abs(v1-V);
        r_err = r_err + abs(r1-R);
    end
    v_err = v_err/50;
    r_err = r_err/50;
    V_errors(i) = v_err;
    R_errors(i) = r_err;
end

figure;
plot(noise_power,V_errors)
figure;
plot(noise_power,R_errors)

%%

clc;clear;close;

t_start = 0;
t_end = 1;
fc = 5;
fs = 100;
V1 = 180;
R1 = 250;
A1 = 0.5;
V2 = 216;
R2 = 200;
A2 = 0.6;
B = 0.3;
C = 3e8;
p = 2/C;

V1 = V1 / 3.6;
R1 = R1 * 1000;
V2 = V2 / 3.6;
R2 = R2 * 1000;

ts = 1/fs;
t = t_start:ts:t_end-ts;
signal1 = A1*cos(2*pi*(fc+B*V1)*(t-p*R1));
signal2 = A2*cos(2*pi*(fc+B*V2)*(t-p*R2));
signal = signal1+signal2;

plot(t,signal)

%%

resol = 1/(t_end-t_start);
freq = -fs/2:resol:fs/2-resol;
FT = fftshift(fft(signal));

ABS = abs(FT);
ANGLE = angle(FT);

ABS = ABS(freq>=0);
ANGLE = ANGLE(freq>=0);
freq = freq(freq>=0);

ABS = ABS/max(ABS);
ANGLE(ABS<1e-6) = 0;

ABS2 = ABS;
indexes = [];
ABS2 = ABS2 - [0 ABS2(1:end-1)];
ABS2(abs(ABS2)<1e-3)=0;
for i = 1:length(ABS2)-1
    if ABS2(i) > 0 && ABS2(i+1) < 0
        indexes = [indexes i];
    end
end

t_d1 = abs(ANGLE(indexes(1))/(2*pi*freq(indexes(1))));
f_d1 = freq(indexes(1))-fc;
V1 = f_d1/B*3.6
R1 = t_d1/p/1000

t_d2 = abs(ANGLE(indexes(2))/(2*pi*freq(indexes(2))));
f_d2 = freq(indexes(2))-fc;
V2 = f_d2/B*3.6
R2 = t_d2/p/1000