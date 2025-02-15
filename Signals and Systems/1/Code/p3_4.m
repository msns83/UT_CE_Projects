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

num_of_exams = 100;
noise_power_ceil = 10;
founded_Rs = zeros(1,length(0:0.5:noise_power_ceil));

for i=0:0.5:noise_power_ceil
    for j=1:num_of_exams
        noisy_signal = recieved_signal + randn(1,length(t)) * i;
        for k=1:((T-tau)/ts)+1
            correlation(k) = noisy_signal(1,k:k+tau_index-1)*(sample_signal');
        end
        [~, peak_index]= max(correlation);
        td_ans = (peak_index-1)*ts;
        founded_Rs(1,i*2+1) = founded_Rs(1,i*2+1) + (td_ans*C/2) ;
    end
    founded_Rs(1,i*2+1) = founded_Rs(1,i*2+1) / num_of_exams ;
end

Rs_error = abs(founded_Rs - R) ;

figure;
plot(0:0.5:noise_power_ceil,Rs_error,'black','LineWidth',2);
hold on
plot(0:0.5:noise_power_ceil,10*ones(length(0:0.5:noise_power_ceil)),'red','LineWidth',2);
xlabel('noise power');
ylabel('error (m)');
grid on;