function [matching] = get_tentative_pairmatches(SfMs, descmode, debug)
% finds tentative matches between different maps in SfMs. For this, the
% brief desctriptors must have been computed for the points. 
% matching is a  struct for each map pair k1,k2, where matching(k1,k2) has
% fields
% - match_list: 2xn double where the indices of the n matches between map 
% k1 and k2 are given

if nargin < 3 || isempty(debug)
    debug = 0;
end
if nargin < 2 || isempty(descmode)
    descmode = 1;
end

% d_matrices = cell(4,4);

% go through all map pairs
for k1 = 1:length(SfMs)-1
    for k2 = max((k1+1),1):length(SfMs)
        % Calculate distances between all 3D points in map k1 and in k2
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
                if descmode
                    d(i1,i2)=brief_dist(brief1(i1).descmode,brief2(i2).descmode);
                    d(i1,i2)=(d(i1,i2)-127)/22;
                else
                    d(i1,i2)=cluster_dist_2(brief1(i1).desc,brief2(i2).desc);   
                end
            end
        end
        
        % Select matches that are best both from k1 to k2 and from k2 to k1
        
        mm = [];
        
        for i1 = 1:n1,
            [minv1,minj]=min(d(i1,:));
            [minv2,mini]=min(d(:,minj));
            if i1 == mini,
                %[i1 minv1 minj minv2 mini];
                mm = [mm [i1;minj]];
            end
        end
        
        if debug
            debug_function_1(SfMs, mm, k1, k2)
        end
        
        
        
%         d_matrices{k1,k2}=tmpd;
        matching(k1,k2).match_list = mm;
        %pause;
    end
end

% also, go through and look within the maps
for k = 1:length(SfMs)
    % Calculate distances between all 3D points in map k1 and in k2
    brief = SfMs{k}.briefdesc;
    n = length(brief);
    d = nan(n,n); % set to nan so un-computed values are lagre
    if debug
        disp('Calculate brief distances');
    end
%     for i1 = 1:n-1
    for i1 = 1:n
        if debug
            disp(['Nr ' num2str(i1) ' of ' num2str(n)]);
        end
%         for i2 = i1+1:n
        i2s = 1:n;
        i2s(i1) = [];
        for i2 = i2s

            if descmode
                d(i1,i2)=brief_dist(brief(i1).descmode,brief(i2).descmode);
                d(i1,i2)=(d(i1,i2)-127)/22;
            else
                d(i1,i2)=cluster_dist_2(brief(i1).desc,brief(i2).desc);
            end
        end
    end
    
    % Select matches that are best both from k1 to k2 and from k2 to k1
    
    mm = [];
    
    for i1 = 1:n,
        [minv1,minj]=min(d(i1,:));
        [minv2,mini]=min(d(:,minj));
        if i1 == mini,
            %[i1 minv1 minj minv2 mini];
            mm = [mm [i1;minj]];
        end
    end
    % remove duplicates
    mm = mm(:,mm(1,:) < mm(2,:));

    if debug
        debug_function_1(SfMs, mm, k, k)
    end
    
    
    
    %         d_matrices{k1,k2}=tmpd;
    matching(k,k).match_list = mm;
    %pause;
    
end


function debug_function_1(SfMs, mm, k1, k2)

% debugplottar

U1 = SfMs{k1}.U(:,mm(1,:));
U2 = SfMs{k2}.U(:,mm(2,:));


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
