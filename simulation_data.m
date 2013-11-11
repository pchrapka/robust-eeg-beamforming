function simulation_data(cfg)
% Script for creating the data

if ~isfield(cfg,'sim_cfg')
    % Load the simulation parameters
    eval(cfg.sim_data);
    eval(cfg.sim_src_parameters);
else
    sim_cfg = cfg.sim_cfg;
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
        
        % Add some info
        data.iteration = i;
        data.snr = cur_snr;

        tmpcfg = [];
        tmpcfg.sim_name = sim_cfg.sim_name;
        tmpcfg.source_name = sim_cfg.source_name;
        tmpcfg.snr = cur_snr;
        tmpcfg.iteration = i;
        save_file = db.save_setup(tmpcfg);
        parsave(save_file, data);
    end
end

%% End parallel execution
sim_cfg.parallel = '';
aet_parallel_close(sim_cfg)

end

function parsave(fname, data)
save(fname, 'data')
end