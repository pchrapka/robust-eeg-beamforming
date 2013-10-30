%% analysis_ft_brain_plot.m

%% Select data
cfg.file_in = ['..' filesep 'output' filesep ...
    'out_sim_vars_3_lcmv.mat'];
cfg.iteration = 1;
cfg.snr = 10;
cfg.epsilon = ones(3,1)*sqrt(80^2/3);
cfg = analysis_param_sweep_select_data(cfg);

%% Load the EEG data
% NOTE At this point we should have filtered down to a single data set
data_file = ['..' filesep cfg.out(1).data_file];
% Replace slashes just in case
data_file = strrep(data_file, '/', filesep);
load(data_file);    % loads variable data

%% Convert to FieldTrip format

n_points = 1000;
n_channels = size(data.avg_trials,1);
fsample = 250;

raw.trial{1} = data.avg_trials;
raw.time{1} = 0:1/fsample:(n_points-1)/fsample;
raw.fsample = fsample;
raw.label = cell(1,n_channels);
for i=1:n_channels
    raw.label{1,i} = num2str(i);
end

raw.cfg.ntrials = 1;

%% Time lock analysis
timelock = ft_timelockanalysis([], raw);
% plot(avg1.time, avg1.avg);

%% Source analysis
cfg             = [];
cfg.reducerank  = 3;
cfg.method      = 'lcmv';
cfg.hdmfile     = 'SubjectCMC.hdm';
% cfg.grid.pos    = maxpos;
cfg.grid.filter = 
cfg.grid.leadfield = 
cfg.keepfilter  = 'yes';
source          = ft_sourceanalysis(cfg, timelock);