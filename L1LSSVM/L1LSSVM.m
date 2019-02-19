function [w] = L1LSSVM(X,y,C,w,lr)
% For more information, read readMe.md
    repeat_time=20;
    X_copy = X;
    y_copy=y;
    lr_copy=lr;
    for repeat=1:repeat_time
        
        %rand sort X;
        randseed=randperm(size(X,1));
        X = X_copy(randseed,:);
        y = y_copy(randseed,:);
        lr = lr_copy;
        
        e = ones(size(X,1),1);
        Y = diag(y);
        max_iter=200;
        objVal = norm(w,1)+C*norm(e-Y*X*w);

        epsion = 1e-7;
        Diff = inf;
        iter=1;
        objValList=[inf];
        while Diff>1e-5 && iter<max_iter
            outlier = e-Y*X*w;
            outlier(outlier==0,:)=epsion;
            w(w==0,:)=epsion;
            derivation = sign(w)-C*(e'*diag(sign(outlier))*Y*X)';
            derivation=derivation/norm(derivation);
            w=w-lr*derivation;
            objVal_new = norm(w,1)+C*norm(e-Y*X*w);
            if objVal_new>objValList(end,1) && lr >1e-7
                w=w+lr*derivation;
                lr=lr/10;
                continue;
            end
            if lr <1e-7
               iter= max_iter;
            end
            objValList=[objValList;objVal_new];
            Diff=abs(objVal-objVal_new);
            objVal=objVal_new;
            iter = iter+1;
        end

        %objValList
        %iter;
    end

end

