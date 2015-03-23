function data_limit = get_beampattern_data_limit(files, scale)
%
%   files
%       cell array of file names
%   scale
%       globalabsolute    
%           0   - MAX, over all group data
%       globalrelative    
%           MIN - MAX, over all group data
%       mmabsolute
%           0   - MAX, over all data, matched and mismatched

% Load the data
beampattern_data = cell(length(files));
for i=1:length(files)
    din = load(files{i});
    beampattern_data{i} = din.data.beampattern;
end

% Process data to determine global min and max
[y_min, y_max] = lumberjack.get_data_limit(beampattern_data);
clear beampattern_data;

% Set the data limit
switch(scale)
    case 'globalrelative'
        data_limit = [y_min y_max];
    case 'globalabsolute'
        data_limit = [0 y_max];
    case 'mmabsolute'
        % Same as globalabsolute, except over matched and mismatched files,
        % need a different tag for saved files
        data_limit = [0 y_max];
    otherwise
        error(['reb:' mfilename],...
            'unknown scale type %s', scale);
end

end