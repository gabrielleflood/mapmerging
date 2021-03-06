function R = quat2rot(q)
%QUAT2ROT Summary of this function goes here
%   Detailed explanation goes here

qr = q(1);
qi = q(2);
qj = q(3);
qk = q(4);

R = [1-2*(qj^2 + qk^2), 2*(qi*qj - qk*qr), 2*(qi*qk + qj*qr);
    2*(qi*qj+qk*qr), 1-2*(qi^2 + qk^2), 2*(qj*qk - qi*qr);
    2*(qi*qk-qj*qr), 2*(qj*qk + qi*qr), 1-2*(qi^2 + qj^2)];

end

