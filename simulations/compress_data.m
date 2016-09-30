%% compress_data

% Switch to the data directory
sim_dir = 'single_cort_src_1';
% sim_dir = 'mult_cort_src_6';
% sim_dir = 'distr_cort_src_2';
data_dir = fullfile('output','sim_data_2_100t',sim_dir);
cur_dir = pwd;
cd(data_dir);

% Get list of data files
data_files = dir('*.mat');

% Save the beamformer_ouput in a separate file
for i=1:length(data_files)
    data_file = data_files(i).name;
    data_in = load(['.' filesep data_file]);
    
    if isfield(data_in, 'source')
        disp(['Working on ' data_file]);
        % Extract the beamformer_output
        source = [];
        source.beamformer_output = data_in.source.beamformer_output;
        
        % Create a new file name
        [~,name,~,~] = util.fileparts(data_file);
        save_file = ['.' filesep name '_mini'];
        
        % Save the data
        save(save_file, 'source');
    end
end

cd(cur_dir);