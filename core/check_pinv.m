function check_pinv(A,ncomps)
%
%   A (matrix)
%       matrix for pseudo inverse
%   ncomps (integer)
%       expected components

pinv_tol = max(size(A)) * norm(A) * eps(class(A));
d = svd(pinv(A));

evalues = abs(d) >= pinv_tol;
nevalues = sum(evalues);

if ~isequal(nevalues,ncomps)
    fprintf('number of eigenvalues: %d\nnumber of components: %d\n',nevalues,ncomps);
    disp(evalues);
    error(['number of evalues does not correspond with',...
        'the expected number of components. consider adjusting pinv tolerance.']);
end

end