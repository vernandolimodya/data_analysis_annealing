% Initialize an array to store the maximum Nt for each temperature
global_max_Nt = [];

% First loop: Calculate the maximum Nt for all temperatures
for temp_index = 1:length(temperatures)
    temp = temperatures(temp_index);

    % Parse "BOL all T"
    bol_all_T_table = readtable(append(fileparts(mfilename('fullpath')), append('/', ...
                input_data_folder, '/', input_data_file)), ...
                'Sheet', 'BOL all T');

    c = table2cell(bol_all_T_table);

    % Find the indices of cells that contain NaN
    [nan_row, nan_col] = find(cellfun(@(x) isnumeric(x) && isnan(x), c));

    voc0_table = bol_all_T_table(:, 1:(nan_col(1)-1));
    isc0_table = bol_all_T_table(:, (nan_col(1)+1):end);

    % Extract isc0 and voc0
    voc0 = voc0_table(voc0_table.T == temp, :).(cell_name);
    isc0 = isc0_table(isc0_table.T_1 == temp, :).(append(cell_name, '_1'));

    % Extract isc_t and uoc_t
    voc_t_table = readtable(append(fileparts(mfilename('fullpath')), append('/', ...
                input_data_folder, '/', input_data_file)), ...
                'Sheet', 'Voc ' + string(temp) + ' deg');

    isc_t_table = readtable(append(fileparts(mfilename('fullpath')), append('/', ...
                input_data_folder, '/', input_data_file)), ...
                'Sheet', 'Isc ' + string(temp) + ' deg');

    % Extract Nt for one temperature
    timeColumn = voc_t_table.Date_Time;

    Nt = zeros(length(timeColumn), 1);

    for ind = 1:length(timeColumn)
        if consider_isc == 1
            Nt(ind) = isc_t_table.(cell_name)(ind) / isc0 * exp((voc0 - voc_t_table.(cell_name)(ind)) / (2 * kb * (temp + 273.15))) - 1;
        else
            Nt(ind) = phi0_const * n_a_const * sigma_const * v_const * exp((voc0 - voc_t_table.(cell_name)(ind)) / (2 * kb * (temp + 273.15))) - 1;
        end
    end

    % Store the maximum Nt for this temperature
    global_max_Nt = [global_max_Nt; max(Nt)];
end

% Find the overall maximum Nt across all temperatures
overall_max_Nt = max(global_max_Nt);

% Second loop: Normalize Nt using the overall maximum and save the results
for temp_index = 1:length(temperatures)
    temp = temperatures(temp_index);

    % Repeat the parsing and calculation steps as in the first loop
    bol_all_T_table = readtable(append(fileparts(mfilename('fullpath')), append('/', ...
                input_data_folder, '/', input_data_file)), ...
                'Sheet', 'BOL all T');

    c = table2cell(bol_all_T_table);

    [nan_row, nan_col] = find(cellfun(@(x) isnumeric(x) && isnan(x), c));

    voc0_table = bol_all_T_table(:, 1:(nan_col(1)-1));
    isc0_table = bol_all_T_table(:, (nan_col(1)+1):end);

    voc0 = voc0_table(voc0_table.T == temp, :).(cell_name);
    isc0 = isc0_table(isc0_table.T_1 == temp, :).(append(cell_name, '_1'));

    voc_t_table = readtable(append(fileparts(mfilename('fullpath')), append('/', ...
                input_data_folder, '/', input_data_file)), ...
                'Sheet', 'Voc ' + string(temp) + ' deg');

    isc_t_table = readtable(append(fileparts(mfilename('fullpath')), append('/', ...
                input_data_folder, '/', input_data_file)), ...
                'Sheet', 'Isc ' + string(temp) + ' deg');

    timeColumn = voc_t_table.Date_Time;

    bigT = temp * ones(length(timeColumn), 1);
    t = zeros(length(timeColumn), 1);
    Nt = zeros(length(timeColumn), 1);

    for ind = 1:length(timeColumn)
        t(ind) = seconds(timeColumn(ind) - timeColumn(1));
        if consider_isc == 1
            Nt(ind) = isc_t_table.(cell_name)(ind) / isc0 * exp((voc0 - voc_t_table.(cell_name)(ind)) / (2 * kb * (temp + 273.15))) - 1;
        else
            Nt(ind) = phi0_const * n_a_const * sigma_const * v_const * exp((voc0 - voc_t_table.(cell_name)(ind)) / (2 * kb * (temp + 273.15))) - 1;
        end
    end

    % Normalize Nt using the overall maximum
    Nt_norm = Nt / overall_max_Nt;

    temp_table = table(bigT, t, Nt_norm);
    temp_table.Properties.VariableNames = {'T', 'time (s)', 'Nt'};

    % Moving average implementation
    temp_table.('Nt_err') = movstd(temp_table.Nt, moving_average_time_span(temp_index));
    if moving_average_time_span(temp_index) ~= 0
        temp_table.Nt = movmean(temp_table.Nt, moving_average_time_span(temp_index));
    end

    % Write table to file
    writetable(temp_table, append(input_data_folder, '/', string(temp), '.xlsx'));
end





