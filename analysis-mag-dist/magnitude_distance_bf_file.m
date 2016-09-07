function [mag_dist_data] = magnitude_distance_bf_file(cfg)
%MAGNITUDE_DISTANCE_BF_FILE Calculates the magnitude vs distance for
%multiple data sets
%   MAGNITUDE_DISTANCE_BF_FILE(CFG)
%
%   cfg.sample_idx  sample position at which to calculate the dispersion
%   cfg.beam_cfgs   cell array of beamformer cfg file tags to process
%   cfg.sim_name    simulation config name
%   cfg.source_name source config name
%   cfg.snr         snr
%   cfg.iteration   simulation iteration
%   cfg.head        IHeadModel obj, see HeadModel

%% Set up simulation info
cfg_data = [];
cfg_data.sim_name = cfg.sim_name;
cfg_data.source_name = cfg.source_name;
cfg_data.snr = cfg.snr;
cfg_data.iteration = cfg.iteration;

%% Load the head model

cfg.head.load();
head = cfg.head.data;
% FIXME don't copy data

%% Calculate dispersion for all desired beamformer configs
for i=1:length(cfg.beam_cfgs)
    
    % Get the full data file name
    cfg_data.tag = [cfg.beam_cfgs{i} '_mini'];
    data_file = db.save_setup(cfg_data);
    
    % Load the data
    data_in = load(data_file);
    
    % Set up cfg for dispersion
    cfg_disp = [];
    cfg_disp.head = head;
    cfg_disp.bf_out = data_in.source.beamformer_output;
    cfg_disp.sample_idx = cfg.sample_idx;
    
    % Calculate the dispersion
    mag_dist_data.name{i} = cfg.beam_cfgs{i};
    [mag_dist_data.mag(:,i), mag_dist_data.dist(:,i)] = ...
        magnitude_distance(cfg_disp);
    
end

% figure;
% plot(mag_dist_data.dist',mag_dist_data.mag');
% legend(mag_dist_data.name);

n_data = length(mag_dist_data.name);
cc=jet(n_data);
figure; 
hold on;
for i=1:n_data
    % Combine the data
    data = [mag_dist_data.dist(:,i) mag_dist_data.mag(:,i)];
    % Sort data based on distance
    data = sortrows(data,1);
    plot(data(:,1),data(:,2),...
        'color',cc(i,:));
end
legend(mag_dist_data.name);

%% Save the data
% Set up output file cfg
cfg_out = cfg_data;
if isempty(strfind(cfg.beam_cfgs{1}, '3sphere'))
    cfg_out.tag = 'mag_dist';
else
    cfg_out.tag = 'mag_dist_3sphere';
end
save_file = db.save_setup(cfg_out);
save(save_file, 'mag_dist_data');

end