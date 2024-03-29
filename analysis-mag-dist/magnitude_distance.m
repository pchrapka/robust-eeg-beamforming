function [mag, dist] = magnitude_distance(cfg)
%MAGNITUDE_DISTANCE calculates the magnitude as a function of distance from
%the peak
%
%   cfg.head    IHeadModel obj, see HeadModel
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

%% Calculate the distances
% TODO The indices of the max may be transposed if bf_power is matrix
% Get the coordinates of the max
[~,r_max] = cfg.head.get_vertices('type','index','idx',col);

% Get the coordinates of the poi 
% idx = 1:length(poi);
[~,r] = cfg.head.get_vertices('type','index','idx',true(size(bf_power)));

d_vec = r - repmat(r_max,size(r,1),1);
d_vec = d_vec.^2;
d_mag = sqrt(sum(d_vec,2));

%% Set output vars
dist = d_mag;
mag = bf_power;

end