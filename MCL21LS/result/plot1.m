%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot for each class.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;
load('resultList.mat');
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

% Class 1
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(SensitivityList(:,1));
plot(SepecificityList(:,1));
plot(PrecisionList(:,1));
plot(F1List(:,1));
legend({'accuracy','predict negative rate','Sensitivity','Sepecificity','PrecisionList','F1List'});
title('Class 1');

% Class2
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(SensitivityList(:,2));
plot(SepecificityList(:,2));
plot(PrecisionList(:,2));
plot(F1List(:,2));
legend({'accuracy','predict negative rate','Sensitivity','Sepecificity','PrecisionList','F1List'});
title('Class 2');

% Class3
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(SensitivityList(:,3));
plot(SepecificityList(:,3));
plot(PrecisionList(:,3));
plot(F1List(:,3));
legend({'accuracy','predict negative rate','Sensitivity','Sepecificity','PrecisionList','F1List'});
title('Class 3');

% Class4
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(SensitivityList(:,4));
plot(SepecificityList(:,4));
plot(PrecisionList(:,4));
plot(F1List(:,4));
legend({'accuracy','predict negative rate','Sensitivity','Sepecificity','PrecisionList','F1List'});
title('Class 4');

% Class4
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(SensitivityList(:,5));
plot(SepecificityList(:,5));
plot(PrecisionList(:,5));
plot(F1List(:,5));
legend({'accuracy','predict negative rate','Sensitivity','Sepecificity','PrecisionList','F1List'});
title('Class 5');












