%% Clone Spatial Statistics Code

if ~exist('SpatialStatisticsFFT','dir')
    system('git clone https://github.com/tonyfast/SpatialStatisticsFFT.git');
else
    disp('SpaialStatisticsFFT already exists')
end

%% Download JSONlab

if ~exist('jsonlab','dir')
    
    dlsrc = urlwrite( 'http://www.mathworks.com/matlabcentral/fileexchange/downloads/506889/download', 'jsonlab.zip' );
    mkdir('jsonlab')
    unzip( dlsrc, '.' );
    delete dlsrc;
else
    disp('jsonlab already exists')
end

%% Add Toolboxes

addpath( genpath( './SpatialStatisticsFFT' ));
addpath( genpath( './jsonlab' ));

%% Loop over files in _data

data_dir = '_data';
files = dir( fullfile( '.', data_dir ) );

fileflag = '.png.json'; % This extension exists on all the files I want to work on

for ff = 1 : numel(files)
    
    file = files(ff);
    
    if numel( file.name ) > numel(fileflag) && ...
            strcmp( ...
                file.name(end - ...
                    ([ numel( fileflag ) : -1 : 1 ] - 1)  ), ...
                fileflag )
            
        disp( sprintf('Operating on %i of %i.', ff, numel(files) ) )
        
        data = loadjson( fullfile( data_dir, file.name ) );
        
        % Hyphen is replaced with unicode ``_0x2D_``
        image = imread( ...
            fullfile( data_dir, ...
                data.local.('file_0x2D_name') ) );
        
        % Divide and round by pixel value to segment image
        image = round( double(image)./255 );
       
        edges = binary_edge( image );
        
        tic;
        [Stats, xx] = PairCorrelationFFT( image, [], ...
                            'display', false, ...
                            'cutoff', 20 ... Cutoff the stats a 20 pixels to use the computation of the SSA
                                );
        t= toc;
                            
        %% Stats vs xx is the Pair Correlation function
        % The derivative at t-->0 of the Pair Correlation function is
        % proportional to the Specific Surface Area with a scaling
        % variable.
        % In 2-D, SSA = d(Stats)/d(xx) / (-1/4)
        
        dstats = gradient( Stats );
        data.('statistics_0x2D_ml').('SSA').value = -4*dstats(1);
        data.('statistics_0x2D_ml').('SSA').description = horzcat( ... 
            'Computed via the gradient of the pair correlation function using', ...
            'this reference <<http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.49.1716>>');
        data.('statistics_0x2D_ml').('SSA').('time_0x2D_elapsed') = sprintf('%fs',t);
        
        
        json = savejson( '',data);
        json = minifyjson( json );
        
        fo = fopen( fullfile( data_dir, file.name ), 'w')
        fwrite( fo, json );
        fclose(fo)
        
    end
    

end