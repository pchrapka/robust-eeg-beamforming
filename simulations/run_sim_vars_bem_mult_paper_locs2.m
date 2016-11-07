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
addParameter(p,'hmconfigs',{'matched','mismatched'},...
    @(y) all(cellfun(@(x) any(validatestring(x,{'matched','mismatched'})), y)));
addParameter(p,'snrs',-10:5:30,@isvector);
addParameter(p,'cov_type','time',@(x) any(validatestring(x,{'time','trial'})));
addParameter(p,'cov_samples',[],@isvector);
addParameter(p,'perturb','none',@(x) any(validatestring(x,{'none','perturb0.10'})));
parse(p,sim_file,source_file,source_name,varargin{:});

k = 1;

%% set up tag
tag_base = 'locs2';

switch p.Results.cov_type
    case 'time'
        % Allow parallel execution of the permutations, not scans
        parallel = true;
        tag_params = sprintf('%s_cov%s',tag_base,p.Results.cov_type);
    case 'trial'
        tag_params = sprintf('%s_cov%s_s%d-%d',tag_base,p.Results.cov_type,...
            p.Results.cov_samples(1),p.Results.cov_samples(end));
        % Allow parallel execution of the scans, not permutations
        parallel = false;
end

tag_matched = tag_params;

switch p.Results.perturb
    case 'none'
        tag_mismatched = [tag_params '_3sphere'];
    case 'perturb0.10'
        tag_mismatched = [tag_params '_' p.Results.perturb '_3sphere'];
end

%% set up head models
hmfactory = HeadModel();
hm_3sphere = hmfactory.createHeadModel('brainstorm','head_Default1_3sphere_500V.mat');
switch p.Results.perturb
    case 'none'
        hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');
    case 'perturb0.10'
        hm_bem = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V_perturb0.10.mat');
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
            cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_paper_matched');
            cfg_simvars_setup.data_file = data_files;
            cfg_simvars_setup.force = force;
            cfg_simvars_setup.tag = tag_matched;
            cfg_simvars_setup.head = hm_bem;
            cfg_simvars_setup.loc = [295,400];
            cfg_simvars_setup.cov_type = p.Results.cov_type;
            cfg_simvars_setup.cov_samples = p.Results.cov_samples;
            cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
            
            cfg = struct(...
                'sim_vars',             cfg_simvars,...
                'analysis_run_func',    @beamformer_analysis,...
                'parallel',             parallel,...
                'debug',                false);
            scripts(k).vars = {cfg};
            k = k+1;
            
        case 'mismatched'
            % ==== MISMATCHED LEADFIELD ====
            
            scripts(k).func = @sim_vars.run;
            cfg_simvars_setup = get_beamformer_config_set('sim_vars_mult_src_paper_mismatched');
            cfg_simvars_setup.data_file = data_files;
            cfg_simvars_setup.force = force;
            cfg_simvars_setup.tag = tag_mismatched;
            cfg_simvars_setup.head = [];
            cfg_simvars_setup.head.current = hm_3sphere;
            cfg_simvars_setup.head.actual = hm_bem;
            cfg_simvars_setup.loc = [295,400];
            cfg_simvars_setup.cov_type = p.Results.cov_type;
            cfg_simvars_setup.cov_samples = p.Results.cov_samples;
            cfg_simvars = get_beamformer_analysis_config(cfg_simvars_setup);
            cfg = struct(...
                'sim_vars',             cfg_simvars,...
                'analysis_run_func',    @beamformer_analysis,...
                'parallel',             parallel,...
                'debug',                false);
            scripts(k).vars = {cfg};
            k = k+1;
            
    end
end

%% Run the scripts
aet_run_scripts( scripts );

end