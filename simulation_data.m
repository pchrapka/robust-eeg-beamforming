function simulation_data()
% Script for creating the data

%% Initialize the Advanced EEG Toolbox
aet_init

%% Load the simulation parameters
sim_param_file

%% Load the head model
aet_output(sim_cfg, 1, 'Loading the head model\n');
head_model_data = ['..' filesep 'head-models'...
    filesep sim_cfg.head_model_file];
load(head_model_data);
sim_cfg.head = head;

% Figure out number of channels
gain_temp = aet_source_get_gain(1, sim_cfg.head);
sim_cfg.n_channels = size(gain_temp,1);

%% Control parallel execution explicity
sim_cfg.parallel = 'user';
aet_parallel_init(sim_cfg)

%% Load the source parameters
source_type = 'single';
switch source_type
    case 'single'
        src_param_single_cortical_source
    otherwise
        error('simulation_data:KeyError',...
            ['Unknown source type: ' source_type]);
end

%% Generate/load data
for j=1:length(sim_cfg.snr_range)
    for i=1:sim_cfg.n_runs
        % NOTE snr_range applies to source 1 only
        
        % Adjust SNR of source 1
        cur_snr = sim_cfg.snr_range(j);
        sim_cfg.sources{1}.snr = cur_snr;
        
        % Create the data
        data = aet_sim_create_eeg(sim_cfg);
        
        % Average the data
        data = aet_sim_average_eeg(sim_cfg, data);
        
        % Save the data
        sim_cfg.data_type = [...
            sim_cfg.source_name '_'...
            num2str(cur_snr) '_'...
            num2str(i)...
            ];
        
        % Remove individual trial data to make the file smaller
        data = rmfield(data, 'trials');
        data = rmfield(data, 'noise');
        data = rmfield(data, 'signal');
        data = rmfield(data, 'interference');
        aet_save(sim_cfg, data);
    end
end

%% End parallel execution
sim_cfg.parallel = '';
aet_parallel_close(sim_cfg)

end