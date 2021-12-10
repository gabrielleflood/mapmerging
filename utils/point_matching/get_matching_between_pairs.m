function [matching] = get_matching_between_pairs(SfMs, debug)
% function [matching, Ts] = get_matching_between(SfMs, debug)
% finds tentative matches between different maps in SfMs. For this, the
% brief desctriptors must be computed for the points. 
% matching is a  struct for each map pair k1,k2, where matching(k1,k2) has
% fields
% - match_list: 2xn double where the indices of the n matches between map 
% k1 and k2 are given
% - bestS: A 4×4 matrix giving a transformation between the maps
% match_U1: 4×n double with the points from map k1
% match_U2: 4×n double with the matching points from map k2

if nargin < 2 || isempty(debug)
    debug = 0;
end

d_matrices = cell(4,4);
for k1 = 1:length(SfMs)-1
    for k2 = max((k1+1),1):length(SfMs)
        [match_list,bestS,match_U1,match_U2,tmpd]=find_matches_between_SfMs(SfMs,k1,k2,debug);
        d_matrices{k1,k2}=tmpd;
        matching(k1,k2).match_list = match_list;
        matching(k1,k2).bestS = bestS;
        matching(k1,k2).match_U1 = match_U1;
        matching(k1,k2).match_U2 = match_U2;
        %pause;
    end
end


%% Check that matching works

if debug
    for k1 = 1:length(SfMs)-1
        for k2 = (k1+1):length(SfMs)
            for k3 = (k2+1):length(SfMs)
                [matching(k1,k2).bestS matching(k1,k3).bestS*inv(matching(k2,k3).bestS)]
            end
        end
    end
    
    %% Generate Transformation matrices
    
    Ts{1} = eye(4);
    k1 = 1;
    for k2 = (k1+1):length(SfMs)
        Ts{k2}= matching(k1,k2).bestS;
    end
    
    %% Now we have a preliminary merging based on
    % transformations Ts and matching points sfm_matches
    
    figure(1); clf; hold off;
    for k = 1:length(SfMs)
        Us{k} = Ts{k}*SfMs{k}.U;
        tmp = Us{k};
        plot3(tmp(1,:),tmp(2,:),tmp(3,:),'*');
        hold on
    end
end
