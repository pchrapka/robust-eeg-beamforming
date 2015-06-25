function data_limit = get_beampattern_data_limit(files, scale)
%
%   files
%       cell array of file names
%   scale
%       globalabsolute    
%           0   - MAX, over all group data
%       globalabsolute-dist    
%           0   - MAX of closest 25% of vertices, over all group data
%       globalrelative    
%           MIN - MAX, over all group data
%       globalrelative-dist    
%           MIN - MAX of closest 25% of vertices, over all group data
%       mmabsolute
%           0   - MAX, over all data, matched and mismatched
%       mmabsolute-dist
%           0   - MAX of closest 25% of vertices, over all data, matched and mismatched

% Load the data
beampattern_data = cell(length(files));
for i=1:length(files)
    din = load(files{i});
    if ~isempty(strfind(scale, 'dist'))
        bp_data = din.data.beampattern;
        distances = din.data.distances;
        % Combine the data
        data = [distances(:) bp_data(:)];
        % Sort data based on distance
        data = sortrows(data,1);
        % Calculate 25% of the largest distance
        dist_min = 0.25*max(distances);
        % Count the number of distances
        npoints = sum(distances < dist_min);
        % Get max from sorted beampattern data that corresponds to the
        % points in the 25th percentile of distances from the source
        beampattern_data{i} = data(1:npoints,2);
    else
        beampattern_data{i} = din.data.beampattern;
    end
end

% Process data to determine global min and max
[y_min, y_max] = lumberjack.get_data_limit(beampattern_data);
clear beampattern_data;

% Set the data limit
switch(scale)
    case {'globalrelative','globalrelative-dist'}
        data_limit = [y_min y_max];
    case {'globalabsolute','globalabsolute-dist'}
        data_limit = [0 y_max];
    case {'mmabsolute','mmabsolute-dist'}
        % Same as globalabsolute, except over matched and mismatched files,
        % need a different tag for saved files
        data_limit = [0 y_max];
    otherwise
        error(['reb:' mfilename],...
            'unknown scale type %s', scale);
end

end