%% brainstorm_import
% Import data from beamformer analysis to Brainstorm

%%%%%%%%%%%%%
% README
% The sequence of steps is important
%   1. Copy/create a new condition
%   2. Rename it based on the outputs of the first cell
%   2. Export the EEG data from Brainstorm into a variable named 'eeg'
%   3. Run the second cell to get the an updated 'eeg' variable
%   4. Import 'eeg' as the new EEG data
%   5. Compute source in Brainstorm using the MNE inverse method, with Full
%   and unconstrained options
%   6. Export the result as 'source'
%   7. Run the third cell to create the source analysis variables
%   8. Import the results

%% Prep conditions parameters
% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_2';
cfg_data.source_name = 'single_cort_src_1';
cfg_data.snr = '-20';
cfg_data.iteration = '1';

fprintf('Condition name: %s_%s\n',...
    cfg_data.sim_name, cfg_data.source_name);

%% Format EEG data for Brainstorm
cfg = [];
cfg.data_file = db.get_full_file_name(cfg_data);
cfg.data_file_tag = ['snr_' cfg_data.snr '_' cfg_data.iteration];
cfg.eeg = eeg;          % export from Brainstorm

brainstorm.prep_import_eeg(cfg);

%% Prep source analysis data

cfg.source = source;    % export from Brainstorm
% Beamformer analyses to import
cfg.tags = {'lcmv',...
    'lcmv_eig_1',...
    'lcmv_eig_2',...
    'lcmv_eig_3',...
    'lcmv_reg_eig',...
    'rmv_epsilon_50',...
    'rmv_epsilon_100',...
    ...'rmv_epsilon_150',...
    'rmv_epsilon_200',...
    ...'rmv_epsilon_250',...
    'rmv_epsilon_300',...
    ...'rmv_epsilon_350',...
    'rmv_epsilon_400',...
    'rmv_eig_1_epsilon_5',...
    'rmv_eig_1_epsilon_10',...
    'rmv_eig_1_epsilon_20',...
    'rmv_eig_1_epsilon_30',...
    'rmv_eig_1_epsilon_40'...
    'rmv_eig_1_epsilon_50',...
    'rmv_eig_1_epsilon_100',...
    ...'rmv_eig_1_epsilon_150',...
    'rmv_eig_1_epsilon_200',...
    ...'rmv_eig_1_epsilon_250',...
    'rmv_eig_1_epsilon_300',...
    ...'rmv_eig_1_epsilon_350',...
    'rmv_eig_1_epsilon_400'...
    };

brainstorm.prep_import_source(cfg);
