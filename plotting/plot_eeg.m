function plot_eeg(sim_file,source_name,snr,varargin)

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addRequired(p,'snr',@isnumeric);
options_mode = {'avg_trials','trials'};
addParameter(p,'mode','avg_trials',@(x) any(validatestring(x,options_mode)));
addParameter(p,'samples',[],@(x) isnumeric(x) && (length(x) == 2));
addParameter(p,'save',true,@islogical);
parse(p,sim_file,source_name,snr,varargin{:});

data_set = SimDataSetEEG(...
    sim_file,...
    source_name,...
    snr,...
    'iter',1);

% load eeg data
temp = load(data_set.get_full_filename);
eeg = temp.data;

% get info
nsamples = size(eeg.trials{1},2);
fs = 250;
warning('using fs=250Hz, fix data generation to save fs');
taxis = (0:nsamples-1)/fs*1000;

if isempty(p.Results.samples)
    sample_idx = 1:nsamples;
else
    sample_idx = p.Results.samples(1):p.Results.samples(2);
end

% plot
taxis_plot = taxis(sample_idx);
h = figure('DefaultAxesFontSize',14);
switch p.Results.mode
    case 'avg_trials'
        plot(taxis_plot,eeg.avg_trials(:,sample_idx));
    case 'trials'
        plot(taxis_plot,eeg.trials{1}(:,sample_idx));
end
xlim([taxis_plot(1) taxis_plot(end)]);
xlabel('Time (ms)');
ylabel('EEG');

% Save the figure
if p.Results.save
    cfg_save = [];
    % Get the data file name
    cfg = [];
    cfg.data_set = data_set;
    cfg.file_tag = sprintf('eeg-s%d-%d',sample_idx(1),sample_idx(end));
    cfg.file_type = 'img';
    data_file = metrics.filename(cfg);
    % Get the data file dir
    [cfg_save.out_dir,cfg_save.file_name,~] = fileparts(data_file);
    
    fprintf('Saving figure: %s\n', cfg_save.file_name);
    % Set the background to white
    set(gcf, 'Color', 'w');
    lumberjack.save_figure(cfg_save);
    close(h);
end
end