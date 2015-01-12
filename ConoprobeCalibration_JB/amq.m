function A = amq(q)
% AMQ Affine matrix from quaternion+translation.

A = [mq(q) q(5:7)'; 0 0 0 1];