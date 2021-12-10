function [dq_tot,individual_dqs] = extract_merge_dqs(sol,data);


%% 

m = size(sol.tv,2); % nr of bundle runs
n = size(sol.qtot,2);  % nr of 3D points
jac_m = size(data.q,2)*3; % nr of image points * 2, i e nr of residuals, i e nr of rows of jac
jac_n = 16*m+3*n;        % nr of unknown variables, i e nr of columns of jac

p1 = sol.tv(1,data.I)';
p2 = sol.tv(2,data.I)';
p3 = sol.tv(3,data.I)';
p4 = sol.tv(4,data.I)';
p5 = sol.tv(5,data.I)';
p6 = sol.tv(6,data.I)';
p7 = sol.tv(7,data.I)';
p8 = sol.tv(8,data.I)';
p9 = sol.tv(9,data.I)';
p10 = sol.tv(10,data.I)';
p11 = sol.tv(11,data.I)';
p12 = sol.tv(12,data.I)';
p13 = sol.tv(13,data.I)';
p14 = sol.tv(14,data.I)';
p15 = sol.tv(15,data.I)';
p16 = sol.tv(16,data.I)';

u1 = sol.qtot(1,data.J)';
u2 = sol.qtot(2,data.J)';
u3 = sol.qtot(3,data.J)';
u4 = sol.qtot(4,data.J)';

ptu1 = p1.*u1 + p5.*u2 + p9.*u3 + p13.*1;
ptu2 = p2.*u1 + p6.*u2 + p10.*u3 + p14.*1;
ptu3 = p3.*u1 + p7.*u2 + p11.*u3 + p15.*1;

dq_tot = [(ptu1'-data.q(1,:));(ptu2'-data.q(2,:));(ptu3'-data.q(3,:))];
for k = 1:m,
    individual_dqs{k} = dq_tot(:,find(data.I==k));
    individual_dqs{k} = individual_dqs{k}(:);  
end

