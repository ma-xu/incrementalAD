function [W] = strans(X,y,W,C,lr)
% Sparse feature transformation.
%   min ||Y-XW||^2+C*||W||_2,1
%   derivate for ||W||_{2,1}:
%   diag(1/||w1||, 1/||w2||,...,1/||wd||)*W
%   derivate for L2,1-norm:
%   https://blog.csdn.net/lqderivationzdreamer/article/details/79676305
%   derivate:
%   -2X'*(Y-XW)+C*diag(1/||w1||, 1/||w2||,...,1/||wd||)*W
    l = size(W,2);
    Y=repmat(y,1,l);
    repeat_time=20;
    X_copy = X;
    Y_copy=Y;
    lr_copy=lr;
    repeatLOSS = zeros(repeat_time,1);
    for repeat=1:repeat_time
        %rand sort X;
        randseed=randperm(size(X,1));
        X = X_copy(randseed,:);
        Y = Y_copy(randseed,:);
        lr = lr_copy;
   
        max_iter=200;
        epsion = 1e-7;  
        W21norm=sum(sum(abs(W).^2,2).^(1/2));
        objVal = norm(Y-X*W)^2+C*W21norm;
        Diff = inf;
        iter=1;
        objValList=[objVal];

        while Diff>1e-4 && iter<max_iter
            W21_vector = sum(abs(W).^2,2).^(1/2);
            W21_vector(W21_vector==0,:)=epsion;
            D = diag(1/W21_vector);
            W_deri = D*W;
            derivation = -2*X'*(Y-X*W)+C*W_deri;
            %derivation=derivation/norm(derivation);
            W=W-lr*derivation;
            W21norm=sum(sum(abs(W).^2,2).^(1/2));
            objVal_new = norm(Y-X*W)^2+C*W21norm;
            if objVal_new>objValList(end,1) && lr >1e-7
                W=W+lr*derivation;
                lr=lr/10;
                continue;
            end
            if lr <1e-7
               iter= max_iter-3;
            end
            objValList=[objValList;objVal_new];
            Diff=abs(objVal-objVal_new);
            objVal=objVal_new;
            iter = iter+1;
        end
        loss=norm(Y-X*W)^2;
        repeatLOSS(repeat,1)=loss;
    end
    
    objValList;
    repeatLOSS
    iter;
    

end

