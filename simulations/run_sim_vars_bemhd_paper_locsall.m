function run_sim_vars_bemhd_paper_locsall(sim_file,source_file,source_name,varargin)
%run_sim_vars_bemhd_paper_locsall configures and runs data generation
%   run_sim_vars_bemhd_paper_locsall(sim_file,source_file,source_name,...)
%   configures and runs data generation and beamformer analysis for a high
%   resolution head model
%
%   The beamformer configuration are set as follows
%   config = 'mult-paper
%       'sim_vars_mult_src_paper_matched'
%       'sim_vars_mult_src_paper_mismatched'
%   config = 'single-paper
%       'sim_vars_single_src_paper_matched'
%       'sim_vars_single_src_paper_mismatched'
%
%   The beamformer locations are set to 1:15028

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'matched','both',@(x) any(validatestring(x,{'matched','mismatched','both'})));
addParameter(p,'snrs',-10:5:30,@isvector);
addParameter(p,'config','',@ischar);
parse(p,sim_file,source_file,source_name,varargin{:});

% set the beamformer configs
switch p.Results.config
    case 'mult-paper'
        config_matched = 'sim_vars_mult_src_paper_matched';
        config_mismatched = 'sim_vars_mult_src_paper_mismatched';
    case 'single-paper'
        config_matched = 'sim_vars_single_src_paper_matched';
        config_mismatched = 'sim_vars_single_src_paper_mismatched';
    otherwise
        error('unknown beamformer config set');
end

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_15028V.mat');
hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_15028V.mat');

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             sim_file,...
    'sim_src_parameters',   source_file,...
    'snr_range',            p.Results.snrs,...
    ...Allow aet_sim_eeg_avg to parallelize the trials
    'parallel',             false);
scripts(k).vars = {cfg};
k = k+1;

%% Parameter sweep
force = false;

data_files = get_sim_data_files(...
    'sim',sim_file,...
    'source',source_name,...
    'iterations',1,...
    'snr',p.Results.snrs ...
    );

%% ==== MATCHED LEADFIELD ====
if isequal(p.Results.matched,'both') || isequal(p.Results.matched,'matched')
    
    scripts(k).func = @sim_vars.run;
    cfg_simvars_setup = get_beamformer_config_set(config_matched);
    cfg_simvars_setup.data_file = data_files;
    cfg_simvars_setup.force = force;
    cfg_simvars_setup.tag = [];
    cfg_simvars_setup.head = hm_bem;
    cfg_simvars_setup.loc = 1:15028;
    cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
    
    cfg = struct(...
        'sim_vars',             cfg_simvars,...
        'analysis_run_func',    @beamformer_analysis,...
        ...Allow parallel execution of the scans
        'parallel',             false,...
        'debug',                false);
    scripts(k).vars = {cfg};
    k = k+1;
end

%% ==== MISMATCHED LEADFIELD ====
if isequal(p.Results.matched,'both') || isequal(p.Results.matched,'mismatched')
    
    scripts(k).func = @sim_vars.run;
    cfg_simvars_setup = get_beamformer_config_set(config_mismatched);
    cfg_simvars_setup.data_file = data_files;
    cfg_simvars_setup.force = force;
    cfg_simvars_setup.tag = '3sphere';
    cfg_simvars_setup.head = [];
    cfg_simvars_setup.head.current = hm_3sphere;
    cfg_simvars_setup.head.actual = hm_bem;
    cfg_simvars_setup.loc = 1:15028;
    cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
    cfg = struct(...
        'sim_vars',             cfg_simvars,...
        'analysis_run_func',    @beamformer_analysis,...
        ...Allow parallel execution of the scans
        'parallel',             false,...
        'debug',                false);
    scripts(k).vars = {cfg};
    k = k+1;
end

%% Run the scripts
aet_run_scripts( scripts );

end