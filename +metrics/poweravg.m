function [output] = poweravg(cfg)
%POWERAVG calculates the average power of the signal
%   cfg.data
%       data matrix [channels/components samples]
%       or
%       cell array of data matrices [channels/components samples]
%
%   Output
%   ------
%   output.power
%       overall power of data matrix or cell array of overall power of each
%       data matrix

% Get the number of cells
if iscell(cfg.data)
    n_cells = length(cfg.data);
else
    n_cells = 1;
end

output.power = zeros(n_cells, 1);
for j=1:n_cells
    n_channels = size(cfg.data{j},1);
    n_samples = size(cfg.data{j},2);
    
    % Instead of tr( 1/n_samples XX^T )
    % 1/n_samples ( sum(channel(i)^T channel(i)))
    
    sum = 0;
    for i=1:n_channels
        sum = sum + cfg.data{j}(i,:)*cfg.data{j}(i,:)';
    end
    % Divide by the number of samples
    power = sum/n_samples;
    % Divide by the number of channels
    power = power/n_channels;
    
    % Save the power
    output.power(j) = power;
    
end



end