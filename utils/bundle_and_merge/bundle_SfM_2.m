function [solopt,res,jac,solopt_many,res_many,jac_many]=bundle_SfM_2(sol,data,debug,nbr_iter)
% almost the same as bundle_SfM, but has an inparameter nbr_iter saying
% when to stop the bundle. There is also added another out parameter with
% different solopt results.


if nargin<3 || isempty(debug)
    debug = 1;
end;
if nargin < 4 || isempty(nbr_iter)
    nbr_iter = 50;
    solopt_many = {};
    res_many = {};
    jac_many = {};
    many_sols = 0;
else
    solopt_many.vals = {};
    solopt_many.iters = nbr_iter;
    res_many = {};
    jac_many = {};
    many_sols = 1;
end

solt = sol;
for kkk = 1:nbr_iter(end)
    %kkk 
    [res,jac]=calcres2(solt,data);
    dzdz = calcder_nonlinear(solt);
    jac = jac*dzdz;
    %keyboard;
    %dz = -(jac\res);
    dz = -(jac'*jac+0.1*speye(size(jac,2)))\(jac'*res);
    %     [u,s,v]=svd(full(jac),0);
    %     u = u(:,1:(end-6));
    %     s = s(1:(end-6),1:(end-6));
    %     v = v(:,1:(end-6));
    %     dz = -v\s*u'*res;
    %dz=-pinv(full(jac))*res; %THIS VERSON works for all sizes of jav, even when we ahve more unkowns than equations. When we have more equations tha unknowns (which is usually the case) it handels the extra DOF, that equates to singlar values=0, automativally
    %[soltn]=updateparam(solt,dzdz*dz);
    [soltn]=updateparam_nonlinear(solt,dz);
    [res2,jac2]=calcres2(soltn,data);
    aa = [norm(res) norm(res+jac*dz) norm(res2)];
    bb = aa;
    bb=bb-bb(2);
    bb = bb/bb(1);
    cc = norm(jac*dz)/norm(res);
    % Check that the error actually gets smaller
    kkkk = 0;
    if norm(res)<norm(res2),
        % bad
        % check that the update is sufficiently big
        % otherwise it is maybe just numerical limitations
        if cc>1e-4,
            % OK then it is probably just the linearization that
            % is not good enough for this large step size, decrease
            kkkk = 1;
            while (kkkk<50) & (norm(res)<norm(res2)),
                dz = dz/2;
                %[soltn]=updateparam(solt,dzdz*dz);
                [soltn]=updateparam_nonlinear(solt,dz);
                [res2,jac2]=calcres2(soltn,data);
                kkkk = kkkk+1;
            end
        end
    end
    if debug,
        aa = [norm(res) norm(res+jac*dz) norm(res2)];
        bb = aa;
        bb=bb-bb(2);
        bb = bb/bb(1);
        cc = norm(jac*dz)/norm(res);
        %keyboard;
        aa
        bb
        cc
        kkkk
    end;
    tmptmp = [kkk kkkk norm(res) norm(res+jac*dz) norm(res2)];
    disp(tmptmp);
    if norm(res2)<norm(res)
        solt = soltn;
    else
        if debug,
            disp([num2str(kkk) '  stalled']);
        end
    end
    if many_sols && sum(kkk == nbr_iter)>0
        solopt_many.vals{find(kkk==nbr_iter)} = solt;
        res_many{find(kkk==nbr_iter)} = res;
        jac_many{find(kkk==nbr_iter)} = jac;
    end
end;

solopt = solt;
