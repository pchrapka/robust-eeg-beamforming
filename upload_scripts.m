%% Upload Script
% Uploads .m files to blade16 comp

%% Connect to blade16
host = 'blade16';
username = 'chrapkpk';
password = logindlg('Title','Login Title','Password','only');
ssh2_conn = ssh2_config(host,username,password);

%% Find .m files in current directory
file_names = dir('*.m');

%% Upload files
ssh2_conn = sftp_put(...
    ssh2_conn,...
    {file_names.name},...
     'Documents/projects/robust-eeg-beamforming/');

%% Close the connection
ssh2_conn = ssh2_close(ssh2_conn);