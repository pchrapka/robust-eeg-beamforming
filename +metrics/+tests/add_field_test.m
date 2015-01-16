classdef add_field_test < TestCase
    
    properties
    end
    
    methods
        function self = add_field_test(name)
            self = self@TestCase(name);
        end
        
        function setUp(self)
            % Nothing to do
        end

        function test_basic(self)
            item.snr = 10;
            
            cfg = [];
            cfg.field_name = 'snr';
            cfg.map.snr.field_label = 'SNR';
            cfg.map.snr.format = '%d';
            cfg.item = item;
            cfg.col_labels = {};
            cfg.row_idx = 1;
            cfg.data = {};
            cfg = metrics.add_field(cfg);
            
            assertEqual(cfg.col_labels,{'SNR'},...
                'Expected SNR in col_labels');
            assertEqual(cfg.row_idx,1,...
                'Expected row_idx to be unchanged');
            assertEqual(size(cfg.data),[1 1],...
                'Expected data in cfg.data');
            assertEqual(cfg.data{1,1}, item.snr,...
                'Expected a different cell value');
        end
        
        function test_field_duplicate(self)
            item.snr = 10;
            
            cfg = [];
            cfg.field_name = 'snr';
            cfg.map.snr.field_label = 'SNR';
            cfg.map.snr.format = '%d';
            cfg.item = item;
            cfg.col_labels = {'SNR'};
            cfg.row_idx = 1;
            cfg.data = {};
            cfg = metrics.add_field(cfg);
            
            assertEqual(cfg.col_labels,{'SNR'},...
                'Expected SNR in col_labels');
            assertEqual(size(cfg.data),[1 1],...
                'Expected data in cfg.data');
            assertEqual(cfg.data{1,1}, item.snr,...
                'Expected a different cell value');
        end
        
        function test_fields(self)
            item.snr = 10;
            item.sinr = 20;
            
            cfg = [];
            cfg.field_name = 'snr';
            cfg.map.snr.field_label = 'SNR';
            cfg.map.snr.format = '%d';
            cfg.item = item;
            cfg.col_labels = {};
            cfg.row_idx = 1;
            cfg.data = {};
            cfg = metrics.add_field(cfg);
            
            assertEqual(cfg.col_labels,{'SNR'},...
                'Expected SNR in col_labels');
            assertEqual(size(cfg.data),[1 1],...
                'Expected data in cfg.data');
            
            cfg.field_name = 'sinr';
            cfg.map.sinr.field_label = 'SINR';
            cfg.map.sinr.format = '%d';
            cfg.row_idx = 1;
            cfg = metrics.add_field(cfg);
            assertEqual(cfg.col_labels,{'SNR','SINR'},...
                'Expected SINR in col_labels');
            assertEqual(size(cfg.data),[1 2],...
                'Expected more data in cfg.data');
            assertEqual(cfg.data{1,2}, item.sinr,...
                'Expected a different cell value');
        end
        
        function tearDown(self)
            % Nothing to do
        end
        
    end
    
end