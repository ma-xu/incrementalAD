function [W] = MCL21LS(X,Y,C,W,lr)
    %min 0.5*||Y-XW||^2+C*||W||_2,1
    %derivation:
    %derivate:
    
    % -2X'*(Y-XW)+C*sign(W)
    
    repeat_time=10;
    X_copy = X;
    Y_copy=Y;
    lr_copy=lr;
    for repeat=1:repeat_time
        %rand sort X;
        randseed=randperm(size(X,1));
        X = X_copy(randseed,:);
        Y = Y_copy(randseed,:);
        lr = lr_copy;
    
    
        max_iter=200;
        epsion = 1e-7;  
        objVal = norm(Y-X*W)^2+C*norm(W,1);
        Diff = inf;
        iter=1;
        objValList=[objVal];

        while Diff>1e-4 && iter<max_iter
            derivation = -2*X'*(Y-X*W)+C*sign(W);
            derivation=derivation/norm(derivation);
            W=W-lr*derivation;
            objVal_new = norm(Y-X*W)^2+C*norm(W,1);
            if objVal_new>objValList(end,1) && lr >1e-7
                W=W+lr*derivation;
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

