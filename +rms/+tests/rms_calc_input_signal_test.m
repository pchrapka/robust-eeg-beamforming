classdef rms_calc_input_signal_test < TestCase
    
    properties
    end
    
    methods
        function self = rms_calc_input_signal_test(name)
            self = self@TestCase(name);
        end
        
        function setUp(self)
            % Nothing to do
            aet_init();
            util.update_aet();
        end

        function test_single_src_1(self)
            cfg = [];
            cfg.sim_name = 'sim_data_bem_1_100t';
            cfg.source_name = 'single_cort_src_1';
            input_signal = rms.rms_calc_input_signal(cfg);
            % Check if we have 1 source in the output
            % Sum along the orientation and then the time axis
            a = sum(sum(input_signal,1),3);
            % Select the non-zero sources
            a = a(a > 0);
            assertEqual(length(a), 1);
        end
        
        function test_mult_src_10(self)
            cfg = [];
            cfg.sim_name = 'sim_data_bem_1_100t';
            cfg.source_name = 'mult_cort_src_10';
            input_signal = rms.rms_calc_input_signal(cfg);
            % Check if we have 2 sources in the output
            % Sum along the orientation and then the time axis
            a = sum(sum(input_signal,1),3);
            % Select the non-zero sources
            a = a(a > 0);
            assertEqual(length(a), 2);
        end
        
        function test_distr_src_2(self)
            cfg = [];
            cfg.sim_name = 'sim_data_bem_1_100t';
            cfg.source_name = 'distr_cort_src_2';
            input_signal = rms.rms_calc_input_signal(cfg);
            % Check if we have 33 sources in the output
            % Sum along the orientation and then the time axis
            a = sum(sum(input_signal,1),3);
            % Select the non-zero sources
            a = a(a > 0);
            assertEqual(length(a), 33);
        end
        
        function tearDown(self)
            % Nothing to do
        end
        
    end
    
end