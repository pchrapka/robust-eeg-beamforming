function cfg = get_config(cfg_id, data)
%GET_CONFIG returns a perturbed config
%   GET_CONFIG(CFG_ID, DATA) returns a perturbed config specified by
%   CFG_ID. 
%   
%   NOTE New perturbed configs need to be added here explicity.

switch cfg_id
    case 'perturb_1'
        n_channels = 256;
        epsilon = 50;
        Cx = perturb_configs.create_mismatch_covariance(n_channels, epsilon);
    case 'perturb_2'
        n_channels = 256;
        epsilon = 100;
        Cx = perturb_configs.create_mismatch_covariance(n_channels, epsilon);
    otherwise
        error('perturb_configs:get_config',...
            'unknown mismatch config');
end

cfg.Cx = Cx;
end
