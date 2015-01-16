function cfg = prep_source_data(cfg)
%PREP_SOURCE_DATA preps source analysis data for import to Brainstorm
%   PREP_SOURCE_DATA(CFG) preps data from source analysis to import to
%   Brainstorm. More specifically, it replaces the ImageGridAmp field in
%   cfg.source with the beamformer's output.
%
%   Input
%   cfg
%       beamformer_data_file
%       source
%
%   Output
%   cfg     same struct as before, with the following fields updated
%       source      updated ImageGridAmp with the beamformer output

data_in = load(cfg.beamformer_data_file);
source_new = data_in.source.beamformer_output;

% Extract variables
n_components = size(source_new,1);
n_vertices = size(source_new,2);
n_time = size(source_new,3);

% Reshape the data
cfg.source.ImageGridAmp = reshape(source_new,...
    [n_components*n_vertices n_time]);

% Check for nans, set them to zero
nans_idx = isnan(cfg.source.ImageGridAmp);
n_nans = sum(sum(nans_idx));
if n_nans > 0
    fprintf('\tFound %d NaNs\n',n_nans);
end
cfg.source.ImageGridAmp(isnan(cfg.source.ImageGridAmp)) = 0;

end