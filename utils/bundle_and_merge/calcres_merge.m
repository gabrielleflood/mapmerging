function [res,jac]=calcres_merge(sol,data);

m = size(sol.tv,2); % nr of images
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


res = [(ptu1'-data.q(1,:));(ptu2'-data.q(2,:));(ptu3'-data.q(3,:))];
res = res(:);

II1 = 3*(1:length(ptu1))'-2;
II2 = 3*(1:length(ptu1))'-1;
II3 = 3*(1:length(ptu1))';

JJp1 = (data.I-1)*16+1;
JJp2 = (data.I-1)*16+2;
JJp3 = (data.I-1)*16+3;
JJp4 = (data.I-1)*16+4;
JJp5 = (data.I-1)*16+5;
JJp6 = (data.I-1)*16+6;
JJp7 = (data.I-1)*16+7;
JJp8 = (data.I-1)*16+8;
JJp9 = (data.I-1)*16+9;
JJp10 = (data.I-1)*16+10;
JJp11 = (data.I-1)*16+11;
JJp12 = (data.I-1)*16+12;
JJp13 = (data.I-1)*16+13;
JJp14 = (data.I-1)*16+14;
JJp15 = (data.I-1)*16+15;
JJp16 = (data.I-1)*16+16;

JJU1 = 16*m + (data.J-1)*3+1;
JJU2 = 16*m + (data.J-1)*3+2;
JJU3 = 16*m + (data.J-1)*3+3;

%
II = [];
JJ = [];
v = [];
% 1-3
dptu1dp1 = u1;
v = [v; dptu1dp1];
II = [II; II1];
JJ = [JJ; JJp1];
dptu2dp2 = u1;
v = [v; dptu2dp2];
II = [II; II2];
JJ = [JJ; JJp2];
dptu3dp3 = u1;
v = [v; dptu3dp3];
II = [II; II3];
JJ = [JJ; JJp3];
% 4-6
dptu1dp5 = u2;
v = [v; dptu1dp5];
II = [II; II1];
JJ = [JJ; JJp5];
dptu2dp6 = u2;
v = [v; dptu2dp6];
II = [II; II2];
JJ = [JJ; JJp6];
dptu3dp7 = u2;
v = [v; dptu3dp7];
II = [II; II3];
JJ = [JJ; JJp7];
% 7-9
dptu1dp9 = u3;
v = [v; dptu1dp9];
II = [II; II1];
JJ = [JJ; JJp9];
dptu2dp10 = u3;
v = [v; dptu2dp10];
II = [II; II2];
JJ = [JJ; JJp10];
dptu3dp11 = u3;
v = [v; dptu3dp11];
II = [II; II3];
JJ = [JJ; JJp11];
% 10-12
dptu1dp13 = u4;
v = [v; dptu1dp13];
II = [II; II1];
JJ = [JJ; JJp13];
dptu2dp14 = u4;
v = [v; dptu2dp14];
II = [II; II2];
JJ = [JJ; JJp14];
dptu3dp15 = u4;
v = [v; dptu3dp15];
II = [II; II3];
JJ = [JJ; JJp15];

dptu1du1 = p1;
dptu2du1 = p2;
dptu3du1 = p3;
v = [v; dptu1du1];
II = [II; II1];
JJ = [JJ; JJU1];
v = [v; dptu2du1];
II = [II; II2];
JJ = [JJ; JJU1];
v = [v; dptu3du1];
II = [II; II3];
JJ = [JJ; JJU1];

dptu1du2 = p5;
dptu2du2 = p6;
dptu3du2 = p7;
v = [v; dptu1du2];
II = [II; II1];
JJ = [JJ; JJU2];
v = [v; dptu2du2];
II = [II; II2];
JJ = [JJ; JJU2];
v = [v; dptu3du2];
II = [II; II3];
JJ = [JJ; JJU2];

dptu1du3 = p9;
dptu2du3 = p10;
dptu3du3 = p11;
v = [v; dptu1du3];
II = [II; II1];
JJ = [JJ; JJU3];
v = [v; dptu2du3];
II = [II; II2];
JJ = [JJ; JJU3];
v = [v; dptu3du3];
II = [II; II3];
JJ = [JJ; JJU3];

jac = sparse(II,JJ,v,jac_m,jac_n);

%keyboard;
res = data.bigR*res;
jac = data.bigR*jac;

%figure(1); spy(jac);
