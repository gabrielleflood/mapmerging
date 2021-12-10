function [match_list,bestS,match_U1,match_U2,d]=find_matches_between_SfMs(SfMs,k1,k2,debug);

% k1 = 1;
% k2 = 2;

if nargin < 4 || isempty(debug)
    debug = 0;
end

%% Calculate distances between all 3D points in map k1 and in k2
brief1 = SfMs{k1}.briefdesc;
brief2 = SfMs{k2}.briefdesc;
n1 = length(brief1);
n2 = length(brief2);
d = zeros(n1,n2);
if debug
    disp('Calculate brief distances');
end
for i1 = 1:n1
    if debug
        disp(['Nr ' num2str(i1) ' of ' num2str(n1)]);
    end
    for i2 = 1:n2;
        d(i1,i2)=cluster_dist_2(brief1(i1).desc,brief2(i2).desc);
    end
end

%% Select matches that are best both from k1 to k2 and from k2 to k1

mm = [];

for i1 = 1:n1,
    [minv1,minj]=min(d(i1,:));
    [minv2,mini]=min(d(:,minj));
    if i1 == mini,
        %[i1 minv1 minj minv2 mini];
        mm = [mm [i1;minj]];      
    end
end

%% debugplottar

U1 = SfMs{k1}.U(:,mm(1,:));
U2 = SfMs{k2}.U(:,mm(2,:));

if debug 
    
    figure(1); 
    subplot(1,2,1); hold off; rita3(SfMs{k1}.U,'*'); hold on;
    subplot(1,2,2); hold off; rita3(SfMs{k2}.U,'*'); hold on;
    for kk = 1:size(mm,2);
        subplot(1,2,1); 
        hold on;
        text(SfMs{k1}.U(1,mm(1,kk)),SfMs{k1}.U(2,mm(1,kk)),SfMs{k1}.U(3,mm(1,kk)),num2str(kk))
        subplot(1,2,2); 
        hold on;
        text(SfMs{k2}.U(1,mm(2,kk)),SfMs{k2}.U(2,mm(2,kk)),SfMs{k2}.U(3,mm(2,kk)),num2str(kk))
    end
    title('All points');

    figure(2); 
    subplot(1,2,1); hold off; rita3(U1,'*'); hold on;
    subplot(1,2,2); hold off; rita3(U2,'*'); hold on;
    for kk = 1:size(mm,2);
        subplot(1,2,1); 
        hold on;
        text(SfMs{k1}.U(1,mm(1,kk)),SfMs{k1}.U(2,mm(1,kk)),SfMs{k1}.U(3,mm(1,kk)),num2str(kk))
        subplot(1,2,2); 
        hold on;
        text(SfMs{k2}.U(1,mm(2,kk)),SfMs{k2}.U(2,mm(2,kk)),SfMs{k2}.U(3,mm(2,kk)),num2str(kk))
    end
    title('Brief matched points');

end
%% ransac on U1 and U2

sel = randperm(size(U1,2),3);
%U2 = U2(:,randperm(225));
[dd,zz,T] = procrustes(U1(1:3,sel)',U2(1:3,sel)'); % Gives the transform between U2 and U1
S = [T.b*T.T' T.c(1,:)';0 0 0 1];
dds = sort(sqrt(  sum( (U1-S*U2)).^2 ));
if debug
    figure(3); hold off
    plot(dds); hold on;
end

maxinl = 0;
for k = 1:200;
    sel = randperm(size(U1,2),3);
    [dd,zz,T] = procrustes(U1(1:3,sel)',U2(1:3,sel)'); % Gives the transform between U2 and U1
    S = [T.b*T.T' T.c(1,:)';0 0 0 1];
    dds = sort(sqrt(  sum( (U1-S*U2)).^2 ));
    if debug
        figure(3); hold on
        plot(dds)
    end
end

if debug
    axis([0 length(dds) 0 5]);
    title('Sorted ransac distances');
    xlabel('nr of points');
    ylabel('distance');
end

%% Hard-coded threshold here - 0.02 meter???

maxinl = 0;
threshold = 0.04;
% threshold = 0.02;
for k = 1:1000;
    sel = randperm(size(U1,2),3);
    [dd,zz,T] = procrustes(U1(1:3,sel)',U2(1:3,sel)'); % Gives the transform between U2 and U1
    S = [T.b*T.T' T.c(1,:)';0 0 0 1];
    %dds = sort(sqrt(  sum( (U1-S*U2)).^2 ));
    inl = find(sqrt(  sum( (U1-S*U2)).^2 ) < threshold );
    nrinl = length(inl);
    if nrinl>maxinl,
        maxinl = nrinl;
        bestinl = inl;
        bestS = S;
    end
end

if debug
    figure(4); 
    hold off; rita3(U1,'*'); hold on;
    rita3(bestS*U2,'o'); hold on;
    rita3(U1(:,bestinl),'g*'); hold on;
    rita3(bestS*U2(:,bestinl),'go'); hold on;
    title('Transformed and matched (in green)');
end

%% Output

match_list = mm(:,bestinl);
% bestS
match_U1 = U1(:,bestinl);
match_U2 = S*U2(:,bestinl);
