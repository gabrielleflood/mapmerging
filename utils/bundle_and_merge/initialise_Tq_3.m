function [init] = initialise_Tq_3(SfMs,sfm_matches,proflag)
% Initialises q to be as close to q1 (with addition of other points) and T
% using Procrustes. T1 will be eye(4). Can be found in init.T and init.q.
% SfMs contains the runs and sfm_matches is a matrix inicating matches
% between the runs.

% Note that the transformations are such that init.T{2}*q1 matches q2, or
% that init.T{2}\q2 matches q1,

% In this version, sfm_matches can be a cell array, with matches within a
% map. If sfm_matches is a matrix, initialise_Tq_2 is called. For points
% that should be added in maps only one of the representations is chosen
% for the initialisation.

%% Initialise T using Procrustes. Also initialise q.
% at this point, we are using all matching points for procrustes

if nargin < 3 || isempty(proflag)
    % decides if scale is estimated in procrustes or not
    proflag = 1;
end    

if iscell(sfm_matches)
    % find the cell positions for which there are more than one match
    ind = find(cellfun('length',sfm_matches) > 1);
    for i = 1:length(ind)
        sfm_matches{ind(i)} = sfm_matches{ind(i)}(1);
    end
    % find the cell positions which are empty and replae these with NaN
    sfm_matches(cellfun('isempty',sfm_matches)) = {NaN};
    sfm_matches = cell2mat(sfm_matches);
end

init = initialise_Tq_2(SfMs, sfm_matches,proflag);