function [w] = L1LS(X,Y,C,w,lr)
    %min 0.5*||Y-Xw||^2+C*||w||_1
    %derivation:
    % X'*(Y-Xw)+C*sign(w)
    max_iter=200;
    
    epsion = 1e-7;
    
    
    repeat_time=1;
    X_copy=X;
    if (size(X,1)>1)
        repeat_time=ceil(sqrt(size(X,1)));
        repeat_time=1;
    end
    for rep=1:repeat_time
        rep
        %rand sort X;
        %X = X_copy(randperm(size(X,1)),:);
        
        objVal = norm(Y-X*w)^2+C*norm(w,1);
        Diff = inf;
        iter=1;
        objValList=[objVal];
      
        while Diff>1e-4 && iter<max_iter
            w(w==0,:)=epsion;
            derivation = -2*X'*(Y-X*w)+C*sign(w);
            derivation=derivation/norm(derivation);
            w=w-lr*derivation;
            objVal_new = norm(Y-X*w)^2+C*norm(w,1);
            if objVal_new>objValList(end,1) && lr >1e-7
                w=w+lr*derivation;
                lr=lr/10;
                continue;
            end
            if lr >1e-7
               iter= max_iter-3;
            end
            objValList=[objValList;objVal_new];
            Diff=abs(objVal-objVal_new);
            objVal=objVal_new;
            iter = iter+1;
        end
    end
    
    objValList;
    iter;
    
    
    
    
    
    
    
    
    
    
end

