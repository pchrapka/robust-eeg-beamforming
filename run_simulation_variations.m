function run_simulation_variations(cfg)
%
%
%   cfg
%       sim_vars    array of structs describing simulation variations
%           name    string describing parameter
%           value   cell array of values

%for each variation
% run some funchandle with all of the args
% save each variation

% Check if we can run parallel
run_parallel = sim_vars_check_parallel(cfg.sim_vars);

% Expand the variations from sim_vars
p = sim_vars_expand(cfg.sim_vars);

% TODO No beamspace configuration yet

if run_parallel
    % Copy vars for parfor
%     n_interfering_sources = sim_cfg.n_interfering_sources;
%     beamformer_type = sim_cfg.beamformer_type;
%     head_model_data_full = sim_cfg.head_model_data_full;

    % Parallel
    analysis_setup_func = cfg.analysis_setup_func;
    analysis_run_func = cfg.analysis_run_func;
    parfor i=1:length(p)
        
        % Set up the analysis config
        tmpcfg = [];
        tmpcfg.beamformer_config = p(i).beamformer_config;
        tmpcfg.head_model_file = p(i).head_model_file;
        tmpcfg.data_file = p(i).data_file;
        
        % FIXME
        tmpcfg = analysis_setup_func(p(i));
        
        % FIXME
        % Maybe check if the output file already exists to avoid redoing
        % simulations if not necessary
        % - add a force flag
        
        % Run the simulation
        out = analysis_run_func(tmpcfg);
%         out(i) = simulation_generic(cfg); %#ok<NASGU,PFOUS>
    end
else
    % Regular
    for i=length(p):-1:1
        % Set up the beamformer config
        beam_cfg.loc = p(i).loc;
        beam_cfg.epsilon = p(i).epsilon;
        beam_cfg.lambda = 0; % Set later
        beam_cfg.n_interfering_sources = ...
            sim_cfg.n_interfering_sources;
        beam_cfg.types{1} = sim_cfg.beamformer_type;
        beam_cfg.T = beamspace_T;
        beam_cfg = set_up_beamformers(beam_cfg);
        
        % Set up config for the simulation
        cfg = struct('head_model_file',...
            sim_cfg.head_model_data_full);
        cfg.data_file = p(i).in;
        cfg.beam_cfg = beam_cfg(1);
        
        % Run the simulation
        out(i) = simulation_generic(cfg); %#ok<NASGU>
    end
end

end