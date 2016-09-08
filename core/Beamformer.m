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
        %INVERSE compute spatial filter
        
        data = beamformer_output(obj, W, signal)
        %BEAMFORM_OUTPUT compute beamformer output
    end
    
    methods
        function data = output(obj, W, signal )
            %OUTPUT compute beamformer output
            %   OUTPUT(obj, W, signal) compute beamformer output
            %
            %   Input
            %   -----
            %   signal (matrix)
            %       signal matrix [channels timepoints]
            %   W (matrix)
            %       spatial filter, [channels components], output of
            %       inverse()
            %
            %   Output
            %   ------
            %   data            
            %       dipole moment over time [components timepoints]
            
            data = W'*signal;
            
        end
    end
    
end