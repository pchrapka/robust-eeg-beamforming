function simulation_data(varargin)
% Script for creating the data

%% Load the simulation parameters
optargin = size(varargin,2);
% Load the simulation parameters
for i=1:optargin
    eval(varargin{i});
end

%% Control parallel execution explicity
sim_cfg.parallel = 'user';
aet_parallel_init(sim_cfg)

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