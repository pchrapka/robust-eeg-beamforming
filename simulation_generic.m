function [out] = simulation_generic(cfg)
%SIMULATION_GENERIC
%   SIMULATION_GENERIC(CFG)
%
%   cfg
%       head_model_file
%       data_file
%       beam_cfg
%       

% Load the head model
data_in = load(cfg.head_model_file); % loads head
head = data_in.head;
clear data_in;

% Load the data
data_in = load(cfg.data_file); % loads data
data = data_in.data;
clear data_in;

% Calculate the covariance
if ~isfield(data,'R')
    data.R = cov(data.avg_trials');
    % Calculate it once and save it to the data file
    save(cfg.data_file, 'data');
end
    

% Set lambda for lcmv_reg
if isequal(cfg.beam_cfg.type,'lcmv_reg')
    lambda_cfg.R = data.R;
    lambda_cfg.type = 'eig';
    lambda_cfg.multiplier = 0.005;
    cfg.beam_cfg.lambda = aet_analysis_beamform_get_lambda(...
        lambda_cfg);
    % cfg.beam_cfg.lambda = 10*trace(cov(data.avg_noise'));
end

% Run the beamformer
cfg.beam_cfg.R = data.R;
cfg.beam_cfg.head_model = head;
beam_out = aet_analysis_beamform(cfg.beam_cfg);

% Calculate the output of the beamformer with different data
cfg.beam_cfg.W = beam_out.W;
signal = aet_analysis_beamform_output(...
    cfg.beam_cfg, data.avg_signal);
interference = aet_analysis_beamform_output(...
    cfg.beam_cfg, data.avg_interference);
noise = aet_analysis_beamform_output(...
    cfg.beam_cfg, data.avg_noise);

%% Save the output data
out.data_file = cfg.data_file;
out.beamformer_type = cfg.beam_cfg.type;
out.W = beam_out.W;
out.H = beam_out.H;
out.loc = beam_out.loc;
out.snr = data.snr; % redundant, info in data_file
out.iteration = data.iteration; % redundant, info in data_file

% Calculate the SINR
out.sinr = calc_sinr(signal, interference, noise);

if isfield(cfg.beam_cfg,'epsilon')
    out.epsilon = cfg.beam_cfg.epsilon;
end

if isequal(cfg.beam_cfg.type,'beamspace')
    out.T = cfg.beam_cfg.T;
end

end