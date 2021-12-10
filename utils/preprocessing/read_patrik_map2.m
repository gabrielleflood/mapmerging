function [SfM]=read_patrik_map2(folder);
%


%% load data!
%foldernames = {'map_2020_02_04_16_46_43','map_2020_02_04_16_47_34','map_2020_02_04_16_48_17'};
%
%folder =  fullfile(basefolder,'real_data',foldernames{1});

[keyframes,objectpoints, keySet_keyframes, keySet_objectpoints] = loadMap(folder);

imlist = keys(keyframes);
objlist = keys(objectpoints);

%% Extract camera matrix again and put in SfM format

U = zeros(4,length(objlist));
for i = 1:length(objlist);
    oneobj = objectpoints(objlist{i});
    U(:,i)=[oneobj.X';1];
    Ui(1,i)=oneobj.id;
end
Uiinv = NaN*ones(1,max(Ui));
Uiinv(Ui)=1:length(Ui);
Ue = NaN*ones(4,max(Ui));
Ue(:,Ui)=U;
n = size(U,2);

SfM.U = U;
m = length(imlist);
SfM.P_uncalib = cell(1,m);

imlist = keys(keyframes);
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
    ucut = u(:,uo(1,:)+1);
    Ucut1 = Ue(:,uo(2,:));
    Ucut2 = U(:,Uiinv(uo(2,:)));
    
    SfM.u_uncalib.index{i} = Uiinv(uo(2,:));
    SfM.u_uncalib.points{i} = [ucut;ones(1,size(ucut,2))];
    %SfM.u_uncalib.points{i} = [ucut;ones(1,size(ucut,2))];
end
SfM.u_uncalib.pointnr = n;

SfM.keyframes = keyframes;
SfM.objectpoints = objectpoints;




