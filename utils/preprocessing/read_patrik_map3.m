function [SfMs]=read_patrik_map3(basefolder,subfolders);
% Copied from read_patrik_map2 2020-10-12, but then some thing were added,
% s.t. subfolders to folder are gone through in this function and the brief
% vectors are added in this function as well. 
% Edited 20210119. If subfolders are used for input, it should be a nx1
% struct (n is the number of subfolders) and at least the field 'folder'
% and preferably also 'folder' (but that should be the same as the
% inparameter folder.

%% First, read the subfolders

% addpath(fullfile(basefolder,'csv_dataloader')) % adds path to the csv_dataloader. Remove, since in utils?
if nargin < 2 || isempty(subfolders)
    subfolders = dir(fullfile(basefolder,'map*'));
else
    for i = 1:length(subfolders)
        
    end
end

%%


for k = 1:length(subfolders)
    % choose the k:th subfolder
    k
    folder = fullfile(basefolder,subfolders(k).name);
    
    % load data!
    [keyframes,objectpoints, keySet_keyframes, keySet_objectpoints] = loadMap(folder);
    
    imlist = keys(keyframes);
    objlist = keys(objectpoints);
    
    % Extract camera matrix again and put in SfM format
    U = zeros(4,length(objlist));
    for i = 1:length(objlist);
        oneobj = objectpoints(objlist{i});
        U(:,i)=[oneobj.X';1];
        Ui(1,i)=oneobj.id;% might be copied from last iteration of not clearvars
    end
    Uiinv = NaN*ones(1,max(Ui));
    Uiinv(Ui)=1:length(Ui);
    Ue = NaN*ones(4,max(Ui));
    Ue(:,Ui)=U;
    n = size(U,2);
    
    SfM.U = U;
    m = length(imlist);
    SfM.P_uncalib = cell(1,m);
    
%     imlist = keys(keyframes);
%     for i = 1:length(imlist);
%         oneframe = keyframes(imlist{i});
%         state = oneframe.state;
%         T = state(1:3)';
%         q = state(7:10);
%         R = quat2rot(q);
%         P = [R' -R'*T];
%         K = oneframe.K;
%         
%         SfM.P_uncalib{1,i} = K*P;
%         
%         u = oneframe.features;
%         uo = oneframe.observations;
%         ucut = u(:,uo(1,:)+1);
%         Ucut1 = Ue(:,uo(2,:));
%         Ucut2 = U(:,Uiinv(uo(2,:)));
%         
%         SfM.u_uncalib.index{i} = Uiinv(uo(2,:));
%         SfM.u_uncalib.points{i} = [ucut;ones(1,size(ucut,2))];
%     end
%     SfM.u_uncalib.pointnr = n;
%     
%     SfM.keyframes = keyframes;
%     SfM.objectpoints = objectpoints;
%     
%     % find bries descriptors for each image point
% %     keyframes = SfM.keyframes;
% %     objectpoints = SfM.objectpoints;
% %     imlist = keys(SfM.keyframes);
% %     objlist = keys(SfM.objectpoints);
%     
%     for i = 1:length(imlist);
%         oneframe = keyframes(imlist{i});
%         state = oneframe.state;
%         
%         u = oneframe.features;
%         uo = oneframe.observations;
%         ud = oneframe.descriptors;
%         ucut = u(:,uo(1,:)+1);
%         udcut = ud(uo(1,:)+1,:);
%         SfM.u_uncalib.desc{i} = udcut';
%     end


    for i = 1:length(imlist);
        oneframe = keyframes(imlist{i});
        state = oneframe.state;
        T = state(1:3)';
        q = state(7:10);
        R = quat2rot(q);
        P = [R' -R'*T];
        K = oneframe.K;
        
        SfM.P_uncalib{1,i} = K*P;
        
        u = oneframe.features;
        uo = oneframe.observations;
        ud = oneframe.descriptors;
        ucut = u(:,uo(1,:)+1);
        udcut = ud(uo(1,:)+1,:);
        Ucut1 = Ue(:,uo(2,:));
        Ucut2 = U(:,Uiinv(uo(2,:)));
        
        SfM.u_uncalib.index{i} = Uiinv(uo(2,:));
        SfM.u_uncalib.points{i} = [ucut;ones(1,size(ucut,2))];
        SfM.u_uncalib.desc{i} = udcut';
    end
    SfM.u_uncalib.pointnr = n;
    
    SfM.keyframes = keyframes;
    SfM.objectpoints = objectpoints;   
    % fram till hit ----
    
    % Detta kanske ska in i read patrik map ocks�. spara brief-molnen f�r
    % varje 3D punkt
    % G�rs kanske ocks� f�r varje SfM individuellt
    clear briefdesc;
    for j = 1:length(objlist);
        tmp = [];
        ij = [];
        desc_mode =[];
        for i = 1:length(imlist);
            tmpsel = find(SfM.u_uncalib.index{i}==j);
            if length(tmpsel)>0,
                ij = [ij [i;j]];
                tmp = [tmp SfM.u_uncalib.desc{i}(:,tmpsel)];
                desc_mode = cat(3,desc_mode,de2bi(SfM.u_uncalib.desc{i}(:,tmpsel))); % OBS! New and not tried
                %std(tmp);
            end
        end
        briefdesc(j).ij = ij;
        briefdesc(j).desc = tmp;
        briefdesc(j).descmode = bi2de(mode(desc_mode,3)); % OBS! New and not tried
    end
    SfM.briefdesc = briefdesc;
    
    
    SfMs{k} = SfM;  
    
    clearvars -except basefolder subfolders SfMs k
end


% does anything else need to be cleared? Clear everything except folders
% and SfMs in beginning?
