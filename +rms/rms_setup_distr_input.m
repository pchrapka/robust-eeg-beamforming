function input_power = rms_setup_distr_input(cfg)
%
%   cfg.head
%   cfg.true_peak

% Set up sources
radius = 4/100; % 4 cm
[distr_idx,distr_loc] = cfg.head.get_vertices('type','radius',...
    'center_idx',cfg.true_peak,'radius',radis);

[~,center_loc] = cfg.head.get_vertices('type','index','idx',cfg.true_peak);

% Distribution of source
sigma = radius/3; % 3 std devs to be within the radius
spatial_cov = (sigma^2)*ones(1,3);

% Allocate memory
n_vertices = size(cfg.head.data.GridLoc,1);
input_power = zeros(n_vertices,1);

for i=1:length(distr_idx)
    vertex_idx = distr_idx(i);
    input_power(vertex_idx) = gauss_distr(...
        distr_loc(i,:),center_loc,spatial_cov);
end

% Normalize the input
input_power = input_power/max(input_power);

end