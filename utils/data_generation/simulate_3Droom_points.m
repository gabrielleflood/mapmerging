function [U,desc] = simulate_3Droom_points(n, descriptor, roomsize, wall, sigma)
% function that simulates ~n points in homogeneous coordinates, divided
% in two maps. Returns a cell U with two vectors containing the points. (n 
% in total). roomsize a 3x1 matrix giving the size o the room in x, y z 
% directions (z being up) and wall gives the wall thicknes. descriptor can 
% be either sift or orb and descriptors for each point is returned in desc, 
% which will be 128xn for sift and 32xn (256xn bits expressed as integers 
% from 0 to 255) for orb. sigma can add some "noise" in the wall thickness.


if nargin < 5 || isempty(sigma)
    sigma = 0;
end

% room will be divided into two maps, where the room is "split" in the
% y-direction

%% generate wall 1 and add relevant points to map 1 and 2
lim = [roomsize(1)-wall roomsize(1) 0 roomsize(2)-wall ...
            0 roomsize(3)];
[wall1,descwall1] = simulate_3D_points(round(n/4), descriptor, lim, sigma);

% add points to map 1
ind1 =wall1(2,:)>roomsize(2)*1/2;
U1 = wall1(:,ind1);
desc1 = descwall1(:,ind1);

% add points to map 1
ind2 =wall1(2,:)<roomsize(2)*7/8;
U2 = wall1(:,ind2);
desc2 = descwall1(:,ind2);

%% generate wall 2 and add points to map 1
lim = [0 roomsize(1) roomsize(2)-wall roomsize(2) 0 roomsize(3)];
[wall2,descwall2] = simulate_3D_points(round(n/4), descriptor, lim, sigma);

% add points to map 1
U1 = [U1 wall2];
desc1 = [desc1 descwall2];

%% generate wall 4 and add points to map 2

lim = [0 roomsize(1) 0 wall  0 roomsize(3)];
[wall4,descwall4] = simulate_3D_points(round(n/4), descriptor, lim, sigma);

% add points to map 2
U2 = [wall4 U2];
desc2 = [descwall4 desc2];


%% generate wall 3 and add relevant points to map 1 and 2

lim = [0 wall 0 roomsize(2)-wall 0 roomsize(3)];
[wall3,descwall3] = simulate_3D_points(round(n/4), descriptor, lim, sigma);

% add points to map 1
ind1 =wall3(2,:)>roomsize(2)*3/4;
U1 = [U1 wall3(:,ind1)];
desc1 = [desc1 descwall3(:,ind1)];

% add points to map 1
ind2 = wall3(2,:)<roomsize(2)*3/4;
U2 = [wall3(:,ind2) U2];
desc2 = [descwall3(:,ind2) desc2];


% %% generate for the three walls for map 1
% % wall 1
% lim = [roomsize(1)-wall roomsize(1) roomsize(2)/2 roomsize(2)-wall ...
%             0 roomsize(3)];
% [U1,desc1] = simulate_3D_points(round(n/8), descriptor, lim, sigma);
% % wall 2
% lim = [0 roomsize(1) roomsize(2)-wall roomsize(2) ...
%             0 roomsize(3)];
% [U1tmp,desc1tmp] = simulate_3D_points(round(n/4), descriptor, lim, sigma);
% U1 = [U1 U1tmp];
% desc1 = [desc1 desc1tmp];
% % wall 3
% lim = [0 wall roomsize(2)*3/4 roomsize(2)-wall ...
%             0 roomsize(3)];
% [U1tmp,desc1tmp] = simulate_3D_points(round(n/8), descriptor, lim, sigma);
% U1 = [U1 U1tmp];
% desc1 = [desc1 desc1tmp];
% 
% %% generate for the three walls for map 2
% 
% % wall 3
% lim = [0 wall 0 roomsize(2)*7/8 ...
%             0 roomsize(3)];
% [U2,desc2] = simulate_3D_points(round(n/8), descriptor, lim, sigma);
% 
% % wall 4
% lim = [0 roomsize(1) 0 wall  0 roomsize(3)];
% [U2tmp,desc2tmp] = simulate_3D_points(round(n/4), descriptor, lim, sigma);
% U2 = [U2 U2tmp];
% desc2 = [desc2 desc2tmp];
% 
% % wall 1
% lim = [roomsize(1)-wall roomsize(1) 0 roomsize(2)*3/4 ...
%             0 roomsize(3)];
% [U2tmp,desc2tmp] = simulate_3D_points(round(n/8), descriptor, lim, sigma);
% U2 = [U2 U2tmp];
% desc2 = [desc2 desc2tmp];


%% Just save values in the right way

U = {U1, U2};
desc = {desc1, desc2};
