function [out] = dipole_error_bf_files(cfg_in)
%DIPOLE_ERROR_BF_FILES Calculates the dipole moment error from a set of
%beamformer data
%   DIPOLE_ERROR_BF_FILES(CFG)
%
%   Beamformer Config
%   -----------------
%   cfg_in.beam_cfgs   
%       cell array of beamformer cfg file tags to process
%
%     Example: 
%     cfg_in.beam_cfgs = {...
%         'rmv_epsilon_20',...
%         'lcmv'
%         };
%   
%   Data Set
%   --------
%   cfg_in.sim_name    simulation config name
%   cfg_in.source_name source config name
%   cfg_in.source_config
%       file name of the source config
%   cfg_in.snr         snr
%   cfg_in.iteration   simulation iteration
%   cfg_in.tag         (optional)
%
%     Example:
%     cfg_in.sim_name = 'sim_data_bem_1_100t';
%     cfg_in.source_name = 'mult_cort_src_10';
%     cfg_in.source_config = 'src_param_mult_cortical_source_10';
%     cfg_in.snr = '0';
%     cfg_in.iteration = '1';
%
%   Extra Options
%   -------------
%   cfg_in.verbose (optional)
%       sets the level of verbosity (0 = default,1)
%   cfg.sample_idx (required)
%       sample index at which to calculate the dipole moment error
%   cfg.location_idx (required)
%       location index at which to calculate the dipole moment error
%   
%   Output
%   ------
%   out is csv-style struct meant for use the dipole_error_summarize_csv.
%   out has the following fields
%   out.col_labels
%       labels for each column of data
%   out.col_format
%       format string for each column (ie. format string for fprintf)
%   out.data
%       cell array of data [rows cols]
%

% Set defaults
if ~isfield(cfg_in, 'verbose'), cfg_in.verbose = 0; end

%% Get the beamformer data
bf_data = cell(size(cfg_in.beam_cfgs));
for i=1:length(cfg_in.beam_cfgs)
    cfg_in.tag = [cfg_in.beam_cfgs{i} '_mini'];
    
    % Get the file name
    file_name = db.get_full_file_name(cfg_in);
    % Add extension
    file_name = strcat(file_name, '.mat');
    
    % Load the beamformer data
    data_in = load(file_name);
    bf_data{i}.name = cfg_in.beam_cfgs{i};
    bf_data{i}.bf_out = data_in.source.beamformer_output;
end

%% Get configs
% Need the original dipole
clear sim_cfg;
eval(cfg_in.sim_name);
eval(cfg_in.source_config);

%% Calculate dipoles
dipole_actual = sim_cfg.sources{1}.moment;
if cfg_in.verbose > 0
    fprintf('\n-- Dipoles --\n');
end
data_error = cell(length(bf_data),2);
for i=1:length(bf_data)
    dipole = bf_data{i}.bf_out(:,cfg_in.location_idx,cfg_in.sample_idx);
    if cfg_in.verbose > 0
        fprintf('%s\n',strrep(bf_data{i}.name,'_',' '));
    end
    dipole_mom = dipole/norm(dipole);
    if cfg_in.verbose > 0
        fprintf('[%f %f %f]\n',dipole_mom);
    end
    
    % Calculate the error
    error = sum(dipole_mom - dipole_actual).^2/length(dipole_mom);
    if cfg_in.verbose > 0
        fprintf('error: %f\n', error);
    end
    
    % Save the errors
    data_error{i,1} = bf_data{i}.name;
    data_error{i,2} = cfg_in.location_idx;
    data_error{i,3} = cfg_in.sample_idx;
    data_error{i,4} = error;
end

if cfg_in.verbose > 0
    fprintf('Actual dipole moment\n');
    fprintf('[%f %f %f]\n', dipole_actual);
end

%% Output the dipole errors to a csv-style struct
out = [];
% cfg_csv.tag = 'dipole_error_summary';
out.col_labels = {...
    'Beamformer','Location Index',...
    'Sample Index', 'Dipole Moment MSE'};
out.col_format = {'%s','%d','%d','%0.10f'};
out.data = data_error;

end