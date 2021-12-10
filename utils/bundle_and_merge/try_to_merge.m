function [solopt,res_merge,jac_merge,data] = try_to_merge(SfMs,sfm_matches,init,debug);

% Init
n_qpoints = size(sfm_matches,2);
n_runs = length(SfMs);

if nargin < 3 || isempty(init)
    % setup sol
    sol.qtot = [zeros(3,n_qpoints);ones(1,n_qpoints)];
    tv = zeros(16,n_runs);
    for k = 1:n_runs,
        T = eye(4);
        tv(:,k) = T(:); 
    end
    sol.tv = tv;
else
    % setup sol
    sol.qtot = init.q;
    tv = zeros(16,n_runs);
    for k = 1:n_runs
        T = init.T{k};
        tv(:,k) = T(:);
    end
    sol.tv = tv;
end

if nargin <4 || isempty(debug)
    debug = 0;
end

% setup data
bigq= [];
testres = [];
bigR = [];
I = [];
J = [];
for i = 1:n_runs    
    if debug
        i 
    end
    qtmp = SfMs{i}.res_compressed.qopt;
    qtmp = reshape(qtmp,3,length(qtmp)/3);
    bigq = [bigq qtmp];
    ind = isfinite(sfm_matches(i,:));
    tmp1 = 1:size(sfm_matches,2);
    tmp1 = tmp1(find(ind));
    tmp2 = sfm_matches(i,find(ind));
    tmp2i = [];
    tmp2i(tmp2) = 1:length(tmp2);
    tmp3 = tmp1(tmp2i);
    
    I = [I ones(1,length(tmp3))*i];
    J = [J tmp3];
    %     figure(1);
    %     clf; hold off;
    %     rita(ucut,'*');
    %     hold on
    %     rita(pflat(P*Ucut),'o');
    thisR = SfMs{i}.res_compressed.R_extend;
    [mm,nn]=size(thisR);
    bigR = [bigR zeros(size(bigR,1),nn);zeros(mm,size(bigR,2)) thisR];
    %     thisres = reshape(sol.tv(:,i),4,4)*sol.qtot- [qtmp;ones(1,size(qtmp,2))];
    %     thisres = thisres(1:3,:);
    %     thisres = thisres(:);
    %     testres = [testres; thisR*thisres(:)];
    clear tmp2i
end
data.q = bigq;
data.I = I';
data.J = J';
data.bigR = sparse(bigR);

%% This is the new bundle

[solopt,res_merge,jac_merge]=bundle_SfM_merge(sol,data,debug);
%[solopt,res_merge,jac_merge]=bundle_SfM_merge(solopt,data,0);
%[solopt,res_merge,jac_merge]=bundle_SfM_merge(solopt,data,0);



