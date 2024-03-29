% Prototype code to compare dipole mse
close all;

%% Get the data
% Set up config to get the data file
snr = 0;

cfg_data = [];
beam_cfgs = {...
    ...Matched
    'rmv_epsilon_20',...
    'lcmv',...
    'lcmv_eig_0',...
    'lcmv_reg_eig',...
    ...Mismatched
    'lcmv_3sphere',...
    'lcmv_eig_0_3sphere',...
    'lcmv_reg_eig_3sphere',...
    'rmv_epsilon_150_3sphere',...
    'rmv_aniso_3sphere'};

sim_name = 'sim_data_bem_1_100t_1000s';
% source_name = 'single_cort_src_1';
% source_config = 'src_param_single_cortical_source_1';
source_name = 'mult_cort_src_17';
source_config = 'src_param_mult_cortical_source_17';

data_set = SimDataSetEEG(...
    sim_name,...
    source_name,...
    snr,...
    'iter',1);

bf_data = cell(size(beam_cfgs));
for i=1:length(beam_cfgs)
    tag = beam_cfgs{i};
    
    % Get the file name
    file_name = data_set.get_full_filename(tag);
    % Add extension
    file_name = strcat(file_name, '.mat');
    
    % Load the beamformer data
    data_in = load(file_name);
    bf_data{i}.name = beam_cfgs{i};
    bf_data{i}.bf_out = data_in.source.beamformer_output;
end

%% Get configs
% Load config parameters
clear sim_cfg;
eval(sim_name);
eval(source_config);

%% Plot source components
% Choose a source index to plot
loc_idx = 295;
component_labels = {'x','y','z'};
for i=1:length(bf_data)
    figure;
    n_comp = size(bf_data{i}.bf_out,1);
    for j=1:n_comp
        % Plot each component separately
        subplot(n_comp,1,j);
        data = squeeze(bf_data{i}.bf_out(j,loc_idx,:));
        plot(data);
        if j==1
            % Add the title to the first plot
            title(strrep(bf_data{i}.name,'_',' '));
        end
        % Add component labels
        ylabel([component_labels{j} ' comp']);
    end
end

%% Calculate dipoles
sample_idx = 120;
loc_idx = 295;
dipole_actual = sim_cfg.sources{1}.moment;
fprintf('\n-- Dipoles --\n');
data_error = cell(length(bf_data),2);
for i=1:length(bf_data)
    dipole = bf_data{i}.bf_out(:,loc_idx,sample_idx);
    fprintf('%s\n',strrep(bf_data{i}.name,'_',' '));
    dipole_mom = dipole/norm(dipole);
    fprintf('[%f %f %f]\n',dipole_mom);
    
    % Calculate the error
    error = sum(dipole_mom - dipole_actual).^2/length(dipole_mom);
    fprintf('error: %f\n', error);
    
    % Save the errors
    data_error{i,1} = bf_data{i}.name;
    data_error{i,2} = error;
end

fprintf('Actual dipole moment\n');
fprintf('[%f %f %f]\n', dipole_actual);

% %% Output the dipole errors to a csv file
% cfg_csv = cfg_data;
% cfg_csv.tag = '';
% cfg_csv.col_labels = {'Beamformer','Dipole Moment MSE'};
% cfg_csv.col_format = {'%s','%0.10f'};
% cfg_csv.data = data_error;
% util.dipole.dipole_error_summarize_csv(cfg_csv);
