function analysis_param_sweep_plot_gain(cfg)
%ANALYSIS_PARAM_SWEEP_PLOT_GAIN
%   ANALYSIS_PARAM_SWEEP_PLOT_GAIN(CFG)
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
        warning('reb:analysis_param_sweep_plot_gain',...
            'This function can''t handle multiple snr values');
    end
        
    % Get unique iterations
    iterations = unique([out.iteration]);
    locations = unique([out.loc]);
    for j=1:length(iterations)
        % Select the current iteration
        idx = find([out.iteration] == iterations(j));
        out_temp = out(idx);
        
        % Select one epsilon
        if isfield(out_temp(1),'epsilon')
            epsilons = unique([out.epsilon]','rows');
            idx = find(...
                cellfun(@(x)isequal(x, epsilons(1,:)'),{out_temp.epsilon}));
            out_temp = out_temp(idx);
        end
       
        % Make sure this matches
        if length(locations) ~= length(out_temp)
            warning('reb:analysis_param_sweep_plot_gain',...
                'Dealbreaker');
        end
        
        % Extract data
        for k=1:length(out_temp)
            data(i).y(k,j) = norm(out_temp(k).W'*out_temp(k).H);
            coords = aet_bst_get_grid_coord(...
                cfg.sim_cfg.head, out_temp(k).loc);
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

%% Save the figure to a file
file_name = ['output' filesep cfg.file_out];
out_file_name = [file_name '.eps'];
saveas(gcf, out_file_name,'epsc2');
fixPSlinestyle(out_file_name);

out_file_name = [file_name '.png'];
saveas(gcf, out_file_name);
end
