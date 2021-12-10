% script written in May/June 2021. Generates two maps toghether creating a
% room (the two maps are "U-shaped". Uses orb features. 

[U,desc] = simulate_3Droom_points(200, 'orb', [3 6 2]', 0.1, 0)
[P1,P2] = simulate_room_cameras(20,[3 6 2])

debug = 1;
point_lim = 3/4; % the limit for when the absolute value of the x and y coordinates in homogeneous coords are seen in image
visibility_prob = 1; % the probability that a pont in front of the camera (see row above) is seen
[u1, new_desc1, visibility1] = get_2Droom_points(U{1},desc{1},...
                                    P1,point_lim,visibility_prob,debug);
[u2, new_desc2, visibility2] = get_2Droom_points(U{2},desc{2},...
                                    P2,point_lim,visibility_prob,debug);