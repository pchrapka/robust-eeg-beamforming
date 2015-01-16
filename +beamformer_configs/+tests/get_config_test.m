classdef get_config_test < TestCase
    
    properties
        % Beamformer config
        cfg;
    end
    
    methods
        function self = get_config_test(name)
            self = self@TestCase(name);
        end
        
        function setUp(self)
            % Nothing to do
        end
        
        function test_rmv_aniso(self)
            % Fudge some data
            n_channels = 16;
            data = [];
            data.R = zeros(n_channels);
            out = beamformer_configs.get_config(...
                'rmv','aniso',true,'data',data);

            % Check output
            assertEqual(out.solver, 'yalmip');
            assertEqual(out.type, 'rmv');
            assertEqual(out.name, 'rmv aniso');
            assertEqual(out.A, {});
        end
        
        function test_rmv_aniso_eig(self)
            % Fudge some data
            n_channels = 16;
            data = [];
            data.R = zeros(n_channels);
            out = beamformer_configs.get_config(...
                'rmv','aniso',true,'eig',1,'data',data);
            
            assertEqual(out.solver, 'yalmip');
            assertEqual(out.type, 'rmv');
            assertEqual(out.name, 'rmv aniso eig 1');
            assertEqual(out.A, {});
            assertEqual(out.eigenspace, true);
            assertEqual(out.n_interfering_sources, 1);
        end
        
        function tearDown(self)
            % Nothing to do
        end
        
    end
    
end