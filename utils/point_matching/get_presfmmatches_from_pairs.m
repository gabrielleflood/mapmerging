function pre_sfm_matches = get_presfmmatches_from_pairs(SfMs, matching, debug)
% Goes from pairwise matches to matches over all map representations.
% matching is the output from get_matching_between_pairs. sfm_matches is a
% cell array or a matrix where each column represents a global map point
% and each row a map. The value at position (a,b) shows which of the points
% in map a that matches to the global point nbr b. 

if nargin < 3 || isempty(debug)
    debug = 0;
end

% take out transformation matrices from each of the maps to the coordinate
% system of the first map
Ts{1} = eye(4);
k1 = 1;
for k2 = (k1+1):length(SfMs)
    Ts{k2}= matching(k1,k2).bestS;
end

%% Find tentative matches
sfm_matches = zeros(length(SfMs),0);
q = zeros(length(SfMs),0);
kass_col = [];
for k1 = 1:length(SfMs)-1
    for k2 = (k1+1):length(SfMs)
        mm = matching(k1,k2).match_list;
        usedk1 = sort(unique(sfm_matches(k1,:)));
        usedk2 = sort(unique(sfm_matches(k2,:)));
        already_in_q1 = ismember(mm(1,:),usedk1);
        already_in_q2 = ismember(mm(2,:),usedk2);
        new_points = ~(already_in_q1 | already_in_q2);
        newsfm = NaN*ones(length(SfMs),sum(new_points));
        newsfm(k1,:)=mm(1,find(new_points));
        newsfm(k2,:)=mm(2,find(new_points));
        newq1 = Ts{k1}*SfMs{k1}.U(:,mm(1,find(new_points)));
        newq2 = Ts{k2}*SfMs{k2}.U(:,mm(2,find(new_points)));
        if debug
            sqrt(sum( (newq1-newq2).^2 ))
        end
        newq = (newq1+newq2)/2;
        q = [q newq];
        sfm_matches = [sfm_matches newsfm];
        %
        mold = mm(:,find(already_in_q1));
        for ii = 1:size(mold,2);
            i1 = mold(1,ii);
            i2 = mold(2,ii);
            col = find(sfm_matches(k1,:)==i1);
%             if length(col) >1
%                 keyboard;
%             end
            if isnan(sfm_matches(k2,col))
                sfm_matches(k2,col) = i2;
            elseif sfm_matches(k2,col) ~= i2
                keyboard;
                kass_col = [kass_col col];
            end
        end
        mold = mm(:,find(already_in_q2));
        for ii = 1:size(mold,2);
            i1 = mold(1,ii);
            i2 = mold(2,ii);
            col = find(sfm_matches(k2,:)==i2);
%             if length(col) >1
%                 keyboard;
%             end
            if isnan(sfm_matches(k1,col)),
                sfm_matches(k1,col) = i1;
            elseif sfm_matches(k1,col) ~= i1
                keyboard;
                kass_col = [kass_col col];
            end
        end
    end
end

pre_sfm_matches = sfm_matches;
