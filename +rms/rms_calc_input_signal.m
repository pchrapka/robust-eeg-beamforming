function [input_signal] = rms_calc_input_signal(cfg)
%RMS_CALC_INPUT_SIGNAL calculates the input signal
%   RMS_CALC_INPUT_SIGNAL(CFG) returns the full input signal matrix
%   [components x vertices x timepoints]
%   
%   cfg.sim_name    name of the simulation config file
%   cfg.source_name name of the source config

% Create the sim_cfg variable
sim_cfg = [];

% Evaluate the sim_data file
eval(cfg.sim_name);

% Evalute source_file, creates the sim_cfg variable
switch(cfg.source_name)
    case 'single_cort_src_1'
        eval('src_param_single_cortical_source_1');
    case 'mult_cort_src_10'
        eval('src_param_mult_cortical_source_10');
    case 'mult_cort_src_16'
        eval('src_param_mult_cortical_source_16');
    case 'mult_cort_src_17'
        eval('src_param_mult_cortical_source_17');
    case 'distr_cort_src_2'
        eval('src_param_distr_cortical_source_2');
    case 'distr_cort_src_3'
        eval('src_param_distr_cortical_source_3');
    otherwise
        error('rms:rms_calc_input_signal',...
            ['unknown source_name: ' cfg.source_name]);
end

% Create the full input data matrix
n_locs = size(sim_cfg.head.GridLoc,1);
input_signal = zeros(3, n_locs, sim_cfg.timepoints);

% Modify the source configurations to remove the jitter
for i=1:length(sim_cfg.sources)
    sim_cfg.sources{i}.jitter = 0;
end

% Create the source signal
[sim_cfg, source_signal] = aet_sim_sources_trial(sim_cfg);

% Calculate the input signal at each source
for i=1:length(sim_cfg.sources)
    % Extract the source index and moment
    source_idx = sim_cfg.sources{i}.source_index;
    source_moment = sim_cfg.sources{i}.moment;
    input_signal(:, source_idx, :) = ...
        source_moment * source_signal(i,:);
end


end