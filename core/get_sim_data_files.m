function out = get_sim_data_files(varargin)
%GET_SIM_DATA_FILES returns data based on parameters
%   GET_SIM_DATA_FILES(...) returns data based on parameters
%
%   Parameters
%   ----------
%   sim (string)
%       simulation config name
%   source (string)
%       source config name
%   snr (vector)
%       snr range
%   iterations (vector)
%       iteration range

p = inputParser();
addParameter(p,'sim','',@ischar);
addParameter(p,'source','',@ischar);
addParameter(p,'iterations',1,@isvector);
addParameter(p,'snr',0,@isvector);
p.parse(varargin{:})

count = 1;
out = cell(1,length(p.Results.snr)*length(p.Results.iterations));
for i=1:length(p.Results.snr)
    for j=1:length(p.Results.iterations)
        data_set = SimDataSetEEG(...
            p.Results.sim,...
            p.Results.source,...
            p.Results.snr(i),...
            'iter',p.Results.iterations(j));
        out{count} = data_set.get_full_filename();    
        count = count + 1;
    end
end

end