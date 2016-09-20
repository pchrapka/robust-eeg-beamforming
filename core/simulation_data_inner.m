function simulation_data_inner(sim_cfg, snr, run_iter)
%SIMULATION_DATA_INNER core eeg data simulation routine
%   SIMULATION_DATA_INNER core eeg data simulation routine
%   
%   Input
%   -----
%   sim_cfg
%       simulation config, see aet_sim_create_eeg
%   snr (integer)
%       snr value
%   run_iter (integer)
%       iteration value

% parse inputs
p = inputParser();
addRequired(p,'snr',@(x) isequal(length(x),1));
addRequired(p,'run_iter',@(x) isequal(length(x),1));
p.parse(snr,run_iter);

% Copy the config
temp_cfg = sim_cfg;

%% Adjust SNR of sources
switch temp_cfg.snr.type
    case 'on_average'
        temp_cfg.snr.signal = snr;
        if sum(isinterference(temp_cfg.sources)) > 0
            % Only adjust interference if there are sources labeled as interference
            % adjust interference source to equal signal source
            temp_cfg.snr.interference = snr;
        end
    case 'per_trial'
        for i=1:length(temp_cfg.sources)
            temp_cfg.sources{i}.snr = snr;
        end
    otherwise
        error('unknown snr option %s',temp_cfg.snr.type);
end

%% set up ouputfile
data_set = SimDataSetEEG(...
    temp_cfg.sim_name,...
    temp_cfg.source_name,...
    snr,...
	'iter', run_iter);
    
save_file = db.save_setup('data_set',data_set);

%% check if the file exists
if exist(save_file,'file') && ~temp_cfg.force
    [~,name,~,~] = util.fileparts(save_file);
    fprintf('File exists: %s\n', name);
    fprintf('Skipping data generation\n');
    return
end

%% Create the data
data = aet_sim_create_eeg(temp_cfg);

%% Save
% Add some info
data.iteration = run_iter;
data.snr = snr;

% save data
save(save_file, 'data','-v7.3');
end


function out = isinterference(sources)
% Checks sources labeled as interference
out = cellfun(@(x) ~isempty(strfind(x.type, 'interference')), sources);
end