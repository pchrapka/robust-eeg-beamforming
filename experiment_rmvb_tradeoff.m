%% Get the data
% Set up config to get the data file
snr = '0';

cfg = [];
cfg.beam_cfgs = {...
    'lcmv_3sphere',...
    'lcmv_eig_0_3sphere',...
    'rmv_aniso_3sphere'};
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'single_cort_src_1';
cfg.source_config = 'src_param_single_cortical_source_1';
cfg.snr = snr;
cfg.iteration = 1;

bf_data = cell(size(cfg.beam_cfgs));
for i=1:length(cfg.beam_cfgs)
    cfg.tag = [cfg.beam_cfgs{i} '_mini'];
    
    % Get the file name
    file_name = db.get_full_file_name(cfg);
    % Add extension
    file_name = strcat(file_name, '.mat');
    
    % Load the beamformer data
    data_in = load(file_name);
    bf_data{i}.name = cfg.beam_cfgs{i};
    bf_data{i}.bf_out = data_in.source.beamformer_output;
end

%% Get configs
% Load config parameters
clear sim_cfg;
eval(cfg.sim_name);
eval(cfg.source_config);

%% Figure out the dipole orientation
% Choose a source index to plot
idx = 295;
component_labels = {'x','y','z'};
for i=1:length(bf_data)
    figure;
    n_comp = size(bf_data{i}.bf_out,1);
    for j=1:n_comp
        % Plot each component separately
        subplot(n_comp,1,j);
        data = squeeze(bf_data{i}.bf_out(j,idx,:));
        plot(data);
        if j==1
            % Add the title to the first plot
            title(strrep(bf_data{i}.name,'_',' '));
        end
        % Add component labels
        ylabel([component_labels{j} ' comp']);
    end
end