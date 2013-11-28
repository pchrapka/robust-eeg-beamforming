%% brainstorm_start
% Starts Brainstorm and returns to the current directory

% Save the current dir
cur_dir = pwd;
if ispc
    cd('C:\Users\Phil\Documents\MATLAB\brainstorm3');
elseif isunix
    cd('/home/chrapkpk/Documents/MATLAB/brainstorm3');
else
    error('reb:brainstorm_start',...
        'unknown os');
end

% Start brainstorm
brainstorm

% Go back to the current dir
cd(cur_dir);