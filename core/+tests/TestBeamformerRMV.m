classdef TestBeamformerRMV < matlab.unittest.TestCase
    % TestBeamformerRMV
    
    properties
    end
    
    properties (TestParameter)
        eig_param = {...
                'eig pre cov',...
                'eig pre leadfield',...
                'eig post',...
                };
    end
    
    methods (TestClassSetup)
        function setup(testCase)
        end
    end
    
    methods (TestClassTeardown)
    end
    
    methods (Test)
        
        function test_rmv_iso(testCase)
            epsilon = 5;
            bf = BeamformerRMV(...
                'epsilon',5);

            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
                        testCase.verifyEqual(bf.name,...
                sprintf('rmv epsilon %d',epsilon));
            testCase.verifyEqual(bf.epsilon, epsilon);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, 'none');
            testCase.verifyEqual(bf.n_interfering_sources, 0);
        end
        
        function test_rmv_eig(testCase,eig_param)
            epsilon = 5;
            nint = 4;
            bf = BeamformerRMV(...
                'epsilon',epsilon,'eig_type',eig_param,'ninterference',nint);

            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
            testCase.verifyEqual(bf.name,...
                sprintf('rmv %s %d epsilon %d',eig_param,nint,epsilon));
            testCase.verifyEqual(bf.epsilon, epsilon);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, eig_param);
            testCase.verifyEqual(bf.n_interfering_sources, nint); 
        end
        
        function test_rmv_eig2(testCase,eig_param)
            % if ninterfering sources is omitted
            epsilon = 5;
            nint = 0;
            bf = BeamformerRMV(...
                'epsilon',epsilon,'eig_type',eig_param);

            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
            testCase.verifyEqual(bf.name,...
                sprintf('rmv %s %d epsilon %d',eig_param,nint,epsilon));
            testCase.verifyEqual(bf.epsilon, epsilon);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, eig_param);
            testCase.verifyEqual(bf.n_interfering_sources, nint); 
        end
        
        function test_rmv_eig_none(testCase)
            epsilon = 5;
            eig_param = 'none';
            nint = 0;
            bf = BeamformerRMV(...
                'epsilon',epsilon,'eig_type',eig_param);

            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
            testCase.verifyEqual(bf.name,...
                sprintf('rmv epsilon %d',epsilon));
            testCase.verifyEqual(bf.epsilon, epsilon);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, eig_param);
            testCase.verifyEqual(bf.n_interfering_sources, nint); 
        end
        
        function test_rmv_eig_error(testCase)
            nint = 2;
            testCase.verifyError(@()...
                BeamformerRMV(...
                'ninterference',nint),...
                'BeamformerRMV:BeamformerRMV');
        end
        
        function test_rmv_aniso(testCase)
            bf = BeamformerRMV(...
                'aniso',true);

            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
            testCase.verifyEqual(bf.name, 'rmv aniso');
            testCase.verifyEqual(bf.epsilon, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, 'none');
            testCase.verifyEqual(bf.n_interfering_sources, 0);
        end
        
        function test_rmv_aniso_eig(testCase,eig_param)
            nint = 4;
            bf = BeamformerRMV(...
                'aniso',true,'eig_type',eig_param,'ninterference',nint);
            
            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
            testCase.verifyEqual(bf.name,...
                sprintf('rmv aniso %s %d',eig_param,nint));
            testCase.verifyEqual(bf.epsilon, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, eig_param);
            testCase.verifyEqual(bf.n_interfering_sources, nint); 
        end
        
        function test_rmv_aniso_eig2(testCase,eig_param)
            % if ninterfering sources is omitted
            nint = 0;
            bf = BeamformerRMV(...
                'aniso',true,'eig_type',eig_param);

            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
            testCase.verifyEqual(bf.name,...
                sprintf('rmv aniso %s %d',eig_param,nint));
            testCase.verifyEqual(bf.epsilon, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, eig_param);
            testCase.verifyEqual(bf.n_interfering_sources, nint); 
        end
        
        function test_rmv_aniso_eig_none(testCase)
            eig_param = 'none';
            nint = 0;
            bf = BeamformerRMV(...
                'aniso',true,'eig_type',eig_param);

            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
            testCase.verifyEqual(bf.name, 'rmv aniso');
            testCase.verifyEqual(bf.epsilon, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, eig_param);
            testCase.verifyEqual(bf.n_interfering_sources, nint); 
        end
        
        function test_rmv_aniso_eig_error(testCase)
            nint = 2;
            testCase.verifyError(@()...
                BeamformerRMV(...
                'aniso',true,'ninterference',nint),...
                'BeamformerRMV:BeamformerRMV');
        end
        
        function test_rmv_aniso_epsilon(testCase)
            epsilon = 10;
            bf = BeamformerRMV(...
                'aniso',true,'epsilon',epsilon);

            % check output
            testCase.verifyEqual(bf.solver, 'yalmip');
            testCase.verifyEqual(bf.type, 'rmv');
            testCase.verifyEqual(bf.name, 'rmv aniso');
            testCase.verifyEqual(bf.epsilon, 0);
            testCase.verifyEqual(bf.verbosity, 0);
            testCase.verifyEqual(bf.eigenspace, 'none');
            testCase.verifyEqual(bf.n_interfering_sources, 0);
        end
        
    end
    
end