function plot_beampattern_multhd_config_paper(sim_file,source_name,varargin)


p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'PlotGroups',{'matched-beampattern','mismatched-beampattern'},@iscell);
addParameter(p,'datatag','locs2_covtime',@ischar);
addParameter(p,'snr',0,@isnumeric);
parse(p,sim_file,source_name,varargin{:});

%% Set up beamformer configs
params = [];

for i=1:length(p.Results.PlotGroups)
    if isempty(params)
        params = get_plot_group(p.Results.PlotGroups{i}, p.Results.datatag);
    else
        params(i) = get_plot_group(p.Results.PlotGroups{i}, p.Results.datatag);
    end
end


%% Run through params
for i=1:length(params)
    
    source_idx = 5440;
    int_idx = 13841;
    
    % Set up simulation info
    data_set = SimDataSetEEG(...
        sim_file,...
        source_name,...
        p.Results.snr,...
        'iter',1);
    
    %% Compute beampatterns
    
    % Compute the beampattern
    outputfiles = compute_beampattern(...
        data_set,...
        params(i).beamformer_configs,...
        source_idx,...
        'int_idx',int_idx);
    
    %% Plot data
    
    scales = {...
        'relative',...
        'relative-dist',...
        ...'mad',...
        'globalabsolute'...
        'globalabsolute-dist'...
        };
    
%     for j=1:length(scales)
%         args = get_view_beampattern_args('default','beampattern',scales{j});
%         view_beampattern(outputfiles,'source_idx',source_idx,args{:});
%     end
    
    for j=1:length(scales)
        args = get_view_beampattern_args('default','beampattern3d',scales{j});
        view_beampattern(outputfiles,'source_idx',source_idx,'int_idx',int_idx,args{:});
    end
    
    params(i).outputfiles = outputfiles;
    
end

end

