function [SfMs, sfm_matches, matching] = simulate_example_data(sigma,noise_sigma)
% Copied from simulate_data_multruns_2, but modified to work for a small
% example of how points within maps can be merged
%
% function that simulates m cameras, n 3D points and projects the 3D points
% in the cameras with a given visibility rate. lim is the limits for the 3D
% points. descriptor can be either 'sift' or 'orb' and is the descriptor
% used and saved for the points.
% P{i} contains camera matrix i
% X is 4xn matrix containing the 3D points
% X_desc are the descriptors for the points in X (each column is one descriptor)
% x{i} is a 3x(n*visibility_rate) matrix containing the 2D points in camera i
% x_desc are the descriptors for the points in x (each column is one descriptor)


%% save setup stuff
% n_runs = opts.n_runs;
% m = opts.m;
% n = opts.n;
% if isfield(opts,'visibility_rate')
%     visibility_rate = opts.visibility_rate;
% else
%     visibility_rate = 1;
% end
% if isfield(opts,'descriptor')
%     descriptor = opts.descriptor;
% else
%     descriptor = 'sift';
% end
% if isfield(opts,'U_lim')
%     U_lim = opts.U_lim;
% else
%     U_lim = [];
% end
% if isfield(opts,'P_lim')
%     P_lim = opts.P_lim;
% else
%     P_lim.r = [];
%     P_lim.c = [];
% end
% if isfield(opts,'noise_sigma')
%     noise_sigma = opts.noise_sigma;
% else
%     noise_sigma = 0;
% end

%% save setup stuff
n_runs = 2;
m = 6;
n = 14;
visibility_rate = 1;
descriptor = 'sift';
U_lim = [];
P_lim.r = [];
P_lim.c = [];
if nargin < 2 || isempty(noise_sigma)
    noise_sigma = 0.005;
end


%% generate a set of points. Will be the same for all runs.
[U_orig,U_desc_orig] = simulate_3D_points(n, descriptor, U_lim);
U{1} = [U_orig(:,1:9) U_orig(:,4)+[sigma*randn(3,1);0] U_orig(:,2)+[sigma*randn(3,1);0]];
U_desc{1} = [U_desc_orig(:,1:9) U_desc_orig(:,4) U_desc_orig(:,2)];
U{2} = [U_orig(:,6:end) U_orig(:,6)+[sigma*randn(3,1);0]];
U_desc{2} = [U_desc_orig(:,6:end) U_desc_orig(:,6)];

% sfm_matches = cell(2,15);
sfm_matches= [1:9 NaN(1,5); NaN(1,5) 1:9 ];
sfm_matches = mat2cell(sfm_matches,ones(1,n_runs),ones(1,n));
sfm_matches{1,4} = [sfm_matches{1,4} 10];
sfm_matches{1,2} = [sfm_matches{1,2} 11];
sfm_matches{2,6} = [sfm_matches{2,6} 10];

% matching = cell(2,2);
matching(1,1).match_list = [2 4; 11 10];
% matching(1,2).match_list = [1 3 sfm_matches{1,4}(1) 5 6 7 8 9 NaN NaN NaN NaN NaN; NaN NaN NaN NaN 10 2 3 4 5 6 7 8 9];
matching(1,2).match_list = [6 7 8 9; 10 2 3 4];
matching(2,2).match_list = [1;10];
%% generate n_runs different sets of m cameras (for now in same area)
% project the 3D points in the cameras
for i = 1:n_runs
    P{i} = simulate_cameras(m,P_lim.c,P_lim.r);
    visibility{i} = rand(m,size(U{i},2))<visibility_rate;
    [u{i},u_desc{i}] = get_2D_points(U{i},U_desc{i},P{i},visibility{i});
end


%% Add noise

for k = 1:n_runs
    for i = 1:length(u{k})
        u{k}{i}(1:2,:) = u{k}{i}(1:2,:) + noise_sigma*randn(size(u{k}{i}(1:2,:)));
    end
end


%% move all cameras except the first and do separate bundles, v2
for k = 1:n_runs
    % generate random transformation
    % to shift the bundle optimum
    % to another coordinate system
    [uu,~,~]=svd(rand(3,3));
    if det(uu)<0
        uu(:,3)= -uu(:,3);
    end
    T = [(1+rand(1,1))*uu randn(3,1);0 0 0 1];
    PP = P{k};
    for i = 1:length(PP) 
%         PP{i} = PP{i}*inv(T);'
        % OBS! The below should be the same as the above?
        PP{i} = PP{i}/T;
    end
    SfM.P_uncalib = PP;
    SfM.U = T*U{k};
    for i = 1:length(PP) % OBS! Why 10?
        SfM.u_uncalib.index{i} = find(visibility{k}(i,:));
        SfM.u_uncalib.points{i} = u{k}{i};
        SfM.u_uncalib.desc{i} = u_desc{k}{i};
    end
    SfM.u_uncalib.pointnr = n;
%     if isfield(opts,'Uqind')
%         Uqind = opts.Uqind;
%     else
        Uqind = 1:size(U{k},2); % OBS! Why 10?
%     end

%     SfM = SfM_compress(SfM,Uqind);

    SfM.T_true = T;
    
    SfMs{k} = SfM;
end

matching(1,1).bestS = eye(4);
for i = 2:n_runs
    matching(1,2).bestS = SfMs{i}.T_true;
end
SfMs{1}.Uqind = 1:size(SfMs{1}.U,2);
SfMs{2}.Uqind = 1:size(SfMs{2}.U,2);