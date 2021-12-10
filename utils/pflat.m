function y = pflat(x)
% funtions that changes the points in homogeneous coordinates in x such
% that the last coordinate is 1. If x contains n points it is 4xn and y has
% the same sixe, the last row only containing 1:s. 

d = size(x,1);

y = x./repmat(x(d,:),[d 1]);