close all;

aet_init();

%% Get the data
% Set up config to get the data file
snr = '0';
force = false;
% mismatch = true;
mismatch = false;

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

%% Load original data
cfg_data.tag = [];
data_file_name = [db.get_full_file_name(cfg_data) '.mat'];

% Signal types
signal_types = {...
    'signal',...
    'interference',...
    'noise',...
    };

for j=1:length(signal_types)
    signal_type = signal_types{j};
    for i=1:length(cfg_data.beam_cfgs)
        % Load the data
        cfg_data.tag = [cfg_data.beam_cfgs{i} '_power.mat'];
        file_name = db.get_full_file_name(cfg_data);
        din = load(file_name);
        
        switch signal_type
            case 'signal'
                data = din.data.bf_out.signal.power;
                n_locs = size(din.data.bf_out.signal.power,1);
            case 'interference'
                data = din.data.bf_out.int.power;
                n_locs = size(din.data.bf_out.int.power,1);
            case 'noise'
                data = din.data.bf_out.noise.power;
                n_locs = size(din.data.bf_out.noise.power,1);
            otherwise
                error(['rmvb:' mfilename],...
                    'unknown signal type');
        end
        
        cfg = [];
        if mismatch
            cfg.condition_name = [cfg_data.sim_name '_' cfg_data.source_name...
                '_3sphere_power_' signal_type];
        else
            cfg.condition_name = [cfg_data.sim_name '_' cfg_data.source_name...
                '_power_' signal_type];
        end
        cfg.import = true;
        cfg.eeg_data_file = data_file_name;
        cfg.data = zeros(3, n_locs, 1);
        cfg.data(1,:,1) = data;
        cfg.data_tag = cfg_data.beam_cfgs{i} ;
        cfg.plot = false;
        brainstorm.bstcust_plot_surface(cfg);
    end
end

%% Close all plots
% brainstorm.bstcust_plot_close();