clc; close all;
result = TrainedModel.predictFcn(diabetestraining(:,1:end-1));
precision = sum(table2array(diabetestraining(:,end))==result,'all');
precision = double(precision) / double(size(diabetestraining,1)) * 100 ;
disp(['Training Precision: ' num2str(precision) ' %'])

%%

result2 = TrainedModel.predictFcn(diabetesvalidation(:,1:end-1));
precision2 = sum(table2array(diabetesvalidation(:,end))==result2,'all');
precision2 = double(precision2) / double(size(diabetesvalidation,1)) * 100 ;
disp(['Test Precision: ' num2str(precision2) ' %'])