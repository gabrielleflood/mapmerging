function [SfMs, solopt,res_merge,jac_merge,data] = merge_from_presfmmatches_wo_comp(SfMs, pre_sfm_matches, plotopt, debug)
% merges the maps in SfMs using the matches given in pre_sfm_matches.
% Before this is done, the sfm_compress is rerun tho make the lokal maps
% only contain the points that will be merged. 

if nargin < 3 || isempty(plotopt)
    plotopt = 0;
end
if nargin < 4 || isempty(debug)
    debug = 0;
end

% Uqind should already be specified. If it is not, just add all points to
% Uqind

for i = 1:length(SfMs)
    if ~isfield(SfMs{i},'Uqind')
        SfMs{i}.Uqind = 1:size(SfMs{i}.U,2);
    end
end

% Now, pre_sfm_matches can be used as sfm_matches
sfm_matches = pre_sfm_matches;
%%

% Add "lonely" points, that are not matches between maps
% OBS! Have a second look at this. 
% This is important when sfm_compress is not re-run. 
for k = 1:length(SfMs)
    tmp = sfm_matches(k,:);
    tmp = unique(tmp(find(isfinite(tmp))));
    newids = setdiff(1:length(SfMs{k}.Uqind),tmp);
    newsfm = NaN*ones(4,length(newids));
    newsfm(k,:)=newids;
    sfm_matches = [sfm_matches newsfm];
end


%%

% multiply the values in R_extend that should be zero with 1000 so they
% can be read more easily in the matrix. 
for i = 1:4,
    SfMs{i}.res_compressed.R_extend((end-6):end,:)=SfMs{i}.res_compressed.R_extend((end-6):end,:)*1000;
end
%% This is the actual merge

if plotopt
    matchplot(SfMs,sfm_matches);
end
if ~iscell(sfm_matches)
    init = initialise_Tq_2(SfMs,sfm_matches);
else
    init = [];
end
if plotopt
    matchplot(SfMs,sfm_matches,init);
end
[solopt,res_merge,jac_merge,data] = try_to_merge_1ormore(SfMs,sfm_matches,init,debug);
if plotopt
    mergesolplot(SfMs,solopt);
end
%% Titta p� resultatet

if debug
    disp('Residualvektorn för mergeproblemet borde ha 7 nollor i slutet av varje bundle-del');
    res_merge'
end

%% Compare errors (std:s) again

if debug
    %disp('Nu när vi låst 25 punkter i 4 vyer, så har vi 25*3*3 färre frihetsgrader'); % 9 punkter, 2=3-1 pga 3 vyer och 3 pga 3 koordinater
    %disp('Då borde kvadratsumman öka med sigma^2*54');
    
    disp(['Nu när vi låst ' num2str(sum(sum(isfinite(sfm_matches),1)-1)) ' punkter totalt bland ' num2str(length(SfMs)) ' bundle sessioner, så har vi ' num2str(sum(sum(isfinite(sfm_matches),1)-1)) '*3 färre frihetsgrader']);
    disp(['Då borde kvadratsumman öka med sigma^2*' num2str(( sum(sum(isfinite(sfm_matches),1)-1) * (2-1) * 3  ))]);
    [res_merge'*res_merge noise_sigma^2*( sum(sum(isfinite(sfm_matches),1)-1) * (2-1) * 3  )]
    
    disp(['Nu när vi låst ' num2str(sum(sum(isfinite(sfm_matches),1)-1)) ' punkter, så har vi färre frihetsgrader']);
    [noise_sigma^2*(size(SfMs{1}.jacopt ,1) -size(SfMs{1}.jacopt ,2) +7) ...
        noise_sigma^2*(size(SfMs{2}.jacopt ,1) -size(SfMs{1}.jacopt ,2) +7) ...
        noise_sigma^2*(size(SfMs{3}.jacopt ,1) -size(SfMs{1}.jacopt ,2) +7) ...
        noise_sigma^2*(size(SfMs{4}.jacopt ,1) -size(SfMs{1}.jacopt ,2) +7) ...
        noise_sigma^2*( sum(sum(isfinite(sfm_matches),1)-1) * (2-1) * 3  )]
    round([SfMs{1}.res_compressed.a^2 ...
        SfMs{2}.res_compressed.a^2 ...
        SfMs{3}.res_compressed.a^2 ...
        SfMs{4}.res_compressed.a^2 ...
        res_merge'*res_merge])
end

%%

if debug
    figure(9);
    tmp = SfMs{1}.data;
    plot(tmp.I,tmp.J,'*');
end

