function [V,D] = eig_sorted(A)
%EIG_SORTED returns sorted eigenvalues and eigenvectors from largest to
%smallest

% Decompose matrix
[V,D] = eig(A);

% Sort eigenvalues from largest to smallest
[~,permutation]=sort(diag(D),1,'descend');

% Reorder the eigenvalues
D = D(permutation,permutation);

% Reorder the eigenvectors
V = V(:,permutation);

end