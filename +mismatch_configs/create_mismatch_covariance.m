function Cx = create_mismatch_covariance(n_channels, file_name)

a = rand(n_channels, n_channels);
ata = a'*a;
Cx = ata/norm(ata,'fro');

save(file_name, 'Cx');

end