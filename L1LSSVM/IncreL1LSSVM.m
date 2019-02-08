function [w] = IncreL1LSSVM(X,y,C,w,lr)
% For more information, read readMe.md
    
    e = ones(size(X,1),1);
    X=[X e];
    Y = diag(y);
    max_iter=200;
    objVal = norm(w,1)+C*e'*norm(e-Y*X*w);
    
    epsion = 1e-7;
    Diff = inf;
    iter=1;
    objValList=[];
    while Diff>1e-4 && iter<max_iter
        outlier = e-Y*X*w;
        outlier(find(outlier==0))=epsion;
        w(find(w==0))=epsion;
        derivation = sign(w)+C*(e'*diag(sign(outlier))*Y*X)';
        w=w-lr*derivation;
        objVal_new = norm(w,1)+C*e'*norm(e-Y*X*w);
        objValList=[objValList;objVal_new];
        Diff=abs(objVal-objVal_new);
        iter = iter+1;
    end
    
    objValList
    iter

end

