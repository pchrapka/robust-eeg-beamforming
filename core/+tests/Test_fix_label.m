classdef Test_fix_label < matlab.unittest.TestCase
    
    properties
    end
    
    methods (Test)
        function test_1(testCase)
            beamformer = 'rmv_eig_pre_cov_1_epsilon_1-000000e-04_3sphere';
            out = util.fix_label(beamformer);
            testCase.verifyEqual(out,'RMVB eig pre cov, Q=2, \epsilon = 1.000000e-04');
        end
        
        function test_2(testCase)
            beamformer = 'rmv_eig_pre_cov_1_epsilon_1_3sphere';
            out = util.fix_label(beamformer);
            testCase.verifyEqual(out,'RMVB eig pre cov, Q=2, \epsilon = 1');
        end
        
        function test_3(testCase)
            beamformer = 'rmv_aniso_3sphere';
            out = util.fix_label(beamformer);
            testCase.verifyEqual(out,'RMVB anisotropic');
        end
        
        function test_4(testCase)
            beamformer = 'lcmv_3sphere';
            out = util.fix_label(beamformer);
            testCase.verifyEqual(out,'MVB');
        end
        
        function test_5(testCase)
            beamformer = 'lcmv_eig_filter_0_3sphere';
            out = util.fix_label(beamformer);
            testCase.verifyEqual(out,'MVB eig filter, Q=1');
        end
        
        function test_6(testCase)
            beamformer = 'lcmv_reg_eig_3sphere';
            out = util.fix_label(beamformer);
            testCase.verifyEqual(out,'MVB regularized');
        end
        
        function test_7(testCase)
            beamformer = 'lcmv_eig_cov_0_3sphere';
            out = util.fix_label(beamformer);
            testCase.verifyEqual(out,'MVB eig cov, Q=1');
        end
        
        function test_8(testCase)
            beamformer = 'lcmv_inv_eig_cov_0_3sphere';
            out = util.fix_label(beamformer);
            testCase.verifyEqual(out,'MVB inv eig cov, Q=1');
        end
    end
end