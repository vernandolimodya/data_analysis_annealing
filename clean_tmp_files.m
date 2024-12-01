for i = 1:length(temperatures)
    temperature = temperatures(i);
    
    delete(append( fileparts(mfilename('fullpath')), append('/', ...
                input_data_folder, '/', string(temperature), '.xlsx')));
    
end