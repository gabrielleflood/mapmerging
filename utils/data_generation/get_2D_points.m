function [u, new_desc] = get_2D_points(U,desc,P,visibility)
% function that projects the n 3D points in X (size 4xn) in the m cameras 
% in the struct P (size 1xm). Returns the 2D points as a struct, where 
% x{i} contains the 2D points projected in camera i. x{i} is a 3xn matrix,
% where the last row contains only ones. visibility is a mxn matrix with
% 1:s and 0:s, where a 1 on position i,j shows that 3D point j should be
% visible in camera i. If visibility is empty all points are seen in all
% cameras. desc contains the descriptors (sift or orb) for the points in X
% and are transferred to the 2D points.

[~,m] = size(P);

if nargin < 3
    for i = 1:m
        u{i} = pflat( P{i}*U );
        new_desc{i} = desc;
    end
else
    for i = 1:m
        U_tmp = U(logical(repmat(visibility(i,:),[4 1])));
        %keyboard;
        U_tmp = reshape(U_tmp,[4,sum(visibility(i,:))]);
        P{i}*U_tmp;
        u{i} = pflat( P{i}*U_tmp );
        desc_tmp = desc(logical(repmat(visibility(i,:),[128 1])));
        desc_tmp = reshape(desc_tmp,[128,sum(visibility(i,:))]);
        new_desc{i} = desc_tmp;
    end
end