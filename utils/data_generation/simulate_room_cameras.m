function [P1, P2] = simulate_room_cameras(m,roomsize)
% function that simulates m cameras in 3D. Returns two cells P of size ~m
% where P{i} contains the i:th camera matrix.

dist_from_wall = 1;
pos_noise = sum(roomsize)/m/5;
rot_noise = pi/24;

%% simulate cameras for first map
% the capture is: half of wall 1, all of wall 2, 1/4 of wall 3

l = 1/2*(roomsize(2)-2*dist_from_wall) + ...
    (roomsize(1)-dist_from_wall*2) + ...
    1/4*(roomsize(2)-2*dist_from_wall);% length of "line" of cameras in this map
camera_dist = l/(m-5);

%% simulate cameras for wall 1 in map 1
count = 1; % keeps track of number of points in this map
c = [roomsize(1)-dist_from_wall roomsize(2)*1/2 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]'; % the center of the first camera
while c(2) < roomsize(2) - dist_from_wall
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = 0 + normrnd(0,rot_noise);
    v_y = -pi/2 + normrnd(0,rot_noise);
    v_z = 0 + normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P1{count} = [R (-R*chat)];
    
    count = count+1; 
    c = [c(1) c(2)+camera_dist 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
end

% also add corner cameras
c = [roomsize(1)-dist_from_wall roomsize(2)-dist_from_wall 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
for i = 1:3
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = 0 + normrnd(0,rot_noise);
    v_y = -pi/2 + normrnd(0,rot_noise);
    v_z = -pi/4 + normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P1{count} = [R (-R*chat)];

    count = count+1;
end

%% simulate cameras for wall 2 in map 1

% c = [roomsize(1)-dist_from_wall roomsize(2)-dist_from_wall 1/4*roomsize(3)*rand(1)+1/2*roomsize(3)]'; % the center of the first camera
while c(1) > dist_from_wall
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = pi/2 + normrnd(0,rot_noise);
    v_y = 0 + normrnd(0,rot_noise);
    v_z = normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P1{count} = [R (-R*chat)];
    
    count = count+1; 
    c = [c(1)-camera_dist c(2) 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
end

% also add corner cameras
c = [dist_from_wall roomsize(2)-dist_from_wall 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
for i = 1:3
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = pi/2 + normrnd(0,rot_noise);
    v_y = 0 + normrnd(0,rot_noise);
    v_z = -pi/4 + normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P1{count} = [R (-R*chat)];

    count = count+1;
end

%% simulate cameras for wall 3 in map 1

% c = [dist_from_wall roomsize(2)-dist_from_wall 1/4*roomsize(3)*rand(1)+1/2*roomsize(3)]'; % the center of the first camera
while c(2) > 3/4*roomsize(2)
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = 0 + normrnd(0,rot_noise);
    v_y = pi/2 + normrnd(0,rot_noise);
    v_z = normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P1{count} = [R (-R*chat)];
    
    count = count+1; 
    c = [c(1) c(2)-camera_dist 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
end






%%
%% simulate cameras for second map
% the capture is: 7/8 of wall 3, all of wall 4, 3/4 of wall 1

l = 7/8*(roomsize(2)-2*dist_from_wall) + ...
    (roomsize(1)-dist_from_wall*2) + ...
    3/4*(roomsize(2)-2*dist_from_wall);% length of "line" of cameras in this map
camera_dist = l/(m-5);

%% simulate cameras for wall 3 in map 1

count = 1; % keeps track of number of points in this map
c = [dist_from_wall 7/8*roomsize(2) 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]'; % the center of the first camera
while c(2) > dist_from_wall
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = 0 + normrnd(0,rot_noise);
    v_y = pi/2 + normrnd(0,rot_noise);
    v_z = normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P2{count} = [R (-R*chat)];
    
    count = count+1; 
    c = [c(1) c(2)-camera_dist 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
end


% also add corner cameras
c = [dist_from_wall dist_from_wall 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
for i = 1:3
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = 0 + normrnd(0,rot_noise);
    v_y = pi/2 + normrnd(0,rot_noise);
    v_z = -pi/4 + normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P2{count} = [R (-R*chat)];

    count = count+1;
end

%% simulate cameras for wall 4 in map 2

% c = [dist_from_wall dist_from_wall 1/4*roomsize(3)*rand(1)+1/2*roomsize(3)]'; 
while c(1) < roomsize(1) - dist_from_wall
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = -pi/2 + normrnd(0,rot_noise);
    v_y = 0 + normrnd(0,rot_noise);
    v_z = normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P2{count} = [R (-R*chat)];
    
    count = count+1; 
    c = [c(1)+camera_dist c(2) 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
end

% also add corner cameras
c = [roomsize(1)-dist_from_wall dist_from_wall 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
for i = 1:3
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = -pi/2 + normrnd(0,rot_noise);
    v_y = 0 + normrnd(0,rot_noise);
    v_z = -pi/4 + normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P2{count} = [R (-R*chat)];

    count = count+1;
end

%% simulate cameras for wall 1 in map 2
% c = [roomsize(1)-dist_from_wall dist_from_wall 1/4*roomsize(3)*rand(1)+1/2*roomsize(3)]';
while c(2) < 3/4*roomsize(2)
    chat = c + normrnd(0,pos_noise,3,1);
    v_x = 0 + normrnd(0,rot_noise);
    v_y = -pi/2 + normrnd(0,rot_noise);
    v_z = 0 + normrnd(0,rot_noise);
    R = [1 0 0; 0 cos(v_x) -sin(v_x); 0 sin(v_x) cos(v_x)] * ...
        [cos(v_y) 0 sin(v_y); 0 1 0; -sin(v_y) 0 cos(v_y)] * ...
        [cos(v_z) -sin(v_z) 0; sin(v_z) cos(v_z) 0; 0 0 1];
    P2{count} = [R (-R*chat)];
    
    count = count+1; 
    c = [c(1) c(2)+camera_dist 1/4*roomsize(3)*rand(1)+3/8*roomsize(3)]';
end