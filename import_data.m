
all_data = NaN([length(temperatures) maximum_data_length 2]);

for i = 1:length(temperatures)

    temperature = temperatures(i);

    data = readtable(append( fileparts(mfilename('fullpath')), append('/', ...
            input_data_folder, '/', string(temperature) , '.xlsx')));
    data.Properties.VariableNames = {'T', 'time', 'Nt', 'Nt_err'};

    for j = 1:length(data.time)
        all_data(i, j, 1) = data.time(j); % Store time
        all_data(i, j, 2) = data.Nt(j); % Normalize Nt and store
    end
    
end

clear data;
clear i;
clear j;