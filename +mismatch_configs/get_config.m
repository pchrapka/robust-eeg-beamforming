function cfg = get_config(cfg_id, data)
%GET_CONFIG returns a mismatch config
%   GET_CONFIG(CFG_ID, DATA) returns a mismatch config specified by
%   CFG_ID. 
%   
%   NOTE New mismatched configs need to be added here explicity.

switch cfg_id
    case 'mismatch_1'
        A = 50;
        file_name = fullfile('+mismatch_configs','cx_256.mat');
        data_in = load(file_name);
        Cx = data_in.Cx;
    case 'mismatch_2'
        A = 100;
        file_name = fullfile('+mismatch_configs','cx_256.mat');
        data_in = load(file_name);
        Cx = data_in.Cx;
    otherwise
        error('mismatch_configs:get_config',...
            'unknown mismatch config');
end

cfg.Cx = A*Cx;
end
