%% rmvb_tests
clc;
close all;
import matlab.unittest.TestSuite

verbosity = 1;

%% Run all tests
% suite = TestSuite.fromPackage('tests');
% 
% % Show tests
% if verbosity > 0
%     disp({suite.Name}');
% end
% result = run(suite);

%% Included in all
% Run some subsets

suite = TestSuite.fromClass(?tests.Test_fix_label);
if verbosity > 0
    disp({suite.Name}');
end
result = run(suite);

%% Not included in all
% Test_ft_trialfun_preceed

% [srcdir,~,~] = fileparts(mfilename('fullpath'));
% suite = TestSuite.fromFolder(fullfile(srcdir,'analysis'),'IncludingSubfolders',true);
% if verbosity > 0
%     disp({suite.Name}');
% end
% result = run(suite);