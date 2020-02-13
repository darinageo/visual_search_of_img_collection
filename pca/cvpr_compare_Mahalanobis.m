function dst=cvpr_compare_Mahalanobis(F1, F2, p)

% Function to compare the distance between two descriptors using Mahalanobis distance
%% Input params:
% F1:       First feature vector
% F2:       Second feature vector
% p:      Eigenvalue of the dimension reduced feature matrix
%% Output:
% dst:      Distance between F1 and F2
x = F1 - F2;
x = x.^2/p;
x = sum(x);
dst = sqrt(x);

return;
