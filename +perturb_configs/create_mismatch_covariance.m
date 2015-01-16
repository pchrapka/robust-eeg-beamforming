function Cx = create_mismatch_covariance(n_channels, epsilon)

% a = rand(n_channels, n_channels);
% ata = a'*a;
% Cx = ata/norm(ata,'fro');

variance = epsilon^2/(3*n_channels);
Cx = variance*eye(n_channels);

% save(file_name, 'Cx');

end