function run_sim_vars_bem_mult_paper_locs2(sim_file,source_file,source_name,varargin)
%run_sim_vars_bem_mult_paper_locs2 configures and runs data generation
%   run_sim_vars_bem_mult_paper_locs2(sim_file,source_file,source_name,...)
%   configures and runs data generation and beamformer analysis for single
%   source configurations. 
%
%   The beamformer configuration set is 'sim_vars_mult_src_paper_matched'
%   for the matched case and 'sim_vars_mult_src_paper_mismatched' for the
%   mismatched case.
%
%   The beamformer locations are set to 295,400

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'matched','both',@(x) any(validatestring(x,{'matched','mismatched','both'})));
parse(p,sim_file,source_file,source_name,varargin{:});

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');

%% Set up scripts to run

% Simulate ERP data
scripts(k).func = @simulation_data;
cfg = struct(...
    'sim_data',             sim_file,...
    'sim_src_parameters',   source_file,...
    'snr_range',            -10:5:30,...
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
    'snr',-10:5:30 ...
    );

%% ==== MATCHED LEADFIELD ====
if isequal(p.Results.matched,'both') || isequal(p.Results.matched,'matched')
    
    scripts(k).func = @sim_vars.run;
    cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_paper_matched');
    cfg_simvars_setup.data_file = data_files;
    cfg_simvars_setup.force = force;
    cfg_simvars_setup.tag = 'locs2';
    cfg_simvars_setup.head = hm_bem;
    cfg_simvars_setup.loc = [295,400];
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
    cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_paper_mismatched');
    cfg_simvars_setup.data_file = data_files;
    cfg_simvars_setup.force = force;
    cfg_simvars_setup.tag = 'locs2_3sphere';
    cfg_simvars_setup.head = [];
    cfg_simvars_setup.head.current = hm_3sphere;
    cfg_simvars_setup.head.actual = hm_bem;
    cfg_simvars_setup.loc = [295,400];
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


%% Compute sinr vs snr
% metric_analysis_sinr_mult17_lag40_paper