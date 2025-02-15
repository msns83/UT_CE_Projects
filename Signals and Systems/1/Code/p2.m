clc;clear;close all

load("p2.mat");

figure('Name','x','NumberTitle','off');
plot(t,x,'b');
title ('x');
xlabel('t');
ylabel('x');
grid on

figure('Name','y','NumberTitle','off');
plot(t,y,'r');
title ('y');
xlabel('t');
ylabel('y');
grid on

figure('Name','y per x','NumberTitle','off');
plot(x,y,'.');
title ('y per x');
xlabel('x');
ylabel('y');
grid on