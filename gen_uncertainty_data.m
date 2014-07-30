function gen_uncertainty_data(cfg)
%GEN_UNCERTAINTY_DATA Generates the uncertainty matrices for the anisotropic rmv
%   GEN_UNCERTAINTY_DATA(CFG)
%
%   cfg.head    specifices the head models
%     actual    cfg specifying the actual head model, see hm_get_data
%       type    'fieldtrip' or 'brainstorm'
%       file    name of file to be retrieved
%     estimate  cfg specifying the estimate head model, see hm_get_data
%       type    'fieldtrip' or 'brainstorm'
%       file    name of file to be retrieved
%
%   cfg.force   forces recreation of the uncertainty data

% NOTE This will create a rather large file ex. 500 vertices, 256 electrodes =
% 700 MB file

% Set the output dir
output_dir = 'output';

% Set the output file name
[~,actual_name,~,~] = util.fileparts(cfg.head.actual.file);
[~,est_name,~,~] = util.fileparts(cfg.head.estimate.file);

out_file = ['uncert_' actual_name '_' est_name '.mat'];
data_file = fullfile(output_dir, out_file);

% Check if it exists
if ~exist(data_file, 'file') || cfg.force
    fprintf('Generating: %s\n',out_file);
    
    % Get the head model data
    H_actual = hm_get_data(cfg.head.actual);
    H_estimate = hm_get_data(cfg.head.estimate);
    
    % Generate the uncertainty data
    A = aet_analysis_rmv_uncertainty_create(H_actual.head, H_estimate.head);
    
    % Save the data
    head = cfg.head;
    save(data_file, 'A', 'head');
    
end

end