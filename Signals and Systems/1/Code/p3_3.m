clc;clear;close all

ts = 1e-9; T = 1e-5; tau = 1e-6;
R = 450; C = 3e8; a = 0.5;
t = 0:ts:T;
td = (2*R)/C;
tau_index = round(tau/ts)+1;

sended_signal = zeros(1,length(t));
sended_signal(1:tau_index) = 1;

recieved_signal = zeros(1,length(t));
recieved_signal((td/ts)+1:round((td+tau)/ts)+1) = a;

sample_signal = ones(1,tau_index);
correlation = zeros(1,((T-tau)/ts)+1);

for k=1:((T-tau)/ts)+1
    correlation(k) = recieved_signal(1,k:k+tau_index-1)*(sample_signal');
end
    
[~, peak_index]= max(correlation);
td_ans = (peak_index-1)*ts;
R_ans = td_ans*C/2 ;
disp(['the R ,that we found it, is ', num2str(R_ans)]);


figure;
plot(0:ts:T-tau,correlation,'black','LineWidth',2);
xlabel('t');

figure;
plot(t,sended_signal,'LineWidth',2);
xlim([0,T]);
ylim([0,2]);
xlabel('t');
hold on
plot(t, recieved_signal,'r','LineWidth',1);




