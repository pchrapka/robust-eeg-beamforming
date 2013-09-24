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

for k=1:length(cfg.types)
    switch(cfg.types{k})
        case 'rmv'
            % RMV
            beam_cfg(k).verbosity = 0;
            beam_cfg(k).type = 'rmv';
            beam_cfg(k).name = 'rmv';
            beam_cfg(k).loc = cfg.loc;
            beam_cfg(k).epsilon = ones(3,1)*sqrt(cfg.epsilon^2/3);
            
        case 'lcmv'
            % LCMV
            beam_cfg(k).verbosity = 0;
            beam_cfg(k).type = 'lcmv';
            beam_cfg(k).name = 'lcmv';
            beam_cfg(k).loc = cfg.loc;
            
        case 'lcmv_eig'
            % LCMV EIG
            beam_cfg(k).verbosity = 0;
            beam_cfg(k).type = 'lcmv_eig';
            beam_cfg(k).name = 'lcmv eigenspace';
            beam_cfg(k).loc = cfg.loc;
            beam_cfg(k).n_interfering_sources = cfg.n_interfering_sources;
            
        case 'lcmv_reg'
            % LCMV REG
            beam_cfg(k).verbosity = 0;
            beam_cfg(k).type = 'lcmv_reg';
            beam_cfg(k).name = 'lcmv regularized';
            beam_cfg(k).loc = cfg.loc;
            beam_cfg(k).lambda = cfg.lambda;

        otherwise
            error('set_up_beamformers:KeyError',...
            ['Unknown beamformer: ' cfg.types{k}]);
    end
end

end