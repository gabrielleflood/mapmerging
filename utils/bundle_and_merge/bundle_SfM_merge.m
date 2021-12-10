function [solopt,res,jac]=bundle_SfM_merge(sol,data,debug);

if nargin<3,
    debug = 0;
end;
%keyboard;
solt = sol;
for kkk = 1:39;
% for kkk = 1:20;
% for kkk = 1:109;
    %kkk
    [res,jac]=calcres_merge(solt,data);
    dzdz = calcder_nonlinear_merge(solt);
    jac = jac*dzdz;
    %dz = -(jac\res);
    if kkk<10,
        dz = -(jac'*jac+0.1*speye(size(jac,2)))\(jac'*res); % Fixa till LM har
    else
        [u,s,v]=svd(full(jac),0);
        u = u(:,1:(end-7));
        s = s(1:(end-7),1:(end-7));
        v = v(:,1:(end-7));
        dz = -v*(s\(u'*res));
    end
    %dz=-pinv(full(jac))*res; %THIS VERSON works for all sizes of jav, even when we ahve more unkowns than equations. When we have more equations tha unknowns (which is usually the case) it handels the extra DOF, that equates to singlar values=0, automativally
    %[soltn]=updateparam(solt,dzdz*dz);
    [soltn]=updateparam_nonlinear_merge(solt,dz);
    [res2,jac2]=calcres_merge(soltn,data);
    aa = [norm(res) norm(res+jac*dz) norm(res2)];
    bb = aa;
    bb=bb-bb(2);
    bb = bb/bb(1);
    cc = norm(jac*dz)/norm(res);
    % Check that the error actually gets smaller
    if norm(res)<norm(res2),
        % bad
        % check that the update is sufficiently big
        % otherwise it is maybe just numerical limitations
        if cc>1e-13,
            % OK then it is probably just the linearization that
            % is not good enough for this large step size, decrease
            kkkk = 1;
            while (kkkk<50) & (norm(res)<norm(res2)),
                dz = dz/2;
                %[soltn]=updateparam(solt,dzdz*dz);
                [soltn]=updateparam_nonlinear_merge(solt,dz);
                [res2,jac2]=calcres_merge(soltn,data);
                kkkk = kkkk+1;
                if debug; disp(kkkk); end;
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
        if debug
            aa
            bb
            cc
        end
    end;
    if norm(res2)<norm(res)
        solt = soltn;
    else
        if debug,
            disp([num2str(kkk) '  stalled']);
        end
    end
end;
solopt = solt;
