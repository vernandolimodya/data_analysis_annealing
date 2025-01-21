
all_data = NaN([length(temperatures) maximum_data_length 2]);

for i = 1:length(temperatures)

    temperature = temperatures(i);

    data = readtable(append( fileparts(mfilename('fullpath')), append('/', ...
            input_data_folder, '/', string(temperature) , '.xls')));
    data.Properties.VariableNames = {'T', 'time', 'Nt', 'Nt_err'};

    % Find the maximum value of Nt for normalization
    Nt_max = max(data.Nt);

    for j = 1:length(data.time)
        all_data(i, j, 1) = data.time(j); % Store time
        all_data(i, j, 2) = data.Nt(j) / Nt_max; % Normalize Nt and store
    end
    
end

clear data;
clear i;
clear j;