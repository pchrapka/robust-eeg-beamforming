function hm = load_hm_from_beamformer_file(bf_file,varargin)
%LOAD_HM_FROM_BEAMFORMER_FILE loads head model from beamformer data file
%
%   Parameters
%   ----------
%   hm_cached (string, default = '')
%       head model file that is already in memory, if it matches the head
%       model is not loaded

p = inputParser();
addParameter(p,'cached','',@ischar)
addParameter(p,'type','actual',@(x) any(validatestring(x,{'actual','current'})));
parse(p,varargin{:});

hm = [];

% load beamformer data
dinbf = load(bf_file);

% get head model config
if isfield(dinbf.source.head_cfg,p.Results.type)
    head_cfg = dinbf.source.head_cfg.(p.Results.type);
else
    head_cfg = dinbf.source.head_cfg;
end

if ~isempty(p.Results.cached)
    if isequal(head_cfg.file,p.Results.cached)
        fprintf('Head model already loaded\n');
        return;
    end
end
        

% load head model
hmfactory = HeadModel();
hm = hmfactory.createHeadModel(head_cfg.type,head_cfg.file);
hm.load();

end