function [Y] = convert_one_hot(y)
%Convert a cloumn vector label to one hot Matrix label.
%   eg 
%   y=[0 1 2 3 4 1 2 2 2 4]';
%   Y=convert_one_hot(y)

% if y contains 0
    if sum(y==0)>0
        y=y+1;
    end
    
    classes = length(unique(y));
    num = length(y);
    Y = zeros(num,classes);
    index=[1:num]';
    %index=[index,y];
    location=sub2ind(size(Y),index,y);
 
    Y(location)=1;
end

