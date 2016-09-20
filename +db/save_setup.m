function save_file = save_setup(varargin)
%SAVE_SETUP saves data in the output folder
%   SAVE_SETUP(...) saves data in the output folder
%   
%   Parameters
%   ----------
%
%   Method 1 
%   --------
%   Save in a hierarchical directory specified by a SimDataSetEEG
%   object
%
%   data_set
%       SimDataSetEEG object
%   tag (string, optional)
%       tag added to the end of the file name
%   ext (string, default = '.mat')
%       file extension
%
%   Method 2 
%   --------
%   Save in the same directory as another file
%
%   file_name (string)
%       file to use as base
%   save_name (string, optional)  
%       serves as the base of the file name
%   tag (string, optional)     
%       tag added to the end of the file name, it's recommended to add a
%       tag to not overwrite
%   ext (string, default = '.mat')
%       file extension

p = inputParser();
addParameter(p,'data_set',[],@(x) isa(x,'SimDataSetEEG'));
addParameter(p,'tag',[],@ischar);
addParameter(p,'ext','.mat',@ischar);
addParameter(p,'file_name',[],@ischar);
addParameter(p,'save_name',[],@ischar);
parse(p,varargin{:});

if ~isempty(p.Results.data_set) && ~isempty(p.Results.file_name)
    error('Choose one method');
end

if ~isempty(p.Results.data_set)
    % Method 1
    
    % Get the save directory
    save_dir = p.Results.data_setget_dir();
    
    % Check the output directory
    if ~exist(save_dir, 'dir');
        mkdir(save_dir);
    end
    
    % Set up the file name
    save_file = fullfile(save_dir,...
        [p.Results.data_setget_filename(p.Results.tag) p.Results.ext]);
    
else
    % Method 2
    
    % Get the directory that contains the file function
    [save_dir,save_name,~,~] = util.fileparts(p.Results.file_name);
    
    % Add a tag
    if ~isempty(p.Results.save_name)
        % Add optional tag
        if ~isempty(p.Results.tag)
            file_name = db.add_tag(p.Results.save_name, p.Results.tag);
        else
            % Not adding a tag, so check if we're overwriting
            if isequal(p.Results.save_name, save_name)
                warning('db:save_setup',...
                    ['the save name is similar to the original file, '...
                    'consider adding a tag']);
            end
            file_name = p.Results.save_name;
        end
    else
        if isempty(p.Results.tag)
            error('no tag specified');
        else
            file_name = db.add_tag(save_name, p.Results.tag);
        end
    end
    
    % Set up the file name
    save_file = fullfile(save_dir, [file_name p.Results.ext]);
    
    % Check if there's a new directory
    [save_dir,~,~,~] = util.fileparts(save_file);
    % Check the output directory
    if ~exist(save_dir, 'dir');
        mkdir(save_dir);
    end
end

end