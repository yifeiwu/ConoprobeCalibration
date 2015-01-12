function A = mq(q)
% MQ Rotation matrix from quaternion.
%   A = MQ(Q) returns the 3x3 rotation matrix defined by the
%   quaternion Q.  A is applied to column vectors.

A = ones(3,3);

A(1,1) = q(1)*q(1) + q(2)*q(2) - q(3)*q(3) - q(4)*q(4);
A(1,2) = 2*(q(2)*q(3) - q(1)*q(4));
A(1,3) = 2*(q(2)*q(4) + q(1)*q(3));

A(2,1) = 2*(q(2)*q(3) + q(1)*q(4));
A(2,2) = q(1)*q(1) + q(3)*q(3) - q(2)*q(2) - q(4)*q(4);
A(2,3) = 2*(q(3)*q(4) - q(1)*q(2));

A(3,1) = 2*(q(2)*q(4) - q(1)*q(3));
A(3,2) = 2*(q(3)*q(4) + q(1)*q(2));
A(3,3) = q(1)*q(1) + q(4)*q(4) - q(2)*q(2) - q(3)*q(3);

