%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot for each metric.
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

% Sensitivity
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(SensitivityList(:,1));
plot(SensitivityList(:,2));
plot(SensitivityList(:,3));
plot(SensitivityList(:,4));
plot(SensitivityList(:,5));

legend({'accuracy','predict negative rate','Normal','Error1','Error2','Error3','Error4'});
title('SensitivityList');


% Sepecificity
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(SepecificityList(:,1));
plot(SepecificityList(:,2));
plot(SepecificityList(:,3));
plot(SepecificityList(:,4));
plot(SepecificityList(:,5));

legend({'accuracy','predict negative rate','Normal','Error1','Error2','Error3','Error4'});
title('SepecificityList');


% RecallList
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(RecallList(:,1));
plot(RecallList(:,2));
plot(RecallList(:,3));
plot(RecallList(:,4));
plot(RecallList(:,5));

legend({'accuracy','predict negative rate','Normal','Error1','Error2','Error3','Error4'});
title('RecallList');




% PrecisionList
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(PrecisionList(:,1));
plot(PrecisionList(:,2));
plot(PrecisionList(:,3));
plot(PrecisionList(:,4));
plot(PrecisionList(:,5));

legend({'accuracy','predict negative rate','Normal','Error1','Error2','Error3','Error4'});
title('PrecisionList');



% F1List
figure;
plot(AccuracyList,':');
hold on;
plot(NegNumList/100,':');
hold on;
plot(F1List(:,1));
plot(F1List(:,2));
plot(F1List(:,3));
plot(F1List(:,4));
plot(F1List(:,5));

legend({'accuracy','predict negative rate','Normal','Error1','Error2','Error3','Error4'});
title('F1List');










