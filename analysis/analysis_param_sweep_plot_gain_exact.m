function analysis_param_sweep_plot_gain_exact(cfg)
%ANALYSIS_PARAM_SWEEP_PLOT_GAIN_EXACT
%   ANALYSIS_PARAM_SWEEP_PLOT_GAIN_EXACT(CFG) plots the gain of the filter
%   for an exactly matched leadfield matrix
%
%   Input
%   file_in     cell array of input files
%   file_out    name for output file
%   sim_cfg     simulation configuration used for data

% Allocate memory
data(length(cfg.file_in)).x_label = 'Distance from source';

% Get the source location
source_loc = cfg.loc;
fprintf('Using location idx: %d\n', source_loc);
source_coords = aet_bst_get_grid_coord(...
    cfg.sim_cfg.head, source_loc);

%% Extract data from each file
for i=1:length(cfg.file_in)
    
    % Load the file
    load(cfg.file_in{i});
    
    % Make sure that there is only one SNR value
    snr = unique([out.snr]);
    if length(snr) > 1
        warning('reb:analysis_param_sweep_plot_gain_exact',...
            'This function can''t handle multiple snr values');
    end
    
    % Select the data for the source location
    out = out([out.loc] == source_loc);
        
    % Get unique iterations
    iterations = unique([out.iteration]);
    for j=1:length(iterations)
        % Select the current iteration
        out_temp = out([out.iteration] == iterations(j));
        
        % Select one epsilon
        if isfield(out_temp(1),'epsilon')
            epsilons = unique([out_temp.epsilon]','rows');
            out_temp = out_temp(...
                cellfun(@(x)isequal(x, epsilons(1,:)'),{out_temp.epsilon}));
        end
        
        % Calculate data for each location in head model
        n_locs = size(cfg.sim_cfg.head.GridLoc,1);
        W = out_temp(1).W;
        for k=1:n_locs
            H = aet_source_get_gain(...
                k, cfg.sim_cfg.head);
            data(i).y(k,j) = norm(W'*H);
            coords = aet_bst_get_grid_coord(...
                cfg.sim_cfg.head, k);
            locs = [source_coords; coords];
            data(i).x(k,j) = pdist(locs,'euclidean');
        end
    end
    
    data(i).sort = true;
    data(i).name = out(1).beamformer_type;
    data(i).xlabel = 'Distance from source';
    data(i).ylabel = '||W^{T}H||';
end

%% Plot the data
figure;
plot_series(data);
title('Beampattern for exact leadfield matrix');

%% Save the figure to a file
file_name = ['output' filesep cfg.file_out];
out_file_name = [file_name '.eps'];
saveas(gcf, out_file_name,'epsc2');
fixPSlinestyle(out_file_name);

out_file_name = [file_name '.png'];
saveas(gcf, out_file_name);
end
