function import_power(mismatch)

%% Get the data
% Set up config to get the data file
snr = '0';

if ~mismatch
    beam_cfgs = {...
        ...Matched
        'rmv_epsilon_20',...
        'lcmv',...
        'lcmv_eig_1',...
        'lcmv_reg_eig',...
        };
else
    beam_cfgs = {...
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

data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t',...
    'mult_cort_src_17',...
    snr,...
    'iter',1);

%% Load original data
tag = '';
data_file_name = [data_set.get_full_filename(tag) '.mat'];

% Signal types
signal_types = {...
    'signal',...
    'interference',...
    'noise',...
    'all',...
    };

for j=1:length(signal_types)
    signal_type = signal_types{j};
    for i=1:length(beam_cfgs)
        % Load the data
        tag = [beam_cfgs{i} '_power.mat'];
        file_name = data_set.get_full_filename(tag);
        din = load(file_name);
        
        % Load the power data
        switch signal_type
            case 'signal'
                data = din.data.bf_out.signal.power;
                n_locs = size(din.data.bf_out.signal.power,1);
            case 'interference'
                data = din.data.bf_out.interference.power;
                n_locs = size(din.data.bf_out.interference.power,1);
            case 'noise'
                data = din.data.bf_out.noise.power;
                n_locs = size(din.data.bf_out.noise.power,1);
            case 'all'
                data = din.data.bf_out.all.power;
                n_locs = size(din.data.bf_out.all.power,1);
            otherwise
                error(['rmvb:' mfilename],...
                    'unknown signal type');
        end
        
        % Convert data to dB scale
%         data = 20*log10(data);
        
        % Normalize the data
        data = data - min(data);
        data = data./max(data);

        
        cfg = [];
        if mismatch
            cfg.condition_name = [data_set.sim '_' data_set.source...
                '_3sphere_power_' signal_type];
        else
            cfg.condition_name = [data_set.sim '_' data_set.source...
                '_power_' signal_type];
        end
        cfg.import = true;
        cfg.eeg_data_file = data_file_name;
        cfg.data = zeros(3, n_locs, 1);
        cfg.data(1,:,1) = data;
        cfg.data_tag = beam_cfgs{i} ;
        cfg.plot = false;
        brainstorm.bstcust_plot_surface(cfg);
    end
end

%% Close all plots
% brainstorm.bstcust_plot_close();
end