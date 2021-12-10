function matchplot(SfMs,sfm_matches,init);

if nargin<3,
    n_runs = length(SfMs);
    figure(11); hold off;
    for i = 1:n_runs;
        %rita3(SfMs{i}.U,'r*'); hold on;
        rita3(SfMs{i}.U(:,SfMs{i}.Uqind),'b*'); hold on;
        mm = sfm_matches(i,:);
        for kk = 1:size(mm,2);
            if isfinite(mm(1,kk)),
                text(SfMs{i}.U(1,mm(1,kk)),SfMs{i}.U(2,mm(1,kk)),SfMs{i}.U(3,mm(1,kk)),[num2str(i) ':' num2str(kk)])
            end
        end
    end
    title('All points');
else
    n_runs = length(SfMs);
    figure(11); hold off;
    rita3(init.q,'g*'); hold on;
    for kk = 1:size(init.q,2);
        text(init.q(1,kk),init.q(2,kk),init.q(3,kk),[num2str(0) ':' num2str(kk)])
    end
    for i = 1:n_runs;
        %rita3(SfMs{i}.U,'r*'); hold on;
        map1 = inv(init.T{i})*SfMs{i}.U(:,SfMs{i}.Uqind);
        %map1 = map1(:,sfm_matches_new);
        map1b = SfMs{i}.res_compressed.qopt;
        map1b = inv(init.T{i})*[reshape(map1b,3,length(map1b)/3); ones(1,length(map1b)/3)];
        rita3(map1,'b*');
        rita3(map1b,'r*');
        mm = sfm_matches(i,:);
        for kk = 1:size(mm,2);
            if isfinite(mm(1,kk)),
                text(map1(1,kk),map1(2,kk),map1(3,kk),[num2str(i) ':' num2str(kk)])
                text(map1b(1,kk),map1b(2,kk),map1b(3,kk),[num2str(i) '=' num2str(kk)])
            end
        end
    end
    title('All points');
end
