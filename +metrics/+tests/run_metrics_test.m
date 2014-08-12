classdef run_metrics_test < TestCase
    
    properties
    end
    
    methods
        function self = run_metrics_test(name)
            self = self@TestCase(name);
        end
        
        function setUp(self)
            % Nothing to do
        end

        function test_basic(self)
            cfg = [];
            cfg.name = 'snr';
            cfg.snr.S = zeros(32,100);
            cfg.snr.N = zeros(32,100);
            cfg.snr.W = zeros(32,3);
            output = metrics.run_metrics(cfg);
            assertTrue(isnumeric(output),...
                'Expected a number');
        end
        
        function test_error(self)
            cfg = [];
            cfg.name = 'test';
            cfg.test = '';
            assertExceptionThrown(...
                @() metrics.run_metrics(cfg), 'metrics:run_metrics');
        end
       
        
        function tearDown(self)
            % Nothing to do
        end
        
    end
    
end