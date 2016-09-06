classdef TestBeamformerLCMV < matlab.unittest.TestCase
    % TestBeamformerLCMV
    
    properties
    end
    
    methods (TestClassSetup)
        function setup(testCase)
            warning('on','all');
        end
    end
    
    methods (TestClassTeardown)
    end
    
    methods (Test)
        
        function test_lcmv(testCase)
            bf = BeamformerLCMV();

            % check output
            testCase.verifyEqual(bf.type, 'lcmv');
            testCase.verifyEqual(bf.name, 'lcmv');
            testCase.verifyEqual(bf.lambda, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, false);
            testCase.verifyEqual(bf.n_interfering_sources, 0);
            testCase.verifyEqual(bf.multiplier, 0.005);
            testCase.verifyEqual(bf.regularization, 'none');
        end
        
        function test_lcmv_eig_0(testCase)
            nint = 0;
            bf = BeamformerLCMV('eigenspace',true);

            % check output
            testCase.verifyEqual(bf.type, 'lcmv_eig');
            testCase.verifyEqual(bf.name, sprintf('lcmv eig %d',nint));
            testCase.verifyEqual(bf.lambda, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, true);
            testCase.verifyEqual(bf.n_interfering_sources, nint);
            testCase.verifyEqual(bf.multiplier, 0.005);
            testCase.verifyEqual(bf.regularization, 'none');
        end
        
        function test_lcmv_eig_error(testCase)
            nint = 2;
            testCase.verifyError(@() BeamformerLCMV('ninterference',nint),...
                'BeamformerLCMV:BeamformerLCMV');
        end
        
        function test_lcmv_eig_many(testCase)
            nint = 3;
            bf = BeamformerLCMV('eigenspace',true,'ninterference',nint);

            % check output
            testCase.verifyEqual(bf.type, 'lcmv_eig');
            testCase.verifyEqual(bf.name, sprintf('lcmv eig %d',nint));
            testCase.verifyEqual(bf.lambda, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, true);
            testCase.verifyEqual(bf.n_interfering_sources, nint);
            testCase.verifyEqual(bf.multiplier, 0.005);
            testCase.verifyEqual(bf.regularization, 'none');
        end
        
        function test_lcmv_reg(testCase)
            bf = BeamformerLCMV('regularization','eig');

            % check output
            testCase.verifyEqual(bf.type, 'lcmv_reg');
            testCase.verifyEqual(bf.name, sprintf('lcmv reg %s','eig'));
            testCase.verifyEqual(bf.lambda, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, false);
            testCase.verifyEqual(bf.n_interfering_sources, 0);
            testCase.verifyEqual(bf.multiplier, 0.005);
            testCase.verifyEqual(bf.regularization, 'eig');
        end
    end
end