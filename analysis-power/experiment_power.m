% Prototype code to compare dipole mse
close all;

aet_init();

%% Get the data
% Set up config to get the data file
snr = '0';
force = false;
mismatch = false;
% mismatch = true;

cfg_data = [];
if ~mismatch
    cfg_data.beam_cfgs = {...
        ...Matched
        'rmv_epsilon_20',...
        'lcmv',...
        'lcmv_eig_1',...
        'lcmv_reg_eig',...
        };
else
    cfg_data.beam_cfgs = {...
        ...Mismatched
        'lcmv_3sphere',...
        'lcmv_eig_0_3sphere',...
        'lcmv_eig_1_3sphere',...
        'lcmv_reg_eig_3sphere',...
        'rmv_epsilon_100_3sphere',...
        'rmv_epsilon_150_3sphere',...
        'rmv_epsilon_200_3sphere',...
        'rmv_aniso_3sphere',...
        };
end
cfg_data.sim_name = 'sim_data_bem_1_100t';
% cfg_data.source_name = 'single_cort_src_1';
% cfg_data.source_config = 'src_param_single_cortical_source_1';
cfg_data.source_name = 'mult_cort_src_17';
cfg_data.source_config = 'src_param_mult_cortical_source_17';
cfg_data.snr = snr;
cfg_data.iteration = 1;


%% Calculate power of individual signal components
for i=1:length(cfg_data.beam_cfgs)
    
    % Calculate beamformer output
    fprintf('Calculating beamformer output for %s\n', cfg_data.beam_cfgs{i});
    cfg.beam_cfg = cfg_data.beam_cfgs{i};
    cfg.data_set = cfg_data;
    cfg.force = force;
    cfg = beamform_components(cfg);
    din = load(cfg.data_file);
    bf_out = din.data.bf_out;
    clear din;
    
    % Set up file name for power calculations
    cfg_data.tag = [cfg_data.beam_cfgs{i} '_power.mat'];
    file_name = db.get_full_file_name(cfg_data);
    if force || ~exist(file_name, 'file')
        fprintf('Calculating beamformer output power for %s\n', cfg_data.beam_cfgs{i});
        data = [];
        data.name = cfg_data.beam_cfgs{i};
        data.data_file = file_name;
        
        % Calculate the power at each location
        cfg_pow = [];
        % Signal
        cfg_pow.data = bf_out.signal.data;
        output = metrics.power(cfg_pow);
        data.bf_out.signal.power = output.power;
        
        % Interference
        cfg_pow.data = bf_out.interference.data;
        output = metrics.power(cfg_pow);
        data.bf_out.interference.power = output.power;
        
        % Noise
        cfg_pow.data = bf_out.noise.data;
        output = metrics.power(cfg_pow);
        data.bf_out.noise.power = output.power;
        
        % Save to a file
        save(file_name, 'data');
        
    end
end

% Calculate vertex distances from source
% Load the head model
head_cfg = [];
head_cfg.type = 'brainstorm';
head_cfg.file = 'head_Default1_bem_500V.mat';
data = hm_get_data(head_cfg);
head = data.head;

cfg_vert = [];
cfg_vert.head = head;
cfg_vert.voi_idx = 295;
cfg_vert.location_idx = 1:501;
vdist = metrics.vertex_distances(cfg_vert);

%% Plot power vs dist
close all;
set(0,'DefaultAxesColorOrder',hsv(length(cfg_data.beam_cfgs)));

% Signal
data_power = [];
legend_str = [];
for i=1:length(cfg_data.beam_cfgs)
    % Load the data
    cfg_data.tag = [cfg_data.beam_cfgs{i} '_power.mat'];
    file_name = db.get_full_file_name(cfg_data);
    din = load(file_name);
    
    legend_str{i} = cfg_data.beam_cfgs{i};
    
    % Combine power and distance
    data_power = [data_power din.data.bf_out.signal.power];
end

cfg_plot = [];
cfg_plot.legend_str = legend_str;
cfg_plot.power = data_power;
cfg_plot.distance = vdist.distance;
cfg_plot.title = 'Signal Power';
% plot_power_vs_distance(cfg_plot);
plot_power_vs_distance_subplots(cfg_plot);

% Interference
data_power = [];
legend_str = [];
for i=1:length(cfg_data.beam_cfgs)
    % Load the data
    cfg_data.tag = [cfg_data.beam_cfgs{i} '_power.mat'];
    file_name = db.get_full_file_name(cfg_data);
    din = load(file_name);
    
    legend_str{i} = cfg_data.beam_cfgs{i};
    
    % Combine power and distance
    data_power = [data_power din.data.bf_out.interference.power];
end

cfg_plot = [];
cfg_plot.legend_str = legend_str;
cfg_plot.power = data_power;
cfg_plot.distance = vdist.distance;
cfg_plot.title = 'Interference Power';
% plot_power_vs_distance(cfg_plot);
plot_power_vs_distance_subplots(cfg_plot);

% Noise
data_power = [];
legend_str = [];
for i=1:length(cfg_data.beam_cfgs)
    % Load the data
    cfg_data.tag = [cfg_data.beam_cfgs{i} '_power.mat'];
    file_name = db.get_full_file_name(cfg_data);
    din = load(file_name);
    
    legend_str{i} = cfg_data.beam_cfgs{i};
    
    % Combine power and distance
    data_power = [data_power din.data.bf_out.noise.power];
end

cfg_plot = [];
cfg_plot.legend_str = legend_str;
cfg_plot.power = data_power;
cfg_plot.distance = vdist.distance;
cfg_plot.title = 'Noise Power';
% plot_power_vs_distance(cfg_plot);
plot_power_vs_distance_subplots(cfg_plot);
