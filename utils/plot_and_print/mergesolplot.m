function mergesolplot(SfMs,solopt);

% n_runs = length(SfMs);
% figure(11); hold off;
% rita3(solopt.qtot,'g*'); hold on;
% for kk = 1:size(init.q,2);
%     text(init.q(1,kk),init.q(2,kk),init.q(3,kk),[num2str(0) ':' num2str(kk)])
% end

n_runs = length(SfMs);
for i = 1:n_runs,
    solopt.T{i}=reshape(solopt.tv(:,i),4,4);
end


figure(22);
clf; hold off;
figure(23);
clf; hold off;
rita3(solopt.qtot,'bo');
hold on;
for i = 1:n_runs;
    %rita3(SfMs{i}.U,'r*'); hold on;
    map1 = solopt.T{i}*solopt.qtot;
    %map1 = map1(:,sfm_matches_new);
    mapi = [reshape(SfMs{i}.res_compressed.qopt,3,length(SfMs{i}.res_compressed.qopt)/3);ones(1,length(SfMs{i}.res_compressed.qopt)/3)];
    mapi_transformed = inv(solopt.T{i})*[reshape(SfMs{i}.res_compressed.qopt,3,length(SfMs{i}.res_compressed.qopt)/3);ones(1,length(SfMs{i}.res_compressed.qopt)/3)];
    figure(22);
    subplot(1,4,i); hold off; 
    rita3(map1,'go'); hold on; 
    rita3(mapi,'b*');
    for kk = 1:size(mapi,2);
        if isfinite(mapi(1,kk)),
            text(map1(1,kk),map1(2,kk),map1(3,kk),[num2str(i) ':' num2str(kk)])
            text(mapi(1,kk),mapi(2,kk),mapi(3,kk),[num2str(i) '=' num2str(kk)])
        end
    end
    figure(23); hold on;
    rita3(mapi_transformed,'b*');
%     for kk = 1:size(mapi_transformed,2);
%         if isfinite(mapi_transformed(1,kk)),
%             text(mapi_transformed(1,kk),mapi_transformed(2,kk),mapi_transformed(3,kk),[num2str(i) '=' num2str(kk)])
%         end
%     end
end
title('All points');


% 
% if plotopt
%     figure(22);
%     clf; hold off;    clf; hold off;
% 
%     figure(23);
%     clf; hold off;
%     rita3(solopt.qtot,'bo');
%     hold on;
%     for i = 1:n_runs
%         figure(22);
%         subplot(1,n_runs,i);
%         rita3(SfMs{i}.U(:,SfMs{i}.Uqind),'r*');
%         hold on;
%         rita3(solopt.T{i}*solopt.qtot,'bo');
%         figure(23);
%         rita3(inv(solopt.T{i})*SfMs{i}.U(:,SfMs{i}.Uqind),'r*');
%     end   
% end

% 
% figure(24); rita3(SfM_full.solopt.U,'r*');
% hold on;
% rita3(SfM_full.U,'bo');
% title('Full bundle?')
% 

% 
% for i = 1:n_runs;
%     %rita3(SfMs{i}.U,'r*'); hold on;
%     map1 = inv(init.T{i})*SfMs{i}.U(:,SfMs{i}.Uqind);
%     %map1 = map1(:,sfm_matches_new);
%     map1b = SfMs{i}.res_compressed.qopt;
%     map1b = inv(init.T{i})*[reshape(map1b,3,length(map1b)/3); ones(1,length(map1b)/3)];
%     rita3(map1,'b*');
%     rita3(map1b,'r*');
%     mm = sfm_matches(i,:);
%     for kk = 1:size(mm,2);
%         if isfinite(mm(1,kk)),
%             text(map1(1,kk),map1(2,kk),map1(3,kk),[num2str(i) ':' num2str(kk)])
%             text(map1b(1,kk),map1b(2,kk),map1b(3,kk),[num2str(i) '=' num2str(kk)])
%         end
%     end
% end
% title('All points');
