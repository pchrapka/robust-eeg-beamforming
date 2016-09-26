function args = get_view_beampattern_args(name,type,scale)
%GET_BEAMPATTERN_ARGS returns arguments for view_beampattern
%   GET_BEAMPATTERN_ARGS(name,scale) returns arguments for view_beampattern
%
%   Input
%   -----
%   name (string)
%       name for set of arguments, options: default
%   type (string)
%       beampattern type
%   scale (string)
%       beampattern scale


switch name
    case 'default'
        args_scale = {'scale',scale};
        switch scale
            case 'mad'
                args_scale = [args_scale {'mad_multiple',8}];
        end
        
        
        args_type = {'type',type};
        switch type
            case 'beampattern'
                args_type = [args_type {'db',false,'normalize',false}];
            case 'beampattern3d'
                args_type = [args_type {}];
            otherwise
                error('unknown beampattern type: %s', type)
        end
        
        args = [args_scale args_type];
    otherwise
        error('unknown beampattern args set name: %s',name);
end

end