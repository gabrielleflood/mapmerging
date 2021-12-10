function [init] = initialise_Tq_2(SfMs,sfm_matches,proflag)
% Initialises q to be as close to q1 (with addition of other points) and T
% using Procrustes. T1 will be eye(4). Can be found in init.T and init.q.
% SfMs contains the runs and sfm_matches is a matrix inicating matches
% between the runs.

% Note that the transformations are such that init.T{2}*q1 matches q2, or
% that init.T{2}\q2 matches q1,

% New version that uses 

%% Initialise T using Procrustes. Also initialise q.
% at this point, we are using all matching points for procrustes

if nargin < 3 || isempty(proflag)
    % decides if scale is estimated in procrustes or not
    proflag = 1;
end    

% matrix to save initialisation for q in
q_init = nan(4,size(sfm_matches,2)); 

% assume that T_1 = eye(4)
T_init{1} = eye(4);
% add all points in q1 to q
ind_init = find(~isnan(sfm_matches(1,:)));
%q_init(:,ind_init) = SfMs{1}.U(:,sfm_matches(1,ind_init));
q1opt = SfMs{1}.res_compressed.qopt;
n_q1points = length(q1opt)/3;
q1 = [reshape(q1opt,3,n_q1points);ones(1,n_q1points)];
% q_init(:,ind_init) = q1;
% the below should work even if not all q1-points are to be matched. 
q_init(:,ind_init) = q1(:,sfm_matches(1,ind_init));

% find points that are seen in all maps
%ind_pro = find(~sum(isnan(sfm_matches),1));
%U_pro{1} = SfMs{1}.U(:,sfm_matches(1,ind_pro));

for i = 2:length(SfMs) 
%     i
    % find points that are in borh q_pro and U{i}
    ind_init = find(sum(~isnan(sfm_matches(1:i-1,:)),1) & ~isnan(sfm_matches(i,:)));
    % pick out points for Procrustes
    U_pro_1 = q_init(:,ind_init);
    %
    %U_pro_i = SfMs{i}.U(:,sfm_matches(i,ind_init));
    % Don't use U, use q from res_compressed instead
    qiopt = SfMs{i}.res_compressed.qopt;
    n_qipoints = length(qiopt)/3;
    qi = [reshape(qiopt,3,n_qipoints);ones(1,n_qipoints)];
    U_pro_i = qi(:,sfm_matches(i,ind_init));
    % Perform procrustes on q to match qi
    [d,Z,transform] = procrustes(U_pro_i(1:3,:)',U_pro_1(1:3,:)','scaling',proflag);
    % check result
    if (sum(sum((U_pro_i(1:3,:)-Z').^2)) > sum(sum((U_pro_i(1:3,:)-U_pro_1(1:3,:)).^2)))
        disp(['Bad Procrustes 1, i= ' num2str(i)]) 
        keyboard
    end

    % save Procrustes result as a transdformation matrix
    T_init{i} = zeros(4);
    T_init{i}(1:3,1:3) = transform.b*transform.T';
    T_init{i}(1:3,4) = transform.c(1,:)';
    T_init{i}(4,4) = 1;
    
    tmp1 = T_init{i}*U_pro_1;
    if abs(sum(sum((U_pro_i(1:3,:)-Z').^2)) - sum(sum((U_pro_i(1:3,:)-tmp1(1:3,:)).^2)))>0.01
        disp(['Bad Procrustes 2, i= ' num2str(i)]) 
    end    
%     tmp1 = T_init{i}\U_pro_i;
%     if abs(sum(sum((U_pro_i(1:3,:)-Z').^2)) - sum(sum((tmp1(1:3,:)-U_pro_1(1:3,:)).^2)))>0.01
%         disp(['Bad Procrustes 3, i= ' num2str(i)]) 
%     end    
    
    % find points that were in the i_th bundle and that are not yet in
    % q_pro
    tmp_ind_1 = find(isnan(q_init(4,:)));
    tmp_ind_2 = sfm_matches(i,tmp_ind_1 );
    tmp_ind_1(find(isnan(tmp_ind_2))) = [];
    tmp_ind_2(find(isnan(tmp_ind_2))) = [];
    
    %q_init(:, tmp_ind_1) = T_init{i} \ SfMs{i}.U(:, tmp_ind_2);
    q_init(:, tmp_ind_1) = T_init{i} \ qi(:, tmp_ind_2);
end

init.T = T_init;
init.q = q_init;

% check initialisations
if 0
    figure(10); clf;
    tmptmp = {'bo','rx','k+'};
    for i = 1:length(SfMs)
        tmp = T_init{i}\SfMs{i}.U;
        pflat(tmp);
        plot3(tmp(1,:),tmp(2,:),tmp(3,:),tmptmp{mod(i,3)+1});
        hold on;
    end
end