classdef rms_error_test < TestCase
    
    properties
    end
    
    methods
        function self = rms_error_test(name)
            self = self@TestCase(name);
        end
        
        function setUp(self)
            % Nothing to do
        end

        function test_box_1(self)
            n = 10;
            n_out = floor(n/2);
            n_in = floor(n/2);
            
            % Simulate an input signal box
            input = zeros(n,1);
            input(1:n_in,:) = 1;
            
            % Simulate an output signal box that equal to the input
            bf_out = zeros(n,1);
            bf_out(1:n_out,:) = 1;
            
            [rmse, rms_input, ~] = rms.rms_error(bf_out, input);
            assertEqual(rmse, 0);
            assertElementsAlmostEqual(rms_input, 0.7071, 'absolute', 1e-4');
        end
        
        function test_box_2(self)
            n = 10;
            n_out = floor(n/2);
            n_in = floor(n/2);
            
            % Simulate an input signal box
            input = zeros(n,1);
            input(1:n_in,:) = 1;
            
            % Simulate an output signal box that equal to the input but
            % differs in magnitude
            bf_out = zeros(n,1);
            bf_out(1:n_out,:) = 2;
            
            [rmse, rms_input, ~] = rms.rms_error(bf_out, input);
            assertEqual(rmse, 0);
            assertElementsAlmostEqual(rms_input, 0.7071, 'absolute', 1e-4');
        end
        
        function test_box_irregular_4(self)
            n = 10;
            n_mid = floor(n/2);
            
            % Simulate an input signal box
            input = zeros(n,1);
            input(1:n,:) = 1.5;
            
            % Simulate an output signal box that is longer than the input
            bf_out = zeros(n,1);
            bf_out(1:n_mid,:) = 2;
            bf_out(n_mid+1:end,:) = 1;
            
            [rmse, rms_input, ~] = rms.rms_error(bf_out, input);
            assertElementsAlmostEqual(rmse, 0.4743, 'absolute', 1e-4');
            assertElementsAlmostEqual(rms_input, 1.5000, 'absolute', 1e-4');
        end
        
        function tearDown(self)
            % Nothing to do
        end
        
    end
    
end