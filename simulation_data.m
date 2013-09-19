function simulation_data()
% Script for creating the data

%% Initialize the Advanced EEG Toolbox
aet_init

%% Load the simulation parameters
sim_param_file

%% Control parallel execution explicity
sim_cfg.parallel = 'user';
aet_parallel_init(sim_cfg)

%% Load the source parameters
source_type = 'multiple';
switch source_type
    case 'single'
        src_param_single_cortical_source
    case 'multiple'
        src_param_mult_cortical_source
    otherwise
        error('simulation_data:KeyError',...
            ['Unknown source type: ' source_type]);
end

%% Generate/load data
parfor j=1:length(sim_cfg.snr_range)
    for i=1:sim_cfg.n_runs
        % Copy the config
        temp_cfg = sim_cfg;
        
        % Adjust SNR of source 1
        cur_snr = temp_cfg.snr_range(j);
        temp_cfg.snr.signal = cur_snr;
        
        % Create the data
        data = aet_sim_create_eeg(temp_cfg);
        
        % Save the data
        temp_cfg.data_type = [...
            sim_cfg.source_name '_'...
            num2str(cur_snr) '_'...
            num2str(i)...
            ];
        
        aet_save(temp_cfg, data);
    end
end

%% End parallel execution
sim_cfg.parallel = '';
aet_parallel_close(sim_cfg)

end