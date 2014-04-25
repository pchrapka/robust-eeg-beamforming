classdef dispersion_test < TestCase
    
    properties
    end
    
    methods
        function self = dispersion_test(name)
            self = self@TestCase(name);
        end
        
        function setUp(self)
            % Nothing to do
        end
        
%         function test_dispersion_func(self)
%             cfg = [];
%             cfg.head.type = 'brainstorm';
%             cfg.head.file = 'head_Default1_3sphere_500V.mat';
%             cfg.bf_out = ['C:\Users\Phil\My Projects\'...
%                 'robust-eeg-beamforming-paper\output\'...
%                 'sim_data_bem_1_100t\mult_cort_src_10\'...
%                 '0_1_rmv_aniso_3sphere_mini.mat'];
%             cfg.sample_idx = 120;
%             out = dispersion(cfg);
%             
% %             assertEqual(out.solver, 'yalmip');
%         end
        
        function test_gaussian(self)
            sigma = 2;
            x = -3*sigma:0.01:3*sigma;
            x = x(:);
            mu = 0;
            y = normpdf(x,mu,sigma);
%             y = y/max(y);
            
            cfg = [];
            cfg.head.GridLoc = [x zeros(size(x)) zeros(size(x))];
            cfg.bf_out(:,:,1) = [y zeros(size(y)) zeros(size(y))]';
            cfg.bf_out(:,:,2) = cfg.bf_out(:,:,1);
            cfg.sample_idx = 1;
            out = dispersion(cfg);
            %out
            %2*sqrt(2*log(2))*sigma
        end
        
        function tearDown(self)
            % Nothing to do
        end
        
    end
    
end