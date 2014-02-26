%% Set up vars
n_checks = 6;
complete(1:n_checks) = false;
count = 1;

% Get the user's Matlab directory
matlab_dir = userpath;
matlab_dir = matlab_dir(1:end-1);

%% Add SDPT3 package to Matlab path
SDPT3_path = [matlab_dir filesep 'SDPT3-4.0'];
if exist(SDPT3_path,'dir') ~= 7
    % Try adding if ourselves
    warning('STARTUP:CheckPackages',...
        'Missing SDPT3 package.\nDownload and install from the web.\nSee README');
    complete(count) = false;
    count = count + 1;
else
    addpath(SDPT3_path);
    cur_dir = pwd;
    cd(SDPT3_path);
    startup
    cd(cur_dir);
    complete(count) = true;
    count = count + 1;
end

%% Add yalmip package to Matlab path
yalmip_path = [matlab_dir filesep 'yalmip'];
if exist(yalmip_path,'dir') ~= 7
    % Try adding if ourselves
    warning('STARTUP:CheckPackages',...
        'Missing yalmip package.\nDownload and install from the web.\nSee README');
    complete(count) = false;
    count = count + 1;
else
    yalmip_install();
    complete(count) = true;
    count = count + 1;
end

%% Add progressBar package to Matlab path
progressBar_path = [matlab_dir filesep 'progressBar'];
if exist(progressBar_path,'dir') ~= 7
    warning('STARTUP:CheckPackages',...
        'Missing progressBar package.\nDownload and install from MATLAB Central.\nSee README');
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    path(path,progressBar_path);
end

%% Add head-models package to Matlab path
if ispc
    head_models_path = 'C:\Users\Phil\My Projects\head-models';
else
    head_models_path = '/home/chrapkpk/Documents/projects/head-models';
end
if exist(head_models_path, 'dir') ~= 7
    warning('STARTUP:CheckPackages',...
            ['Missing head-models project.\n']);
    complete(count) = false;
    count = count + 1;
else
    addpath(head_models_path);
    complete(count) = true;
    count = count + 1;
end

%% Add aet package to Matlab path
aet_path = [matlab_dir filesep 'aet'];
if exist(aet_path,'dir') ~= 7
    warning('STARTUP:CheckPackages',...
        'Missing aet package.\nDownload and install from Phil'' BitBucket See README');
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    path(path,aet_path);
end

%% Add phasereset package to Matlab path
phasereset_path = [matlab_dir filesep 'phasereset'];
if exist(phasereset_path,'dir') ~= 7
    warning('STARTUP:CheckPackages',...
        'Missing cvx package.\nDownload and install from http://www.cs.bris.ac.uk/~rafal/phasereset/.\nSee README');
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    path(path,phasereset_path);
end

% %% Check for mosek (Optional at this point)
% mosek_try_install = false;
% mosek_packages = regexp(...
%     path, ['mosek' filesep '7' filesep 'toolbox' filesep], 'match');
% if isempty(mosek_packages)
%     mosek_try_install = true;
% else
%     mosek_fail = false;
% end
% 
% if mosek_try_install
%     % Package is not installed, check if we can install it
%     mosek_path = [matlab_dir filesep 'mosek'];
%     mosek_script = [mosek_path filesep 'mosek_install.m'];
%     if exist(mosek_script,'file') ~= 0
%         % Save the current directory
%         cur_dir = pwd;
%         % Switch to the cvx dir
%         cd(mosek_path)
%         
%         eval('mosek_install');
%         
%         % Switch back to the directory
%         cd(cur_dir)
%         
%         % Check the installation
%         mosek_packages = regexp(...
%             path, ['mosek' filesep '7' filesep 'toolbox' filesep], 'match');
%         if isempty(mosek_packages)
%             mosek_fail = true;
%         else
%             mosek_fail = false;
%         end
%     else
%         % No mosek_install script
%         mosek_fail = true;
%     end
% end
% 
% if mosek_fail
%     warning('STARTUP:CheckPackages',...
%         'Missing mosek package. It''s optional');
%     complete(count) = true;
%     count = count + 1;
% else
%     complete(count) = true;
%     count = count + 1;
% end

%% Check for cvx
cvx_fail = true;
cvx_install = false;
cvx_packages = regexp(path, ['cvx' pathsep], 'match');
if isempty(cvx_packages)
    cvx_install = true;
else
    cvx_fail = false;
end

if cvx_install
    % Package is not installed, check if we can install it
    cvx_path = [matlab_dir filesep 'cvx'];
    if exist(cvx_path,'dir') ~= 7
        % Can't find the directory
        cvx_fail = true;
    else
        % Save the current directory
        cur_dir = pwd;
        % Switch to the cvx dir
        cd(cvx_path)
        % Check if there is a license file
        % And run cvx_setup
        if exist('cvx_license.dat','file') ~= 0
            eval('cvx_setup cvx_license.dat');
        else
            eval('cvx_setup');
        end
        % Switch back to the directory
        cd(cur_dir)
        
        % Check the installation
        cvx_packages = regexp(path, ['cvx' pathsep], 'match');
        if isempty(cvx_packages)
            cvx_fail = true;
        else
            cvx_fail = false;
        end
    end
end

if cvx_fail
    warning('STARTUP:CheckPackages',...
        'Missing cvx package.\nDownload and install from http://cvxr.com/.\nSee README');
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
end


%% Display message
if sum(complete) == length(complete)
    disp('Project: robust-eeg-beamforming-paper')
    disp('Initialized')
else
    disp('Project: robust-eeg-beamforming-paper')
    disp('Not Initialized')
end

clear all;