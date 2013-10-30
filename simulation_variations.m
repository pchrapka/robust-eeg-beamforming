function simulation_variations(sim_vars, sim_cfg)
%SIMULATION_VARIATIONS Function for running simulation variations
%   SIMULATION_VARIATIONS(SIM_VARS, SIM_CFG) runs simulations for a
%   particular type of beamformer based on permutations of the simulation
%   variables provided by sim_vars
%
%   TODO Finish up a more complete description here

if iscell(sim_cfg.beamformer_type) && length(sim_cfg.beamformer_type) > 1
    error('simulation_variations:KeyError',...
            'You can only select one beamformer at a time');
end

% Configure the beamspace beamformer
if isequal(sim_cfg.beamformer_type, 'beamspace')
    cfg_beamspace.n_evalues = sim_cfg.n_evalues;
    cfg_beamspace.head_model = sim_cfg.head;
    beamspace_data = aet_analysis_beamspace_cfg(cfg_beamspace);
    beamspace_T = beamspace_data.T;
else
    beamspace_T = 0;
end

%% Setup and run the simulation
% Check if we can run it in parallel
if isequal(sim_cfg.beamformer_type, 'rmv')
    % Expand the variations
    index=arrayfun(@(p) (1:length(p.values)), ...
        sim_vars, 'UniformOutput', false);
    [index{:}]=ndgrid(index{:});
    
    structarg=[{sim_vars.name}; ...
        arrayfun(@(p,idx) (p.values(idx{1})), ...
        sim_vars, index, 'UniformOutput', false)];
    p=struct(structarg{:});
    clear index structarg
    % Optinal reshapping structure in row
    p=reshape(p,1,[]);

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
    
else
    % Remove epsilon variations
    for i=1:length(sim_vars)
        if isequal(sim_vars(i).name,'epsilon')
            sim_vars(i) = [];
            break;
        end
    end
    
     % Expand the variations
    index=arrayfun(@(p) (1:length(p.values)), ...
        sim_vars, 'UniformOutput', false);
    [index{:}]=ndgrid(index{:});
    
    structarg=[{sim_vars.name}; ...
        arrayfun(@(p,idx) (p.values(idx{1})), ...
        sim_vars, index, 'UniformOutput', false)];
    p=struct(structarg{:});
    clear index structarg
    % Optinal reshapping structure in row
    p=reshape(p,1,[]);
    
    % Copy vars for parfor
    n_interfering_sources = sim_cfg.n_interfering_sources;
    beamformer_type = sim_cfg.beamformer_type;
    head_model_data_full = sim_cfg.head_model_data_full;

    % Parallel
    parfor i=1:length(p)
        % Set up the beamformer config
        beam_cfg_in = struct('loc',p(i).loc);
        %beam_cfg_in.loc = p(i).loc;
        if isfield(p(i),'epsilon')
            beam_cfg_in.epsilon = p(i).epsilon;
        end
        beam_cfg_in.lambda = 0; % Set later
        beam_cfg_in.n_interfering_sources = ...
            n_interfering_sources;
        beam_cfg_in.types{1} = beamformer_type;
        beam_cfg.T = beamspace_T;
        beam_cfg = set_up_beamformers(beam_cfg_in);
        
        % Set up config for the simulation
        cfg = struct('head_model_file',head_model_data_full);
        cfg.data_file = p(i).in;
        cfg.beam_cfg = beam_cfg(1);
        
        % Run the simulation
        out(i) = simulation_generic(cfg); %#ok<NASGU,PFOUS>
    end
    
end

%% Save the data
out_file_name = [sim_cfg.out_dir filesep sim_cfg.out_file_name];
save(out_file_name, 'out');
end