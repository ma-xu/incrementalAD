function [metrics] = MCmetric(Truelabel,Prelabel)
%METRICS Summary of this function goes here
% calculate recall, specificity,... for multi-class task.
%Author: Xu Ma. xuma@my.unt.edu
%   Truelabel: groundTruth.
%   Prelabel: predicted label
%   Model:
%       sensitivity:    TP/(TP+FN)  = recall\
%       specificity:    TN/(TN+FP)
%       accuracy:       (TP+TN)/(TP+FP+TN+FN)
%       recall:         TP/(TP+FN)  = sensitivity
%       precision:      TP/(TP+FP)
%       F1_measure:     2PR/(P+R)=2TP/(2TP+FN+FP)
    if(length(Truelabel)~=length(Prelabel))
        error('The lengths of two labels are different.');
    end
   
    % confuse: SUM OF cols: predict numbers; sum of rows: true numbers;
    [confuseMatrix,~] = confusionmat(Truelabel,Prelabel);
    
    accuracy = sum(diag(confuseMatrix))/sum(sum(confuseMatrix));
    
    sensitivityList=zeros(size(confuseMatrix,1),1);
    specificityList=zeros(size(confuseMatrix,1),1);
    recallList=zeros(size(confuseMatrix,1),1);
    precisionList=zeros(size(confuseMatrix,1),1);
    F1_measureList=zeros(size(confuseMatrix,1),1);
    
    for i=1:size(confuseMatrix,1)
        TP= confuseMatrix(i,i);
        FP= sum(confuseMatrix(:,i))-confuseMatrix(i,i);
        TN= sum(sum(confuseMatrix))-sum(confuseMatrix(i,:))-sum(confuseMatrix(:,i))+confuseMatrix(i,i);
        FN= sum(confuseMatrix(i,:))-confuseMatrix(i,i);
        %sum(TP+FP+TN+FN)
        sensitivity = TP/(TP+FN);
        specificity = TN/(TN+FP);
        recall = TP/(TP+FN);
        precision = TP/(TP+FP);
        F1_measure=2*TP/(2*TP+FN+FP);
        
        sensitivityList(i,1) = sensitivity;
        specificityList(i,1) = specificity;
        recallList(i,1) = recall;
        precisionList(i,1) = precision;
        F1_measureList(i,1) = F1_measure;
    end
    
    metrics.accuracy = accuracy;
    metrics.sensitivityList =sensitivityList;
    metrics.specificityList = specificityList;
    metrics.recallList =recallList;
    metrics.precisionList =precisionList;
    metrics.F1_measureList =F1_measureList;
    
end
