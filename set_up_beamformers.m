function [ beam_cfg ] = set_up_beamformers(cfg)
%SET_UP_BEAMFORMERS Set up beamformers
%   SET_UP_BEAMFORMERS(CFG) returns a config with the necessary beamformer
%   configurations. Most of the parameters are hard coded here.
%
%   NOTE To set up a different configuration either add a new function or
%   specify a different configuration here. Not sure what's the best
%   solution.
%
%   Input
%   cfg.loc         index of location in cfg.head_model.GridLoc where to do
%                   beamforming
%       epsilon     (required for 'rmv') 
%                   bound for the uncertainty in the lead field matrix or H
%       lambda      (required for 'lcmv_reg') 
%                   regularization parameter
%       n_interfering_sources      
%                   (required for 'lcmv_eig') 
%                   number of interfering sources
%       types       cell array of strings specifying which beamformers
%                   types to include

%% Configure beamformers
beam_cfg(length(cfg.types)).verbosity = 0;

% Start counter
beam_idx = 1;
% Loop through beamformer types
for k=1:length(cfg.types)
    switch(cfg.types{k})
        case 'rmv'
            % RMV
            for j=1:length(cfg.epsilon)
                beam_cfg(beam_idx).verbosity = 0;
                beam_cfg(beam_idx).type = 'rmv';
                beam_cfg(beam_idx).name = ...
                    ['rmv \epsilon ' num2str(cfg.epsilon(j))];
                beam_cfg(beam_idx).loc = cfg.loc;
                beam_cfg(beam_idx).epsilon = ...
                    ones(3,1)*sqrt(cfg.epsilon(j)^2/3);
                % Increment counter
                beam_idx = beam_idx + 1;
            end
            
        case 'lcmv'
            % LCMV
            beam_cfg(beam_idx).verbosity = 0;
            beam_cfg(beam_idx).type = 'lcmv';
            beam_cfg(beam_idx).name = 'lcmv';
            beam_cfg(beam_idx).loc = cfg.loc;
            % Increment counter
            beam_idx = beam_idx + 1;
            
        case 'lcmv_eig'
            % LCMV EIG
            beam_cfg(beam_idx).verbosity = 0;
            beam_cfg(beam_idx).type = 'lcmv_eig';
            beam_cfg(beam_idx).name = 'lcmv eigenspace';
            beam_cfg(beam_idx).loc = cfg.loc;
            beam_cfg(beam_idx).n_interfering_sources = cfg.n_interfering_sources;
            % Increment counter
            beam_idx = beam_idx + 1;
            
        case 'lcmv_reg'
            % LCMV REG
            beam_cfg(beam_idx).verbosity = 0;
            beam_cfg(beam_idx).type = 'lcmv_reg';
            beam_cfg(beam_idx).name = 'lcmv regularized';
            beam_cfg(beam_idx).loc = cfg.loc;
            beam_cfg(beam_idx).lambda = cfg.lambda;
            % Increment counter
            beam_idx = beam_idx + 1;
            
        case 'beamspace'
            % BEAMSPACE
            beam_cfg(beam_idx).verbosity = 0;
            beam_cfg(beam_idx).type = 'beamspace';
            beam_cfg(beam_idx).name = 'beamspace';
            beam_cfg(beam_idx).loc = cfg.loc;
            beam_cfg(beam_idx).T = cfg.T;
            % Increment counter
            beam_idx = beam_idx + 1;
            
        otherwise
            error('set_up_beamformers:KeyError',...
            ['Unknown beamformer: ' cfg.types{k}]);
    end
end

end