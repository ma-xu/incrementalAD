function precision = KNN(train,label,test, testlabel)
D = (repmat(sum(train.^2,1),size(test,2),1)+repmat(sum(test.^2,1)',1,size(train,2))-2*test'*train)';
[tmp, ind1] = min(D,[],1); 
olabel = label(ind1);
precision = double(sum(olabel == testlabel)) / length(testlabel); 
