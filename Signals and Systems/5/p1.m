clc;
clear;
close all;

fs = 20;
T_start = 0;
T_end = 1;
T = T_end - T_start;
N = fs * T;
ts = T/N;
t = T_start:ts:T_end - ts;
f = -fs/2:fs/N:fs/2-fs/N;

x1 = exp(1i * 2*pi * 5 * t) + exp(1i * 2*pi * 8 * t);
x2 = exp(1i * 2*pi * 5 * t) + exp(1i * 2*pi * 5.1 * t);
y1 = fftshift(fft(x1));
y1 = y1/max(y1);
y2 = fftshift(fft(x2));
y2 = y2/max(y2);

figure;
subplot(2,1,1);
stem(f, abs(y1));
title('x1');
xlim([-11 10]);
ylim([-0.2 1.2]);

subplot(2,1,2);
stem(f, abs(y2));
title('x2');
xlim([-11 10]);
ylim([-0.2 1.2]);

%% 
clear;

fs = 50;
T_start = -1;
T_end = 1;
T = T_end - T_start;
N = fs * T;
ts = T/N;
t = T_start:ts:T_end - ts;
f = -fs/2:fs/N:fs/2-fs/N;


x = cos(10 * pi * t);
y = fftshift(fft(x));
y = y/max(y);
figure;
subplot(2,1,1);
plot(t, x);
ylim([-1.2 1.2]);

subplot(2,1,2);
stem(f, abs(y));
ylim([-0.2 1.2]);

%%
clear;
fs = 100;
T_start = 0;
T_end = 1;
T = T_end - T_start;
N = fs * T;
ts = T/N;
t = T_start:ts:T_end - ts;
f = -fs/2:fs/N:fs/2-fs/N;

x = cos(30 * pi * t + pi/4);
y = fftshift(fft(x));
% y = y/max(y);

figure;
subplot(3,1,1);
plot(t, x);
subplot(3,1,2);
stem(f, abs(y));

tol = 1e-10;
y(abs(y) < tol) = 0;
theta = angle(y);
subplot(3,1,3);
stem(f,theta/pi);
xlabel 'Frequency (Hz)'
ylabel 'Phase / \pi'