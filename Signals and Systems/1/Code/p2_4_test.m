clc;clear;close all

a_test = 2.45 ;
B_test = -11.5 ;
x_test = rand(1,1001);
noise = randn(1,1001) * 0.5;
y_test = a_test * x_test + B_test + noise;
y_test_2 = a_test * x_test + B_test ;

disp(['a_test = ', num2str(a_test),' , B_test = ', num2str(B_test)]);

[a_ans , B_ans] = p2_4(x_test,y_test);
disp('with noise:')
disp(['a_ans = ', num2str(a_ans),' , B_ans = ', num2str(B_ans)]);

[a_ans_2 , B_ans_2] = p2_4(x_test,y_test_2);
disp('without noise:');
disp(['a_ans_2 = ', num2str(a_ans_2),' , B_ans_2 = ', num2str(B_ans_2)]);

load("p2.mat");

[a,B] = p2_4(x,y) ;
disp(['a = ', num2str(a),' , B = ', num2str(B)]);

