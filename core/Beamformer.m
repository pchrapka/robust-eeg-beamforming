classdef Beamformer
    
    properties
        type;
        name;
        verbosity;
    end
    
    methods
        function obj = Beamformer()
            obj.type = 'Beamformer';
            obj.name = 'Beamformer';
            obj.verbosity = 0;
        end
    end
    
    methods (Abstract)
        data = inverse(obj, H, R)
    end
    
end