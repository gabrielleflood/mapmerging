function [res,jac]=calcres2(sol,data);

m = size(sol.pv,2); % nr of images
n = size(sol.U,2);  % nr of 3D points
jac_m = size(data.u,2)*2; % nr of image points * 2, i e nr of residuals, i e nr of rows of jac
jac_n = 12*m+3*n;        % nr of unknown variables, i e nr of columns of jac

p1 = sol.pv(1,data.I)';
p2 = sol.pv(2,data.I)';
p3 = sol.pv(3,data.I)';
p4 = sol.pv(4,data.I)';
p5 = sol.pv(5,data.I)';
p6 = sol.pv(6,data.I)';
p7 = sol.pv(7,data.I)';
p8 = sol.pv(8,data.I)';
p9 = sol.pv(9,data.I)';
p10 = sol.pv(10,data.I)';
p11 = sol.pv(11,data.I)';
p12 = sol.pv(12,data.I)';

u1 = sol.U(1,data.J)';
u2 = sol.U(2,data.J)';
u3 = sol.U(3,data.J)';
u4 = sol.U(4,data.J)';

ptu1 = p1.*u1 + p4.*u2 + p7.*u3 + p10.*u4;
ptu2 = p2.*u1 + p5.*u2 + p8.*u3 + p11.*u4;
ptu3 = p3.*u1 + p6.*u2 + p9.*u3 + p12.*u4;

res1 = ptu1./ptu3 - data.u(1,:)';
res2 = ptu2./ptu3 - data.u(2,:)';

res = [res1;res2];
res = res(:);

II1 = (1:length(res1))';
II2 = II1+length(res1);

JJp1 = (data.I-1)*12+1;
JJp2 = (data.I-1)*12+2;
JJp3 = (data.I-1)*12+3;
JJp4 = (data.I-1)*12+4;
JJp5 = (data.I-1)*12+5;
JJp6 = (data.I-1)*12+6;
JJp7 = (data.I-1)*12+7;
JJp8 = (data.I-1)*12+8;
JJp9 = (data.I-1)*12+9;
JJp10 = (data.I-1)*12+10;
JJp11 = (data.I-1)*12+11;
JJp12 = (data.I-1)*12+12;

JJU1 = 12*m + (data.J-1)*3+1;
JJU2 = 12*m + (data.J-1)*3+2;
JJU3 = 12*m + (data.J-1)*3+3;

%
II = [];
JJ = [];
v = [];
% 1-3
dptu1dp1 = u1;
v = [v; dptu1dp1./ptu3];
II = [II; II1];
JJ = [JJ; JJp1];
dptu2dp2 = u1;
v = [v; dptu2dp2./ptu3];
II = [II; II2];
JJ = [JJ; JJp2];
dptu3dp3 = u1;
v = [v; -ptu1.*dptu3dp3./(ptu3.^2)];
II = [II; II1];
JJ = [JJ; JJp3];
v = [v; -ptu2.*dptu3dp3./(ptu3.^2)];
II = [II; II2];
JJ = [JJ; JJp3];
% 4-6
dptu1dp4 = u2;
v = [v; dptu1dp4./ptu3];
II = [II; II1];
JJ = [JJ; JJp4];
dptu2dp5 = u2;
v = [v; dptu2dp5./ptu3];
II = [II; II2];
JJ = [JJ; JJp5];
dptu3dp6 = u2;
v = [v; -ptu1.*dptu3dp6./(ptu3.^2)];
II = [II; II1];
JJ = [JJ; JJp6];
v = [v; -ptu2.*dptu3dp6./(ptu3.^2)];
II = [II; II2];
JJ = [JJ; JJp6];
% 7-9
dptu1dp7 = u3;
v = [v; dptu1dp7./ptu3];
II = [II; II1];
JJ = [JJ; JJp7];
dptu2dp8 = u3;
v = [v; dptu2dp8./ptu3];
II = [II; II2];
JJ = [JJ; JJp8];
dptu3dp9 = u3;
v = [v; -ptu1.*dptu3dp9./(ptu3.^2)];
II = [II; II1];
JJ = [JJ; JJp9];
v = [v; -ptu2.*dptu3dp9./(ptu3.^2)];
II = [II; II2];
JJ = [JJ; JJp9];
% 10-12
dptu1dp10 = u4;
v = [v; dptu1dp10./ptu3];
II = [II; II1];
JJ = [JJ; JJp10];
dptu2dp11 = u4;
v = [v; dptu2dp11./ptu3];
II = [II; II2];
JJ = [JJ; JJp11];
dptu3dp12 = u4;
v = [v; -ptu1.*dptu3dp12./(ptu3.^2)];
II = [II; II1];
JJ = [JJ; JJp12];
v = [v; -ptu2.*dptu3dp12./(ptu3.^2)];
II = [II; II2];
JJ = [JJ; JJp12];

dptu1du1 = p1;
dptu2du1 = p2;
dptu3du1 = p3;
v = [v; dptu1du1./ptu3 - ptu1.*dptu3du1./(ptu3.^2)];
II = [II; II1];
JJ = [JJ; JJU1];
v = [v; dptu2du1./ptu3 - ptu2.*dptu3du1./(ptu3.^2)];
II = [II; II2];
JJ = [JJ; JJU1];

dptu1du2 = p4;
dptu2du2 = p5;
dptu3du2 = p6;
v = [v; dptu1du2./ptu3 - ptu1.*dptu3du2./(ptu3.^2)];
II = [II; II1];
JJ = [JJ; JJU2];
v = [v; dptu2du2./ptu3 - ptu2.*dptu3du2./(ptu3.^2)];
II = [II; II2];
JJ = [JJ; JJU2];

dptu1du3 = p7;
dptu2du3 = p8;
dptu3du3 = p9;
v = [v; dptu1du3./ptu3 - ptu1.*dptu3du3./(ptu3.^2)];
II = [II; II1];
JJ = [JJ; JJU3];
v = [v; dptu2du3./ptu3 - ptu2.*dptu3du3./(ptu3.^2)];
II = [II; II2];
JJ = [JJ; JJU3];


jac = sparse(II,JJ,v,jac_m,jac_n);

%figure(1); spy(jac);
