function [mag_dist_data] = magnitude_distance_bf_file(cfg)
%MAGNITUDE_DISTANCE_BF_FILE Calculates the magnitude vs distance for
%multiple data sets
%   MAGNITUDE_DISTANCE_BF_FILE(CFG)
%
%   cfg.sample_idx  
%       sample position at which to calculate the dispersion
%   cfg.beam_cfgs   
%       cell array of beamformer cfg file tags to process
%   cfg.data_set
%       SimDataSetEEG object
%   cfg.head        
%       IHeadModel obj, see HeadModel

%% Calculate dispersion for all desired beamformer configs
for i=1:length(cfg.beam_cfgs)
    
    % Get the full data file name
    tag = [cfg.beam_cfgs{i} '_mini'];
    data_file = db.save_setup('data_set',cfg.data_set,'tag',tag);
    
    % Load the data
    data_in = load(data_file);
    
    % Set up cfg for dispersion
    cfg_disp = [];
    cfg_disp.head = cfg.head;
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
% Set up output file
if isempty(strfind(cfg.beam_cfgs{1}, '3sphere'))
    tag = 'mag_dist';
else
    tag = 'mag_dist_3sphere';
end
save_file = db.save_setup('data_set',data_set,'tag',tag);
save(save_file, 'mag_dist_data');

end