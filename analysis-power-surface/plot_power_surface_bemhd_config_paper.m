function plot_power_surface_bemhd_config_paper(sim_file,source_name,varargin)

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
k = 1;

for i=1:length(p.Results.PlotGroups)
    params(i) = get_plot_group(p.Results.PlotGroups{i}, p.Results.datatag);
end

%% Set vars
eval(sim_file);
samples_avg{1} = 1:sim_cfg.timepoints;
clear sim_cfg;

% switch p.Results.config
%     case 'mult-paper'
        source_args = {'source_idx',5440,'int_idx',13841};
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
        
        plot_power_surface(...
            data_set,...
            params(i).beamformer_configs,...
            sample,...
            source_args{:},...
            'force',force...
            );
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
        
        plot_power_surface(...
            data_set,...
            params(i).beamformer_configs,...
            sample,...
            source_args{:},...
            'force',force...
            );
    end
end

end