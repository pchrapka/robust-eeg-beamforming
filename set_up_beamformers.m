function [ cfg ] = set_up_beamformers(cfg)
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

% Set up counter
k = 1;

%% Configure beamformers

% RMV_COMP
beam_cfg(k).verbosity = 0;
beam_cfg(k).type = 'rmv';
beam_cfg(k).name = 'rmv componentwise';
beam_cfg(k).loc = cfg.loc;
beam_cfg(k).epsilon = ones(3,1)*sqrt(cfg.epsilon^2/3);

k = k + 1;

% LCMV
beam_cfg(k).verbosity = 0;
beam_cfg(k).type = 'lcmv';
beam_cfg(k).name = 'lcmv';
beam_cfg(k).loc = cfg.loc;

k = k + 1;

% LCMV EIG
beam_cfg(k).verbosity = 0;
beam_cfg(k).type = 'lcmv_eig';
beam_cfg(k).name = 'lcmv eigenspace';
beam_cfg(k).loc = cfg.loc;
beam_cfg(k).n_interfering_sources = cfg.n_interfering_sources;

k = k + 1;

% LCMV REG
beam_cfg(k).verbosity = 0;
beam_cfg(k).type = 'lcmv_reg';
beam_cfg(k).name = 'lcmv regularized';
beam_cfg(k).loc = cfg.loc;
beam_cfg(k).lambda = cfg.labmda;

%% Output the beamformer config
cfg = beam_cfg;

end