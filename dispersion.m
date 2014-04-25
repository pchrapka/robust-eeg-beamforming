function [out, n_points] = dispersion(cfg)
%DISPERSION calculates dispersion around a source
%
%   cfg.head    head struct (see hm_get_data)
%   cfg.bf_out  beamformer output [components vertices samples]
%   cfg.sample_idx
%               sample index at which to calculate the dispersion

% TODO At what time do I do it? 
% - User-input?
% - Max response?

% Load the beamformer output
% data_bf = load(cfg.bf_out);
bf = cfg.bf_out;

% Double check that the beamformer output is correct
n_comp = size(bf,1);
if n_comp ~= 3
    error('rmvb:dispersion',...
        ['Check the size of the beamformer output ' num2str(n_comp)]);
end

%% Calculate the power at each index and the user's sample index
% Select the data at the user sample index
bf_select = squeeze(bf(:,:,cfg.sample_idx)); 

% Square each element
bf_select = bf_select.^2;
% Sum the components at each index and each time point
bf_sum = sum(bf_select,1);
% Take the square root of each element
bf_power = sqrt(bf_sum);

%% Find the max
if isvector(bf_power)
    row = 1;
    [max_power,col] = max(bf_power);
else
    warning('rmvb:dispersion',...
        'A matrix version has not been implemented');
    [~,row] = max(bf_power);
    [max_power,col] = max(max(bf_power));
end
% Normalize the power
bf_power = bf_power/max_power;
max_power = 1;

%% Select points of interest
% i.e. greater than half the max
% TODO Adjust this if you're planning on doing a matrix version
poi = bf_power > 0.5*max_power;

%% Calculate the distances

% cfg for hm_get_vertices
cfg_vert = [];
cfg_vert.head = cfg.head;
cfg_vert.type = 'index';

% TODO The indices of the max may be transposed if bf_power is matrix
cfg_vert.idx = col;
% Get the coordinates of the max
[~,r_max] = hm_get_vertices(cfg_vert);

% Get the coordinates of the poi 
% idx = 1:length(poi);
cfg_vert.idx = poi;%.*idx;
[~,r] = hm_get_vertices(cfg_vert);

d_vec = r - repmat(r_max,size(r,1),1);
d_vec = d_vec.^2;
d_mag = sqrt(sum(d_vec,2));

%% Calculate the dispersion
% NOTE I'm not sure about the validity of this approach, it's close to
% something but not exactly
% It's similar to an estimate of the std dev of a distribution, where each
% sample has a different weight/probability but the weight is not a
% probability distribution
% http://en.wikipedia.org/wiki/Standard_deviation#Definition_of_population_
% values
out = sqrt(sum((d_mag.^2).*bf_power(poi)'));
n_points = sum(poi);
end