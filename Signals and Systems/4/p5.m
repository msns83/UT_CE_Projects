close;clear;clc;

x_n = randn([1,300000]);
histogram(x_n,10000);
mn = mean(x_n)
vr = var(x_n)