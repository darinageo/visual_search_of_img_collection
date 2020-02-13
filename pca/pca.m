function [ FPCA, U, V ] = pca(obs)

E.org = mean(obs.')';
E.N = size(obs,2);
E.D = size(obs,1);

obs_translated=obs-repmat(E.org, 1, E.N);
C= (obs_translated * obs_translated') ./ E.N;

[U, V]=eig(C);

V(V==0) = [];
V = sort(V, 'descend');

total_energy = sum(abs(V))*0.95;
current_energy = 0;
for rank = 1:size(V,1)
    current_energy = sum(V(1:rank, 1));
    if (current_energy > total_energy) break;
    end
end

V = V(1:rank);
U = fliplr(U);
U = U(:, 1:rank);
FPCA = U'*obs_translated;
end
