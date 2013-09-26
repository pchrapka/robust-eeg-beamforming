function simulation_variations(sim_vars, sim_cfg)
%SIMULATION_VARIATIONS Function for running simulation variations
%   SIMULATION_VARIATIONS(SIM_VARS, SIM_CFG) runs simulations for a
%   particular type of beamformer based on permutations of the simulation
%   variables provided by sim_vars
%
%   TODO Finish up a more complete description here

if length(sim_cfg.beamformer_type) > 1
    error('simulation_variations:KeyError',...
            'You can only select one beamformer at a time');
end

%% Expand the variations
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

%% Setup and run the simulation
% Allocate memory
out(length(p)).snr = 0;
% Check if we can run it in parallel
if isequal(sim_cfg.beamformer_type, 'rmv')
    % Regular
    for i=1:length(p)
        % Set up the beamformer config
        beam_cfg.loc = p(i).loc;
        beam_cfg.epsilon = p(i).epsilon;
        beam_cfg.lambda = 0; % Set later
        beam_cfg.n_interfering_sources = ...
            sim_cfg.n_interfering_sources;
        beam_cfg.types = cfg.beamformer_type;
        beam_cfg = set_up_beamformers(beam_cfg);
        
        % Set up config for the simulation
        cfg.head_model_file = ['..' filesep 'head-models'...
            filesep sim_cfg.head_model_file];
        cfg.data_file = p(i).in;
        cfg.beam_cfg = beam_cfg(1);
        
        % Run the simulation
        out(i) = simulation_generic(cfg);
    end
    
else
    n_interfering_sources = sim_cfg.n_interfering_sources;
    beamformer_type = sim_cfg.beamformer_type;
    head_model_data_full = sim_cfg.head_model_data_full;
    % Parallel
    parfor i=1:length(p)
        % Set up the beamformer config
        beam_cfg_in = struct([]);
        beam_cfg_in.loc = p(i).loc;
        beam_cfg_in.epsilon = p(i).epsilon;
        beam_cfg_in.lambda = 0; % Set later
        beam_cfg_in.n_interfering_sources = ...
            n_interfering_sources;
        beam_cfg_in.types = beamformer_type;
        beam_cfg = set_up_beamformers(beam_cfg_in);
        
        % Set up config for the simulation
        cfg = struct([]);
        cfg.head_model_file = head_model_data_full;
        cfg.data_file = p(i).in;
        cfg.beam_cfg = beam_cfg(1);
        
        % Run the simulation
        out(i) = simulation_generic(cfg);
    end
end

%% Save the data
out_file_name = [sim_cfg.out_dir filesep sim_cfg.out_file_name];
save(out_file_name, out);
end