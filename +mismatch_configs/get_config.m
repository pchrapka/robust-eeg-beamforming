function cfg = get_config(cfg_id, data)
%GET_CONFIG returns a mismatch config
%   GET_CONFIG(CFG_ID, DATA) returns a mismatch config specified by
%   CFG_ID. 
%   
%   NOTE New mismatched configs need to be added here explicity.

switch cfg_id
    case 'mismatch_1'
        n_channels = 256;
        epsilon = 50;
        Cx = mismatch_configs.create_mismatch_covariance(n_channels, epsilon);
    case 'mismatch_2'
        n_channels = 256;
        epsilon = 100;
        Cx = mismatch_configs.create_mismatch_covariance(n_channels, epsilon);
    otherwise
        error('mismatch_configs:get_config',...
            'unknown mismatch config');
end

cfg.Cx = Cx;
end
