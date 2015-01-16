classdef get_label_idx_test < TestCase
    
    properties
    end
    
    methods
        function self = get_label_idx_test(name)
            self = self@TestCase(name);
        end
        
        function setUp(self)
            % Nothing to do
        end

        function test_basic(self)
            labels = {'one', 'two', 'three'};
            idx = metrics.get_label_idx(labels, 'one');
            assertEqual(idx, 1, 'Expected 1');
            idx = metrics.get_label_idx(labels, 'two');
            assertEqual(idx, 2, 'Expected 2');
            idx = metrics.get_label_idx(labels, 'three');
            assertEqual(idx, 3, 'Expected 2');
        end
        
        function test_basic_2(self)
            labels = {'one', 'one two', 'one three two'};
            idx = metrics.get_label_idx(labels, 'one');
            assertEqual(idx, 1, 'Expected 1');
            idx = metrics.get_label_idx(labels, 'one two');
            assertEqual(idx, 2, 'Expected 2');
            idx = metrics.get_label_idx(labels, 'one three two');
            assertEqual(idx, 3, 'Expected 3');
        end
       
        
        function tearDown(self)
            % Nothing to do
        end
        
    end
    
end