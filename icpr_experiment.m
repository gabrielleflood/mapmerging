%% Real data experiment
% The code is based on code from ICPR submission 2020-03-15
% Copied from kalle_testar_real_data_macthing_20201013.m but made shorter
% using several functions . 

%% add paths and folders

thisfolder = pwd;
cd ../
addpath(genpath(pwd))
cd(thisfolder);

% basefolder is the folder which contains the different map folders
% basefolder = 'basefolderpath';

%% Set some options

plotopt = 1;
printopt = 1;
debug = 0; 

%% Read in

% to read data from file, uncomment below
% disp('Reading data from file')
% [SfMs]=read_patrik_map3(basefolder);

% % if not all subfolders are to be used, these can be chosen beforehand
% subfolders = dir(fullfile(basefolder,'map*'));
% subfolders = subfolders(1:4);
% [SfMs]=read_patrik_map3(basefolder, subfolders

%% Load data

% instead of reading it 

load('data1.mat')

%% Do sfm compress on all the different maps. Let all U-points be in q

for i = 1:length(SfMs)
    Uqind = 1:size(SfMs{i}.U,2);
    SfMs{i} = SfM_compress(SfMs{i},Uqind,debug);
end

%% Find tentative pairwise matches bewteen the maps.
% Note that Procrustes is used for this

disp('Finding pairwise matches')
[matching] = get_matching_between_pairs(SfMs, debug);

%% Find tentative matches between all the maps

disp('Generation pre_sfm_matches')
pre_sfm_matches = get_presfmmatches_from_pairs(SfMs, matching, debug);


%% Select a subset of the matches (sfm_matches) 
% Note that this is specific for this map

% pre load which points we are going to try to use in q
% This uses the indices from the full map SfMs{i}.U
% The rows in pre_sfm_matches will be used for selecting Uqind
% After this the new matrix sfm_matches will be generated with
% new indices w r t Uqind.
% Thus there are two relevant index matrices
%   pre_sfm_matches
%   sfm_matches
% and Uqind is based on pre_sfm_matches

load sfm_matches_small;
pre_sfm_matches_all = pre_sfm_matches;
pre_sfm_matches = sfm_matches_small;
pre_sfm_matches(:,20)=[];
% merge point 840 in map 1 with corresponding points in maps 2, 3 o 4
% this match is manually found
pre_sfm_matches(1,5) = 840;

%% Do the merge

disp('Merging the maps')
[SfMs, solopt,res_merge,jac_merge,data] = merge_from_presfmmatches_wo_comp(SfMs, pre_sfm_matches, 0, debug);

%% Extract how all points, in q and s, are moved by the merge

disp('Extracting final maps')
NewU = get_sq_after_merge(SfMs, solopt, data, debug);

%% Plot the final map

figure(7);
clf; hold off;
rita3(NewU{1},'*');
hold on;
rita3(NewU{2},'*');
rita3(NewU{3},'*');
rita3(NewU{4},'*');
axis equal
view(-1.2,-51);
axis off
print(['Kallesrum_3Dmerge.jpg'],'-djpeg');


disp('Done!')