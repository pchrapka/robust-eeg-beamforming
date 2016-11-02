function run_sim_vars_bemhd_paper(sim_file,source_file,source_name,varargin)
%run_sim_vars_bemhd_paper configures and runs data generation
%   run_sim_vars_bemhd_paper(sim_file,source_file,source_name,...)
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
%   locs (vector, default = 'all')
%       location indices to scan, all = [1:15028]

p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'matched','both',@(x) any(validatestring(x,{'matched','mismatched','both'})));
addParameter(p,'snrs',-10:5:30,@isvector);
addParameter(p,'config','',@ischar);
addParameter(p,'hmconfigs',{'matched','mismatched'},...
    @(y) all(cellfun(@(x) any(validatestring(x,{'matched','mismatched','mismatched_perturbed'})), y)));
addParameter(p,'locs','all',@(x) ischar(x) || isvector(x));
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

if isequal(p.Results.locs,'all')  
    locs = 1:15028;
    tag_matched = [];
    tag_mismatched = '3sphere';
else
    locs = p.Results.locs;
    tag_matched = sprintf('locs%d',length(p.Results.locs));
    tag_mismatched = sprintf('locs%d_3sphere',length(p.Results.locs));
end

k = 1;

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_15028V.mat');
if p.Results.hm_perturb
    hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_15028V_perturb0.10.mat');
    tag_mismatched = [tag_mismatched '_perturb0.10'];
else
    hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_15028V.mat');
end

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

for i=1:length(p.Results.hmconfigs)
    switch p.Results.hmconfigs{i}
        case 'matched'
            % ==== MATCHED LEADFIELD ====
            
            scripts(k).func = @sim_vars.run;
            cfg_simvars_setup = get_beamformer_config_set(config_matched);
            cfg_simvars_setup.data_file = data_files;
            cfg_simvars_setup.force = force;
            cfg_simvars_setup.tag = tag_matched;
            cfg_simvars_setup.head = hm_bem;
            cfg_simvars_setup.loc = locs;
            cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
            
            cfg = struct(...
                'sim_vars',             cfg_simvars,...
                'analysis_run_func',    @beamformer_analysis,...
                ...Allow parallel execution of the scans
                'parallel',             false,...
                'debug',                false);
            scripts(k).vars = {cfg};
            k = k+1;
            
            
        case 'mismatched'
            % ==== MISMATCHED LEADFIELD ====
            
            scripts(k).func = @sim_vars.run;
            cfg_simvars_setup = get_beamformer_config_set(config_mismatched);
            cfg_simvars_setup.data_file = data_files;
            cfg_simvars_setup.force = force;
            cfg_simvars_setup.tag = tag_mismatched;
            cfg_simvars_setup.head = [];
            cfg_simvars_setup.head.current = hm_3sphere;
            cfg_simvars_setup.head.actual = hm_bem;
            cfg_simvars_setup.loc = locs;
            cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
            cfg = struct(...
                'sim_vars',             cfg_simvars,...
                'analysis_run_func',    @beamformer_analysis,...
                ...Allow parallel execution of the scans
                'parallel',             false,...
                'debug',                false);
            scripts(k).vars = {cfg};
            k = k+1;
            
        case 'mismatched_perturbed'
            hm_bem_perturb = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V_perturb0.10.mat');
            tag_mismatched2 = [tag_mismatched '_perturb0.10'];
            % ==== MISMATCHED LEADFIELD ====
            % ==== PERTURBED HEAD MODEL ====
            
            scripts(k).func = @sim_vars.run;
            cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_paper_mismatched_perturbed');
            cfg_simvars_setup.data_file = data_files;
            cfg_simvars_setup.force = force;
            cfg_simvars_setup.tag = tag_mismatched2;
            cfg_simvars_setup.head = [];
            cfg_simvars_setup.head.current = hm_3sphere;
            cfg_simvars_setup.head.actual = hm_bem_perturb;
            cfg_simvars_setup.loc = [295,400];
            cfg_simvars_setup.cov_type = p.Results.cov_type;
            cfg_simvars_setup.cov_samples = p.Results.cov_samples;
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
end

%% Run the scripts
aet_run_scripts( scripts );

end