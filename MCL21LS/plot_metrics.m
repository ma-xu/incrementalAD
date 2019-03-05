clear;clc;close all;
load('ResultList_0_error_back.mat');
R0 = ResultList;
clear ResultList;
load('ResultList_1_error_back.mat');
R1 = ResultList;
clear ResultList;
load('ResultList_2_error_back.mat');
R2 = ResultList;
clear ResultList;
load('ResultList_5_error_back.mat');
R5 = ResultList;
clear ResultList;
load('ResultList_10_error_back.mat');
R10 = ResultList;
clear ResultList;

R0_accuracy=[];
R0_sensitivity = [];
R0_specificity = [];
R0_recall = [];
R0_precision = [];
R0_F1 = [];

R1_accuracy=[];
R1_sensitivity = [];
R1_specificity = [];
R1_recall = [];
R1_precision = [];
R1_F1 = [];

R2_accuracy=[];
R2_sensitivity = [];
R2_specificity = [];
R2_recall = [];
R2_precision = [];
R2_F1 = [];

R5_accuracy=[];
R5_sensitivity = [];
R5_specificity = [];
R5_recall = [];
R5_precision = [];
R5_F1 = [];

R10_accuracy=[];
R10_sensitivity = [];
R10_specificity = [];
R10_recall = [];
R10_precision = [];
R10_F1 = [];

for i = 1:length(R0)
    R0i = R0(i);
    R0_accuracy=[R0_accuracy;R0i.accuracy];
    R0_sensitivity = [R0_sensitivity;R0i.sensitivityList'];
    R0_specificity = [R0_specificity;R0i.specificityList'];
    R0_recall = [R0_recall;R0i.recallList'];
    R0_precision = [R0_precision;R0i.precisionList'];
    R0_F1 = [R0_F1;R0i.F1_measureList'];
    
    R1i = R1(i);
    R1_accuracy=[R1_accuracy;R1i.accuracy];
    R1_sensitivity = [R1_sensitivity;R1i.sensitivityList'];
    R1_specificity = [R1_specificity;R1i.specificityList'];
    R1_recall = [R1_recall;R1i.recallList'];
    R1_precision = [R1_precision;R1i.precisionList'];
    R1_F1 = [R1_F1;R1i.F1_measureList'];
    
    R2i = R2(i);
    R2_accuracy=[R2_accuracy;R2i.accuracy];
    R2_sensitivity = [R2_sensitivity;R2i.sensitivityList'];
    R2_specificity = [R2_specificity;R2i.specificityList'];
    R2_recall = [R2_recall;R2i.recallList'];
    R2_precision = [R2_precision;R2i.precisionList'];
    R2_F1 = [R2_F1;R2i.F1_measureList'];
    
    R5i = R5(i);
    R5_accuracy=[R5_accuracy;R5i.accuracy];
    R5_sensitivity = [R5_sensitivity;R5i.sensitivityList'];
    R5_specificity = [R5_specificity;R5i.specificityList'];
    R5_recall = [R5_recall;R5i.recallList'];
    R5_precision = [R5_precision;R5i.precisionList'];
    R5_F1 = [R5_F1;R5i.F1_measureList'];
    
    R10i = R10(i);
    R10_accuracy=[R10_accuracy;R10i.accuracy];
    R10_sensitivity = [R10_sensitivity;R10i.sensitivityList'];
    R10_specificity = [R10_specificity;R10i.specificityList'];
    R10_recall = [R10_recall;R10i.recallList'];
    R10_precision = [R10_precision;R10i.precisionList'];
    R10_F1 = [R10_F1;R10i.F1_measureList'];
    
end

%accuracy
figure;
plot(R0_accuracy,'k-','linewidth',1.5);
hold on;
plot(R1_accuracy,'r-');
hold on;
plot(R5_accuracy,'g-');
hold on;
plot(R10_accuracy,'b-');
legend({'0','1','5','10'},'Location','southeast');
title('accuracy');


% plot precision 1
figure;
plot(R0_precision(:,1),'k-','linewidth',1.5);
hold on;
plot(R1_precision(:,1),'r-');
hold on;
plot(R5_precision(:,1),'g-');
hold on;
plot(R10_precision(:,1),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('precision_1');

% plot precision 2
figure;
plot(R0_precision(:,2),'k-','linewidth',1.5);
hold on;
plot(R1_precision(:,2),'r-');
hold on;
plot(R5_precision(:,2),'g-');
hold on;
plot(R10_precision(:,2),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('precision_2');

% plot precision 3
figure;
plot(R0_precision(:,3),'k-','linewidth',1.5);
hold on;
plot(R1_precision(:,3),'r-');
hold on;
plot(R5_precision(:,3),'g-');
hold on;
plot(R10_precision(:,3),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('precision_3');

% plot precision 4
figure;
plot(R0_precision(:,4),'k-','linewidth',1.5);
hold on;
plot(R1_precision(:,4),'r-');
hold on;
plot(R5_precision(:,4),'g-');
hold on;
plot(R10_precision(:,4),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('precision_4');

% plot precision 5
figure;
plot(R0_precision(:,5),'k-','linewidth',1.5);
hold on;
plot(R1_precision(:,5),'r-');
hold on;
plot(R5_precision(:,5),'g-');
hold on;
plot(R10_precision(:,5),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('precision_5');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%recall & sensitivity
% plot recall 1
figure;
plot(R0_recall(:,1),'k-','linewidth',1.5);
hold on;
plot(R1_recall(:,1),'r-');
hold on;
plot(R5_recall(:,1),'g-');
hold on;
plot(R10_recall(:,1),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('recall_1');

% plot recall 2
figure;
plot(R0_recall(:,2),'k-','linewidth',1.5);
hold on;
plot(R1_recall(:,2),'r-');
hold on;
plot(R5_recall(:,2),'g-');
hold on;
plot(R10_recall(:,2),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('recall_2');

% plot recall 3
figure;
plot(R0_recall(:,3),'k-','linewidth',1.5);
hold on;
plot(R1_recall(:,3),'r-');
hold on;
plot(R5_recall(:,3),'g-');
hold on;
plot(R10_recall(:,3),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('recall_3');

% plot recall 4
figure;
plot(R0_recall(:,4),'k-','linewidth',1.5);
hold on;
plot(R1_recall(:,4),'r-');
hold on;
plot(R5_recall(:,4),'g-');
hold on;
plot(R10_recall(:,4),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('recall_4');

% plot recall 5
figure;
plot(R0_recall(:,5),'k-','linewidth',1.5);
hold on;
plot(R1_recall(:,5),'r-');
hold on;
plot(R5_recall(:,5),'g-');
hold on;
plot(R10_recall(:,5),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('recall_5');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%specificity
% plot specificity 1
figure;
plot(R0_specificity(:,1),'k-','linewidth',1.5);
hold on;
plot(R1_specificity(:,1),'r-');
hold on;
plot(R5_specificity(:,1),'g-');
hold on;
plot(R10_specificity(:,1),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('specificity_1');

% plot specificity 2
figure;
plot(R0_specificity(:,2),'k-','linewidth',1.5);
hold on;
plot(R1_specificity(:,2),'r-');
hold on;
plot(R5_specificity(:,2),'g-');
hold on;
plot(R10_specificity(:,2),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('specificity_2');

% plot specificity 3
figure;
plot(R0_specificity(:,3),'k-','linewidth',1.5);
hold on;
plot(R1_specificity(:,3),'r-');
hold on;
plot(R5_specificity(:,3),'g-');
hold on;
plot(R10_specificity(:,3),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('specificity_3');

% plot specificity 4
figure;
plot(R0_specificity(:,4),'k-','linewidth',1.5);
hold on;
plot(R1_specificity(:,4),'r-');
hold on;
plot(R5_specificity(:,4),'g-');
hold on;
plot(R10_specificity(:,4),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('specificity_4');

% plot specificity 5
figure;
plot(R0_specificity(:,5),'k-','linewidth',1.5);
hold on;
plot(R1_specificity(:,5),'r-');
hold on;
plot(R5_specificity(:,5),'g-');
hold on;
plot(R10_specificity(:,5),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('specificity_5');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%F1
% plot F1 1
figure;
plot(R0_F1(:,1),'k-','linewidth',1.5);
hold on;
plot(R1_F1(:,1),'r-');
hold on;
plot(R5_F1(:,1),'g-');
hold on;
plot(R10_F1(:,1),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('F1_1');

% plot F1 2
figure;
plot(R0_F1(:,2),'k-','linewidth',1.5);
hold on;
plot(R1_F1(:,2),'r-');
hold on;
plot(R5_F1(:,2),'g-');
hold on;
plot(R10_F1(:,2),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('F1_2');

% plot F1 3
figure;
plot(R0_F1(:,3),'k-','linewidth',1.5);
hold on;
plot(R1_F1(:,3),'r-');
hold on;
plot(R5_F1(:,3),'g-');
hold on;
plot(R10_F1(:,3),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('F1_3');

% plot F1 4
figure;
plot(R0_F1(:,4),'k-','linewidth',1.5);
hold on;
plot(R1_F1(:,4),'r-');
hold on;
plot(R5_F1(:,4),'g-');
hold on;
plot(R10_F1(:,4),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('F1_4');

% plot F1 5
figure;
plot(R0_F1(:,5),'k-','linewidth',1.5);
hold on;
plot(R1_F1(:,5),'r-');
hold on;
plot(R5_F1(:,5),'g-');
hold on;
plot(R10_F1(:,5),'b-');
legend({'0','1','5','10'},'Location','southeast');
title('F1_5');










