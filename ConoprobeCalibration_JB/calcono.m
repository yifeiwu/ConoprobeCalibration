% Author: Jessica Burgner, jessica.burgner@vanderbilt.edu
% Vanderbilt University, 2011
%---------------------------------------------------------------------
function [o, d] = calcono(poses, distances, point)
    N = length(poses);
    l = zeros(4,N);
    q = zeros(4,N);
    
    for a = 1:N
        l(1:3,a) = distances(a) * [0 0 -1]';
        % convert poses to affine matrices
        q(:,a) = inv(amq(poses(a,:))) * [point; 1];
    end
    meanq = mean(q,2);
    meand = mean(distances);
    
    qtilde = zeros(4,N);
    dtilde = zeros(1,N);
    qdtildesum = zeros(4,1);
    for a=1:N
        qtilde(:,a) = q(:,a) - meanq;
        dtilde(:,a) = distances(a) - meand;
        qdtildesum = qdtildesum + dtilde(:,a)*qtilde(:,a);
    end
    d = qdtildesum/norm(qdtildesum);
    o = meanq - meand*d;
    d(4)=[];
    o(4) =[];
end