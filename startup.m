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
    % Turn on warnings
    warning('on','all')
    warning('reb:startup',...
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
    fprintf('\tSDPT3: ok\n');
end

%% Add yalmip package to Matlab path
yalmip_path = [matlab_dir filesep 'yalmip'];
if exist(yalmip_path,'dir') ~= 7
    % Turn on warnings
    warning('on','all')
    warning('reb:startup',...
        'Missing yalmip package.\nDownload and install from the web.\nSee README');
    complete(count) = false;
    count = count + 1;
else
    addpath(yalmip_path);
    addpath(fullfile(yalmip_path, 'extras'));
    addpath(fullfile(yalmip_path, 'demos'));
    addpath(fullfile(yalmip_path, 'solvers'));
    addpath(fullfile(yalmip_path, 'modules'));
    addpath(fullfile(yalmip_path, 'modules/parametric'));
    addpath(fullfile(yalmip_path, 'modules/moment'));
    addpath(fullfile(yalmip_path, 'modules/global'));
    addpath(fullfile(yalmip_path, 'modules/sos'));
    addpath(fullfile(yalmip_path, 'operators'));
    complete(count) = true;
    count = count + 1;
    fprintf('\tyalmip: ok\n');
end

%% Add head-models package to Matlab path
if ispc
    head_models_path = 'C:\Users\Phil\My Projects\head-models';
else
    [~,comp_name] = system('hostname');
    if ~isempty(strfind(comp_name,'Valentina'))
        head_models_path = '/home/phil/projects/head-models';
    else
        head_models_path = '/home/chrapkpk/Documents/projects/head-models';
    end
end
if exist(head_models_path, 'dir') ~= 7
    warning('on','all')
    warning('reb:startup',...
            ['Missing head-models project.\n']);
    complete(count) = false;
    count = count + 1;
else
    addpath(head_models_path);
    complete(count) = true;
    count = count + 1;
    fprintf('\thead-models: ok\n');
end

%% Add aet package to Matlab path
aet_path = [matlab_dir filesep 'aet'];
if exist(aet_path,'dir') ~= 7
    try
        % Try installing
        util.update_aet();
    catch e
    end
end    
if exist(aet_path,'dir') ~= 7
    % Turn on warnings
    warning('on','all')
    warning('reb:startup',...
        'Missing aet package.\nDownload and install from Phil'' BitBucket See README');
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    path(path,aet_path);
    fprintf('\taet: ok\n');
end

%% Add phasereset package to Matlab path
phasereset_path = [matlab_dir filesep 'phasereset'];
if exist(phasereset_path,'dir') ~= 7
    % Turn on warnings
    warning('on','all')
    warning('reb:startup',...
        ['Missing phasereset package.\n'...
        'Download and install from http://www.cs.bris.ac.uk/~rafal/phasereset/.\n'...
        'See README']);
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    path(path,phasereset_path);
    fprintf('\tphasereset: ok\n');
end

%% Add lumberjack package to Matlab path
pkg_name = 'lumberjack';
if ispc
    dep_path = ['C:\Users\Phil\My Projects\' pkg_name];
else
    [~,comp_name] = system('hostname');
    if ~isempty(strfind(comp_name,'Valentina'))
        dep_path = ['/home/phil/projects/' pkg_name];
    else
        dep_path = ['/home/chrapkpk/Documents/MATLAB/' pkg_name];
    end
end
if exist(dep_path,'dir') ~= 7
    % Turn on warnings
    warning('on','all')
    warning('reb:startup',...
        ['Missing %s package.\n'...
        'Clone from https://github.com/pchrapka/%s.git.\n'...
        'See README'], pkg_name, pkg_name);
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    path(path,dep_path);
    fprintf('\t%s: ok\n', pkg_name);
end

%% Add fieldtrip-beamforming-rmvb package to Matlab path
pkg_name = 'fieldtrip-beamforming-rmvb';
if ispc
    dep_path = ['C:\Users\Phil\My Projects\' pkg_name];
else
    [~,comp_name] = system('hostname');
    if ~isempty(strfind(comp_name,'Valentina'))
        dep_path = ['/home/phil/projects/' pkg_name];
    else
        dep_path = ['/home/chrapkpk/Documents/MATLAB/' pkg_name];
    end
end
if exist(dep_path,'dir') ~= 7
    % Turn on warnings
    warning('on','all')
    warning('reb:startup',...
        ['Missing %s package.\n'...
        'Clone from https://github.com/pchrapka/%s.git.\n'...
        'See README'], pkg_name, pkg_name);
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    path(path,dep_path);
    fb_install
    fprintf('\t%s: ok\n', pkg_name);
end

%% Add export_fig package to Matlab path
exportfig_path = [matlab_dir filesep 'export_fig'];
if exist(exportfig_path,'dir') ~= 7
    % Turn on warnings
    warning('on','all')
    warning('reb:startup',...
        ['Missing export_fig package.\n'...
        'Clone from https://github.com/ojwoodford/export_fig.git.\n'...
        'See README']);
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    path(path,exportfig_path);
    fprintf('\texport_fig: ok\n');
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
%     warning('reb:startup',...
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
            cvx_startup
            cvx_setup 'cvx_license.dat'
        else
            cvx_startup
            cvx_setup
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
    % Turn on warnings
    warning('on','all')
    warning('reb:startup',...
        'Missing cvx package.\nDownload and install from http://cvxr.com/.\nSee README');
    complete(count) = false;
    count = count + 1;
else
    complete(count) = true;
    count = count + 1;
    fprintf('\tcvx: ok\n');
end

%% Add the project directories to the path
[project_dir,~,~,~] = util.fileparts(mfilename('fullpath'));
addpath(project_dir);
addpath(fullfile(project_dir, 'core'));
addpath(fullfile(project_dir, 'experiments'));
addpath(fullfile(project_dir, 'plotting'));
addpath(fullfile(project_dir, 'analysis-beampattern'));
addpath(fullfile(project_dir, 'analysis-beampattern-fieldtrip'));
addpath(fullfile(project_dir, 'analysis-correlation'));
addpath(fullfile(project_dir, 'analysis-dipole'));
addpath(fullfile(project_dir, 'analysis-mag-dist'));
addpath(fullfile(project_dir, 'analysis-metrics'));
addpath(fullfile(project_dir, 'analysis-power'));
addpath(fullfile(project_dir, 'analysis-raw'));
addpath(fullfile(project_dir, 'analysis-rmse'));
addpath(fullfile(project_dir, 'simulation-configs'));
addpath(fullfile(project_dir, 'simulations'));
addpath(fullfile(project_dir, 'source-configs'));


%% Display message
if sum(complete) == length(complete)
    disp('Project: robust-eeg-beamforming-paper')
    disp('Initialized')
else
    disp('Project: robust-eeg-beamforming-paper')
    disp('Not Initialized')
    disp(['If there are missing packages,',...
        'run install_deps.sh (tested on linux). And rerun startup.m']);
end

%clear all;