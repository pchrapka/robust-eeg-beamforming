function tol_new = check_pinv(A,ncomps)
%
%   A (matrix)
%       matrix for pseudo inverse
%   ncomps (integer)
%       expected components


tol_new = [];
pinv_tol = max(size(A)) * norm(A) * eps(class(A));
d = svd(A);

evalues = abs(d) >= pinv_tol;
nevalues = sum(evalues);

if ~isequal(nevalues,ncomps)
    %warning('number of eigenvalues: %d\nnumber of components: %d\n',nevalues,ncomps);
    %disp(evalues);
    warning('adjusting pinv tolerance');
    % calculate new tolerance
    tol_new = ceil(d(ncomps+1)/pinv_tol)*pinv_tol;
end

end