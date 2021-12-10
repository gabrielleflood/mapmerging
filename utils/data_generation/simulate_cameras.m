function P = simulate_cameras(m,c_lim,r_lim)
% function that simulates m cameras in 3D. Returns a struct P of size n
% where P{i} contains the i:th camera matrix.

% not done.

if nargin < 2 || isempty(c_lim)
    % limits for camera centre
    c_lim = [-10 10 -10 10 -10 10];
%     lim = [-5 5 -3 3 -5 -3];
end
if nargin < 3 || isempty(r_lim)
    % limits for camera rotations. 1 means 2pi rot allowed.
    r_lim = [1 1 1];
%     r_lim = [0.2 0.2 0.5];
end


for i = 1:m
    %t = round(20*rand(3,1))-10;
    t = [(c_lim(2)-c_lim(1))*rand(1,1)+c_lim(1) ;...
    (c_lim(4)-c_lim(3))*rand(1,1)+c_lim(3) ; ...
    (c_lim(6)-c_lim(5))*rand(1,1)+c_lim(5)];
    v_x = (r_lim(1)*rand(1)-r_lim(1)/2)*2*pi; % angle around x axis
    v_y = (r_lim(2)*rand(1)-r_lim(2)/2)*2*pi; % angle around y axis
    v_z = (r_lim(3)*rand(1)-r_lim(3)/2)*2*pi; % angle around z axis
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P{i} = [R (-R*t)];
%    P{i} = rand(3,4);
end




