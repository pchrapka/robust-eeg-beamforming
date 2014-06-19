function simulation_data_inner(sim_cfg, snr_iter, run_iter)
% Copy the config
temp_cfg = sim_cfg;

% Adjust SNR of source 1
cur_snr = temp_cfg.snr_range(snr_iter);
temp_cfg.snr.signal = cur_snr;

tmpcfg = [];
tmpcfg.sim_name = temp_cfg.sim_name;
tmpcfg.source_name = temp_cfg.source_name;
tmpcfg.snr = cur_snr;
tmpcfg.iteration = run_iter;
save_file = db.save_setup(tmpcfg);
if exist(save_file,'file') && ~temp_cfg.force
    if verLessThan('matlab', '7.14')
        [~,name,~,~] = fileparts(save_file);
    else
        [~,name,~] = fileparts(save_file);
    end
    fprintf('File exists: %s\n', name);
    fprintf('Skipping data generation\n');
    return
end

% Create the data
data = aet_sim_create_eeg(temp_cfg);

% Add some info
data.iteration = run_iter;
data.snr = cur_snr;

parsave(save_file, data);
end

function parsave(fname, data)
save(fname, 'data')
end