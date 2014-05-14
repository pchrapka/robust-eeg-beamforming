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
            input_power = zeros(n,1);
            input_power(1:n_in,:) = 1;
            
            % Simulate an output signal box that equal to the input
            bf_power = zeros(n,1);
            bf_power(1:n_out,:) = 1;
            
            [rmse, rms_input] = rms_error(bf_power, input_power);
            assertEqual(rmse, 0);
            assertElementsAlmostEqual(rms_input, 0.7071, 'absolute', 1e-4');
        end
        
        function test_box_2(self)
            n = 10;
            n_out = floor(n/2);
            n_in = floor(n/2);
            
            % Simulate an input signal box
            input_power = zeros(n,1);
            input_power(1:n_in,:) = 1;
            
            % Simulate an output signal box that equal to the input but
            % differs in magnitude
            bf_power = zeros(n,1);
            bf_power(1:n_out,:) = 2;
            
            [rmse, rms_input] = rms_error(bf_power, input_power);
            assertEqual(rmse, 0);
            assertElementsAlmostEqual(rms_input, 0.7071, 'absolute', 1e-4');
        end
        
        function test_box_3(self)
            n = 10;
            n_out = floor(3*n/4);
            n_in = floor(n/2);
            
            % Simulate an input signal box
            input_power = zeros(n,1);
            input_power(1:n_in,:) = 1;
            
            % Simulate an output signal box that is longer than the input
            bf_power = zeros(n,1);
            bf_power(1:n_out,:) = 2;
            
            [rmse, rms_input] = rms_error(bf_power, input_power);
            assertElementsAlmostEqual(rmse, 0.4472, 'absolute', 1e-4');
            assertElementsAlmostEqual(rms_input, 0.7071, 'absolute', 1e-4');
        end
        
        function tearDown(self)
            % Nothing to do
        end
        
    end
    
end