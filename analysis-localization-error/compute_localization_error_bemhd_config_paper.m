function compute_localization_error_bemhd_config_paper(sim_file,source_name,varargin)

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'PlotGroups',{'matched-power','mismatched-power'},@iscell);
addParameter(p,'datatag','locsall_covtime',@ischar);
addParameter(p,'snr',0,@isnumeric);
parse(p,sim_file,source_name,varargin{:});

%% Compute power
force = false;
params = [];

for i=1:length(p.Results.PlotGroups)
    if isempty(params)
        params = get_plot_group(p.Results.PlotGroups{i}, p.Results.datatag);
    else
        params(i) = get_plot_group(p.Results.PlotGroups{i}, p.Results.datatag);
    end
end

%% Set vars
eval(sim_file);
samples_avg{1} = 1:sim_cfg.timepoints;
clear sim_cfg;

% TODO move samples out and as a parameter

% switch p.Results.config
%     case 'mult-paper'
        source_idx = 5440;
%         source_args = {'source_idx',5440,'int_idx',13841};
        samples = [120,160];
        samples_avg{2} = 110:170;
%     case 'single-paper'
%         source_args = {'source_idx',5440};
%         samples = 120;
%         samples_avg{2} = 110:130;
%     otherwise
%         error('unknown config');
% end

%% average power
for j=1:length(samples_avg)
    sample = samples_avg{j};
    for i=1:length(params)
        data_set = SimDataSetEEG(...
            sim_file,...
            source_name,...
            p.Results.snr,...
            'iter',1);
        
        % Compute the beamformer output power
        files_power = compute_power(...
            data_set, params(i).beamformer_configs,'force', force);
        
        % Compute localization error
        compute_localization_error(...
            data_set, params(i).beamformer_configs, files_power,...
            sample, source_idx, 'force', force, 'GroupName', p.Results.PlotGroups{i});
    end
end

%% instantaneous power
for j=1:length(samples)
    sample = samples(j);
    for i=1:length(params)
        data_set = SimDataSetEEG(...
            sim_file,...
            source_name,...
            p.Results.snr,...
            'iter',1);
        
        % Compute the beamformer output power
        files_power = compute_power(...
            data_set, params(i).beamformer_configs,'force', force);
        
        % Compute localization error
        compute_localization_error(...
            data_set, params(i).beamformer_configs, files_power,...
            sample, source_idx, 'force', force, 'GroupName', p.Results.PlotGroups{i});
    end
end

end