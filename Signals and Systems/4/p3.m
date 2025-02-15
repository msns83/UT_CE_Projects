clear;close;clc;

msg = 'signal';
frequency = double(100);

out_1bit = coding_amp(msg,1,100);
out_2bit = coding_amp(msg,2,100);
out_3bit = coding_amp(msg,3,100);

figure
time1 = 0:length(out_1bit)-1;
time1 = (1/frequency) * time1;
plot(time1,out_1bit)
title("Bit Rate: 1")
xlabel("time")


figure
time2 = 0:length(out_2bit)-1;
time2 = (1/frequency) * time2;
plot(time2,out_2bit)
title("Bit Rate: 2")
xlabel("time")


figure
time3 = 0:length(out_3bit)-1;
time3 = (1/frequency) * time3;
plot(time3,out_3bit)
title("Bit Rate: 3")
xlabel("time")