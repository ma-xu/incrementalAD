function [y] = convert_vector(Y)
%convert one-hot matrix label to column vector label;
%convert predict matrix label to column vector label;
%   Y=[0.3, 0.7;0.1,0.9];
%   y=onehot_to_vector(Y)
    [maxVal,index] = max(Y');
    y = index';
   
end

