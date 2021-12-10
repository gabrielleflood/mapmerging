function [u, new_desc, visibility] = get_2Droom_points(U,desc,P,lim,prob,debug)
% function that projects the n 3D points in U (size 4xn) in the m cameras 
% in the struct P (size 1xm). Returns the 2D points as a struct, where 
% u{i} contains the 2D points projected in camera i. x{i} is a 3xn matrix,
% where the last row contains only ones. If prob has a value, the 
% visibility matrix is created, where each point is visible in each camera 
% with prabability prob. If  prob is empty all points are 
% seen in all cameras. desc contains the descriptors (sift or orb) for the 
% points in X and are transferred to the 2D points. The algorithm makes 
% sure that only points with positive depth and with x- and y-coordinate
% with absolute value lower than lim are seen. visibility is a matrix
% showing whiuch points are seen in which cameras. 

if nargin < 5 || isempty(debug)
    debug = 0;
end
if nargin < 4 || isempty(prob)
    prob = 1;
end
if nargin < 3 || isempty(lim)
    lim = 1/2;
end

[~,m] = size(P);
visibility = logical(zeros(m,size(U,2)));

for i = 1:m
%     U_tmp = U(logical(repmat(visibility(i,:),[4 1])));
%     %keyboard;
%     U_tmp = reshape(U_tmp,[4,sum(visibility(i,:))]);
%     P{i}*U_tmp;
    
    % project all points in camera i
    utmp = P{i}*U;
    % find the points with positive depth and not too big angle
    ok = (utmp(3,:)>0); 
%     utmp = pflat(utmp);
    ok = ok & (abs(utmp(1,:))<lim) & (abs(utmp(2,:))<lim);
    % decide which points are seen
    if prob == 1
        visibility(i,:) = ok;
    else
        visibility(i,:) = rand(0,1,size(ok)).*ok < prob;
    end

%     u{i} = pflat( reshape( utmp(:,logical(repmat(visibility(i,:),[3 1]))) ,[3 sum(visibility(i,:))]) );

    u{i} = pflat( utmp(:,visibility(i,:)) );

    desc_tmp = desc(:,visibility(i,:));
%     desc_tmp = reshape(desc_tmp,[128,sum(visibility(i,:))]);
    new_desc{i} = desc_tmp;
    
    if debug
        % plot the 3D points etc
        % 3D points
        figure(1); clf; rita3(U,'r.'); hold on;
        % camera
        c = -(P{i}(1:3,1:3))'*(P{i}(1:3,4));
        v = P{i}(3,1:3);
        quiver3(c(1),c(2),c(3),v(1),v(2),v(3),0.5,['r','-'],'LineWidth',0.5,'MaxHeadSize',0.5); % to scale arrows to half length
        % 3D points projected into camera
        rita3(U(:,visibility(i,:)),'bo'); hold off;
        pause()
    end
end