function plot_eeg(sim_file,source_name,snr)

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addRequired(p,'snr',@isnumeric);
parse(p,sim_file,source_name,snr);

data_set = SimDataSetEEG(...
    sim_file,...
    source_name,...
    snr,...
    'iter',1);

% TODO load eeg data

% TODO plot
end