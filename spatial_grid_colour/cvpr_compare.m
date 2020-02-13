function dst=cvpr_compare(F1, F2, p)

% Function to compare the distance between two descriptors
%% Input params:
% F1:       First feature vector
% F2:       Second feature vector
% p:        Distance metric to be used
% p = 1:    Manhattan distance (L1-norm)
% p = 2:    Euclidean distance (L2-norm)
% p = 3:    Cosine similarity
%% Output:
% dst:      Distance between F1 and F2

if (p == 1)
    x = sum(abs(F1-F2));
    dst = x;
    
elseif (p == 2)
    x = F1-F2;
    x = x.^2;
    x = sum(x);
    dst=sqrt(x);
    
elseif (p == 3)
    %dst = getCosineSimilarity(F1, F2);
    % 1 - pdist([F1;F2],'cosine')
    F1 = F1;
    F2 = F2;
    dotprod = dot(F1, F2);
    norm_f1 = sqrt(dot(F1, F1));
    norm_f2 = sqrt(dot(F2, F2));
    tmp = (norm_f1.*norm_f2);
    dst = dotprod./tmp;

end

return;
