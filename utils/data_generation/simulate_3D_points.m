function [U,desc] = simulate_3D_points(n, descriptor, lim, sigma)
% function that simulates n 3D points in homogeneous coordinates. Returns a
% 4xn vector X containing the points. lim is a 3x2 matrix giving the lower
% and upper bounds in the three dimensions. descriptor can be either sift
% or orb and descriptors for each point is returned in desc, which will be
% 128xn for sift and 32xn (256xn bits expressed as integers from 0 to 255) 
% for orb.

if nargin < 3 || isempty(lim)
    lim = [-10 10 -10 10 -10 10];
end
if nargin < 4 || isempty(sigma)
    sigma = 0;
end

U = [(lim(2)-lim(1))*rand(1,n)+lim(1) ;...
    (lim(4)-lim(3))*rand(1,n)+lim(3) ; ...
    (lim(6)-lim(5))*rand(1,n)+lim(5) ; ...
    ones(1,n)];
% add Gaussian noise
U = U + [sigma*randn(3,n); zeros(1,n)];

if strcmp(descriptor,'sift')
    desc = 100*rand(128,n);
elseif strcmp(descriptor,'orb')
%     for i = 1:n
% %         desci = reshape(randi([0,1],256,1),[8,32])';
%         desci = randi([0 1],32,8);
%         desc(:,i) = bi2de(desci);
%     end
    desc = randi([0 255],32,n);
else
    warning('Only sift and orb descriptors are supported.')
    desc = [];
end
