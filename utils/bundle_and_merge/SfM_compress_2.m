function [SfM,SfM_many] = SfM_compress_2(SfM,Uqind,nbr_iter,SfM_many)
% Almost the same as SfM_compress, but has an inparameter nbr_iter saying
% when to stop the bundle in bundle_SfM

if nargin < 3
    nbr_iter = [];
end

sol.P = SfM.P_uncalib;
sol.U = SfM.U;
% sol.U(1:3,:)=sol.U(1:3,:) + 0.01*randn(3,size(sol.U,2)); % St�r startl�sningen lite
sol.U(1:3,:)=sol.U(1:3,:) + 0.4*randn(3,size(sol.U,2)); % St�r startl�sningen lite

m = length(SfM.P_uncalib);
n = SfM.u_uncalib.pointnr;

indmatrix = zeros(m,n);
bigu = [];
bigP = [];
I = [];
J = [];
testres = [];
for i = 1:m,
    ind = SfM.u_uncalib.index{i};
    indmatrix(i,ind)=ones(1,length(ind));
    P = SfM.P_uncalib{i};
    bigP = [bigP P(:)];
    Ucut = SfM.U(:,ind);
    ucut = SfM.u_uncalib.points{i};
    bigu = [bigu ucut];
    I = [I ones(1,length(ind))*i];
    J = [J ind];
    thisres = pflat(P*Ucut)-ucut;
    thisres = thisres(1:2,:);
    testres = [testres; thisres(:)];
end
sol.pv = bigP;
data.u = bigu;
data.I = I';
data.J = J';

[res0,jac]=calcres2(sol,data);
%figure(10); clf; plot(res0,'.');

dzdz = calcder_nonlinear(sol);

[solopt,resopt,jacopt,solopt_many,resopt_many,jacopt_many]=bundle_SfM_2(sol,data,0,nbr_iter);

%%

m = size(solopt.pv,2);
n = size(solopt.U,2);

%Uqind = find(rand(1,n)>0.5);       % Specify which 3D points should be in q
qind = reshape(1:(3*n),3,n)+(6*m); % calculate which columns in jac
                                   % this corresponds to
qind = qind(:,Uqind);
qind = qind(:)';
sind = setdiff(1:(6*m+3*n),qind);
jaca = jacopt(:,qind);
jacb = jacopt(:,sind);
U = jaca'*jaca;
W = jaca'*jacb;
V = jacb'*jacb;
dsdq = -inv(V)*(W');
jac_for_r = jaca+ jacb*dsdq;
%keyboard;
use_column_permutation = 1;
if use_column_permutation,
    [qq,rr,ee]=qr(full(jac_for_r));
else
    [qq,rr]=qr(full(jac_for_r));
end
%jac_qr = qq'*jac_for_r;
qdim = size(rr,2);
jac_qr_small = rr(1:qdim,1:qdim);
% res_qr = qq'*resopt;
% norm_res_qr = norm(res_qr);
% Here comes the compressed result parts (a,R,r)
a = norm(resopt);
R = jac_qr_small;
R((end-6):(end),:)=zeros(7,size(R,2));
%keyboard;
[uu,ss,vv]=svd(R);
R((end-6):(end),:)=vv(:,(end-6):(end))';
%R((end-6):end,(end-6):end) = eye(7);
if use_column_permutation,
    R = R*ee';
end;
qopt = solopt.U(1:3,Uqind);
qopt = qopt(:);
res_compressed.a = a;
res_compressed.R = R(1:(end-7),:);
res_compressed.R_extend = R;
res_compressed.qopt = qopt;
res_all.solopt = solopt;
res_all.data = data;
res_all.SfM = SfM;
res_all.qind = qind;
res_all.sind = sind;
res_all.dsdq = dsdq;

SfM.data = data;
SfM.solopt = solopt; % Ta bort????? Fubbs u res_all
SfM.res_compressed = res_compressed;
SfM.res_all = res_all;
SfM.jacopt = jacopt;
SfM.resopt = resopt;
SfM.dzdz = dzdz;
SfM.Uqind = Uqind;


%% compress the results for each solopt in solopt_many

for ii = 1:length(nbr_iter)

    m = size(solopt_many.vals{ii}.pv,2);
    n = size(solopt_many.vals{ii}.U,2);
    
    %Uqind = find(rand(1,n)>0.5);       % Specify which 3D points should be in q
    qind = reshape(1:(3*n),3,n)+(6*m); % calculate which columns in jac
    % this corresponds to
    qind = qind(:,Uqind);
    qind = qind(:)';
    sind = setdiff(1:(6*m+3*n),qind);
    jaca = jacopt_many{ii}(:,qind);
    jacb = jacopt_many{ii}(:,sind);
    U = jaca'*jaca;
    W = jaca'*jacb;
    V = jacb'*jacb;
    dsdq = -inv(V)*(W');
    jac_for_r = jaca+ jacb*dsdq;
    %keyboard;
    use_column_permutation = 1;
    if use_column_permutation,
        [qq,rr,ee]=qr(full(jac_for_r));
    else
        [qq,rr]=qr(full(jac_for_r));
    end
    %jac_qr = qq'*jac_for_r;
    qdim = size(rr,2);
    jac_qr_small = rr(1:qdim,1:qdim);
    % res_qr = qq'*resopt;
    % norm_res_qr = norm(res_qr);
    % Here comes the compressed result parts (a,R,r)
    a = norm(resopt_many{ii});
    R = jac_qr_small;
    R((end-6):(end),:)=zeros(7,size(R,2));
    %keyboard;
    [uu,ss,vv]=svd(R);
    R((end-6):(end),:)=vv(:,(end-6):(end))';
    %R((end-6):end,(end-6):end) = eye(7);
    if use_column_permutation,
        R = R*ee';
    end;
    qopt = solopt_many.vals{ii}.U(1:3,Uqind);
    qopt = qopt(:);
    res_compressed.a = a;
    res_compressed.R = R(1:(end-7),:);
    res_compressed.R_extend = R;
    res_compressed.qopt = qopt;
    res_all.solopt = solopt_many.vals{ii};
    res_all.data = data;
    res_all.SfM = SfM;
    res_all.qind = qind;
    res_all.sind = sind;
    res_all.dsdq = dsdq;
    
    SfM_many{ii}.data = data;
    SfM_many{ii}.solopt = solopt_many.vals{ii}; % Ta bort????? Fubbs u res_all
    SfM_many{ii}.res_compressed = res_compressed;
    SfM_many{ii}.res_all = res_all;
    SfM_many{ii}.jacopt = jacopt_many{ii};
    SfM_many{ii}.resopt = resopt_many{ii};
    SfM_many{ii}.dzdz = dzdz;
    SfM_many{ii}.Uqind = Uqind;
    SfM_many{ii}.iters = solopt_many.iters(ii);
    
  
end