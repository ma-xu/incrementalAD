%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot for each class.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;
load('resultList_300.mat');
AccuracyList = [];
SensitivityList = [];
SepecificityList = [];
RecallList = [];
PrecisionList = [];
F1List = [];
NegNumList = [];

for i =1:length(ResultList)
    Result = ResultList(i);
    Accuracy = Result.accuracy;
    Sensitivity = Result.sensitivityList';
    Sepecificity = Result.specificityList';
    Recall = Result.recallList';
    Precision = Result.precisionList';
    F1 = Result.F1_measureList';
    NegNumber = Result.NegNumber;
    i
    
    AccuracyList=[AccuracyList;Accuracy];
    SensitivityList = [SensitivityList;Sensitivity];
    SepecificityList = [SepecificityList;Sepecificity];
    RecallList = [RecallList;Recall];
    PrecisionList = [PrecisionList;Precision];
    F1List = [F1List;F1];
    NegNumList = [NegNumList;NegNumber];
    
end

SensitivityList(SensitivityList==0)=1;
SepecificityList(SepecificityList==0)=1;


% Class 1
figure;
plot(AccuracyList,'-.');
hold on;
%plot(NegNumList/300,':');
%hold on;
plot(SensitivityList(:,1),'-+');
plot(SepecificityList(:,1),'-*');
%plot(PrecisionList(:,1));
%plot(F1List(:,1));
legend({'accuracy','Sensitivity','Specificity'},'Location','southeast');
title('Normal Records');
xlabel('Epochs','FontSize',14);
ylabel('Metric values','FontSize',14);

% Class2
figure;
plot(AccuracyList,'-.');
hold on;
%plot(NegNumList/300,':');
%hold on;
plot(SensitivityList(:,2),'-+');
plot(SepecificityList(:,2),'-*');
%plot(PrecisionList(:,2));
%plot(F1List(:,2));
legend({'accuracy','Sensitivity','Specificity'},'Location','southeast');
title('Memory Anomaly');
xlabel('Epochs','FontSize',14);
ylabel('Metric values','FontSize',14);

% Class3
figure;
plot(AccuracyList,'-.');
hold on;
%plot(NegNumList/300,':');
%hold on;
plot(SensitivityList(:,3),'-+');
plot(SepecificityList(:,3),'-*');
%plot(PrecisionList(:,3));
%plot(F1List(:,3));
legend({'accuracy','Sensitivity','Specificity'},'Location','southeast');
title('CPU Anomaly');
xlabel('Epochs','FontSize',14);
ylabel('Metric values','FontSize',14);

% Class4
figure;
plot(AccuracyList,'-.');
hold on;
%plot(NegNumList/300,':');
%hold on;
plot(SensitivityList(:,4),'-+');
plot(SepecificityList(:,4),'-*');
%plot(PrecisionList(:,4));
%plot(F1List(:,4));
legend({'accuracy','Sensitivity','Specificity'},'Location','southeast');
title('Network Anomaly');
xlabel('Epochs','FontSize',14);
ylabel('Metric values','FontSize',14);

% Class5
figure;
plot(AccuracyList,'-.');
hold on;
%plot(NegNumList/300,':');
%hold on;
plot(SensitivityList(:,5),'-+');
plot(SepecificityList(:,5),'-*');
%plot(PrecisionList(:,5));
%plot(F1List(:,5));
legend({'accuracy','Sensitivity','Specificity'},'Location','southeast');
title('Disk Anomaly');
xlabel('Epochs','FontSize',14);
ylabel('Metric values','FontSize',14);












