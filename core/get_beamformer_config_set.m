function out = get_beamformer_config_set(name)
% function [bf_config,loc,hm] = get_beamformer_config_set(name)

out = [];

% set default head model
hmfactory = HeadModel();
out.head = hmfactory.createHeadModel('brainstorm', 'head_Default1_3sphere_500V.mat');

% set default locations
out.loc = 1:501;

switch name
    case 'sim_vars_test'
        
        % Beamformer locations
        out.loc = {1:2};
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',2},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_test_rmv_aniso'
        
        % Beamformer locations
        out.loc = {1:2};
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','aniso',true},...
            {'BeamformerRMV','aniso',true,'eig_type','eig post','ninterference',1}};
        
    case 'sim_vars_test_mismatch'
       
        % Beamformer locations
        out.loc = {1:2};
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',2},...
            {'BeamformerLCMV','regularization','eig'}};
        
        % Mismatch covariance matrix
        out.perturb_config = {...
            'perturb_1',...
            'perturb_2'};
        
    case 'sim_vars_lcmv_basic'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_lcmv'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',2},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',3},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_lcmv_mismatch'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',2},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',3},...
            {'BeamformerLCMV','regularization','eig'}};
        
        % Mismatch covariance matrix
        out.perturb_config = {...
            'perturb_1',...
            'perturb_2'};   
        
    case 'sim_vars_rmv'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',150},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','epsilon',250},...
            {'BeamformerRMV','epsilon',300},...
            {'BeamformerRMV','epsilon',350},...
            {'BeamformerRMV','epsilon',400}};      
        
    case 'sim_vars_rmv_coarse'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','epsilon',300},...
            {'BeamformerRMV','epsilon',400}};
        
    case 'sim_vars_rmv_coarse_mismatch'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','epsilon',300},...
            {'BeamformerRMV','epsilon',400}};
        
        % Mismatch covariance matrix
        out.perturb_config = {...
            'perturb_1',...
            'perturb_2'};      
        
    case 'sim_vars_rmv_eig_coarse'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',50},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',200},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',300},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',400}};
        
    case 'sim_vars_rmv_eig_coarse_mismatch'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',50},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',200},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',300},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',400}};
        
        % Mismatch covariance matrix
        out.perturb_config = {...
            'perturb_1',...
            'perturb_2'};
        
    case 'sim_vars_rmv_eig_experiment'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',0.0001},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',0.001},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',0.01},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',0.1},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',1}};
        
    case 'sim_vars_single_src_paper_matched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',20},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',20},...
            ...{'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',20},... same performance as LCMV eig cov
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            ...{'BeamformerLCMV','eig_type','eig filter','ninterference',0},... same performance as LCMV eig cov
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_single_src_paper_mismatched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',150},...
            {'BeamformerRMV','epsilon',175},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',150},...
            ...{'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',150},... same performance as LCMV eig cov
            {'BeamformerRMV','aniso',true},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre cov','ninterference',0},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            ...{'BeamformerLCMV','eig_type','eig filter','ninterference',0},... same performance as LCMV eig cov
            {'BeamformerLCMV','regularization','eig'}};    
        
    case 'sim_vars_single_src_eig_variations_mismatched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',150},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','aniso',true},...
            {'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',50},...
            {'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',200},...
            {'BeamformerRMV','aniso',true,'eig_type','eig post','ninterference',0},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',0.0001},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',0.001},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',0.01},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',0.1},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',1},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',10},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',100},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre cov','ninterference',0},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',0.0001},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',0.001},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',0.01},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',0.1},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',1},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',10},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',1000},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre leadfield','ninterference',0},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_mult_src_basic_matched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            {'BeamformerRMV','epsilon',0.01},...
            {'BeamformerRMV','epsilon',5}};
        
    case 'sim_vars_mult_src_basic_mismatched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            ...{'BeamformerRMV','epsilon',0.01},...
            ...{'BeamformerRMV','epsilon',5},...
            {'BeamformerRMV','aniso',true}};
        
    case 'sim_vars_mult_src_paper_matched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',20},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',20},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',20},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',20},... temp
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},... temp
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},... temp
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_mult_src_paper_mismatched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',125},...
            {'BeamformerRMV','epsilon',150},...
            {'BeamformerRMV','epsilon',175},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',150},...temp
            {'BeamformerRMV','aniso',true},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre cov','ninterference',0},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre cov','ninterference',1},...
            {'BeamformerRMV','aniso',true,'eig_type','eig post','ninterference',1},...temp
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},... temp
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},... temp
            {'BeamformerLCMV','regularization','eig'}};    
        
    case 'sim_vars_mult_src_extended_matched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',10},...
            {'BeamformerRMV','epsilon',20},...
            {'BeamformerRMV','epsilon',30},...
            {'BeamformerRMV','epsilon',40},...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',20},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',30},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',40},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',20},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',30},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',40},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',20},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',30},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',40},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',20},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',30},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',40},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig leadfield','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig leadfield','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig cov leadfield','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov leadfield','ninterference',1},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_mult_src_extended_mismatched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',150},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','epsilon',250},...
            {'BeamformerRMV','epsilon',300},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',200},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',200},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',200},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',200},...
            {'BeamformerRMV','aniso',true},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre cov','ninterference',0},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre cov','ninterference',1},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre leadfield','ninterference',0},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre leadfield','ninterference',1},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig leadfield','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig leadfield','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig cov leadfield','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov leadfield','ninterference',1},...
            {'BeamformerLCMV','regularization','eig'}};    
        
    case 'sim_vars_mult_src_rmvb_eig_variations_mismatched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',150},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','aniso',true},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',200},...
            {'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',50},...
            {'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig post','ninterference',0,'epsilon',200},...
            {'BeamformerRMV','aniso',true,'eig_type','eig post','ninterference',0},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',0.0001},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',0.001},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',0.01},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',0.1},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',1},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',10},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',0,'epsilon',100},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre cov','ninterference',0},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',0.0001},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',0.001},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',0.01},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',0.1},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',1},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',10},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',0,'epsilon',1000},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre leadfield','ninterference',0},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',50},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',150},...
            {'BeamformerRMV','eig_type','eig post','ninterference',1,'epsilon',200},...
            {'BeamformerRMV','aniso',true,'eig_type','eig post','ninterference',1},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',0.0001},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',0.001},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',0.01},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',0.1},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',1},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',10},...
            {'BeamformerRMV','eig_type','eig pre cov','ninterference',1,'epsilon',100},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre cov','ninterference',1},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',0.0001},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',0.001},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',0.01},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',0.1},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',1},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',10},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',100},...
            {'BeamformerRMV','eig_type','eig pre leadfield','ninterference',1,'epsilon',1000},...
            {'BeamformerRMV','aniso',true,'eig_type','eig pre leadfield','ninterference',1},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',1},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_mult_src_pinv_variations_mismatched'
                % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',1},...
            {'BeamformerLCMV','regularization','eig'},...
            {'BeamformerLCMV','pinv',false},...
            {'BeamformerLCMV','pinv',false,'eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','pinv',false,'eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','pinv',false,'eig_type','eig cov','ninterference',0},...
            {'BeamformerLCMV','pinv',false,'eig_type','eig cov','ninterference',1},...
            {'BeamformerLCMV','pinv',false,'regularization','eig'}};
        
    case 'sim_vars_mult_src_lcmv_eigvariations'
                % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',2},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',5},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',10},...
            {'BeamformerLCMV','eig_type','eig cov','ninterference',20},...
            {'BeamformerLCMV','eig_type','eig cov','regularization','eig','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig cov','regularization','eig','ninterference',1},...
            {'BeamformerLCMV','eig_type','eig cov','regularization','eig','ninterference',2},...
            {'BeamformerLCMV','eig_type','eig cov','regularization','eig','ninterference',5},...
            {'BeamformerLCMV','eig_type','eig cov','regularization','eig','ninterference',10},...
            {'BeamformerLCMV','eig_type','eig cov','regularization','eig','ninterference',20},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_distr_src_paper_matched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',10},...
            {'BeamformerRMV','epsilon',20},...
            {'BeamformerRMV','epsilon',30},...
            {'BeamformerRMV','epsilon',40},...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_distr_src_paper_mismatched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',150},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','epsilon',250},...
            {'BeamformerRMV','epsilon',300},...
            {'BeamformerRMV','aniso',true},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_mult_src_beampattern_matched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',10},...
            {'BeamformerRMV','epsilon',20},...
            {'BeamformerRMV','epsilon',30},...
            {'BeamformerRMV','epsilon',40},...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','regularization','eig'}};
        
    case 'sim_vars_mult_src_beampattern_mismatched'
        
        % Beamformer configs
        out.beamformer_config = {...
            {'BeamformerRMV','epsilon',50},...
            {'BeamformerRMV','epsilon',100},...
            {'BeamformerRMV','epsilon',150},...
            {'BeamformerRMV','epsilon',200},...
            {'BeamformerRMV','epsilon',250},...
            {'BeamformerRMV','epsilon',300},...
            {'BeamformerRMV','aniso',true},...
            {'BeamformerLCMV'},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',0},...
            {'BeamformerLCMV','eig_type','eig filter','ninterference',1},...
            {'BeamformerLCMV','regularization','eig'}};            

    otherwise
        error('unknown beamformer variation set');
end