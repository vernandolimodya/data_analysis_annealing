% constants %
% Boltzmann constant
kb = 8.617333262145e-5; % eV/K

input_data_folder = "input_data";
input_data_file = "all_annealing_data_cleaned.xlsx";
temperatures = [120 140 150]; % in celsius
cell_name = "cell02"; % it has to be the same name as in the column of the
% raw data

% if true (1), then the original equation will be used, if false (0)
% then the equation in the updated paper will be used
consider_isc = 1;

% constants for the equation in the updated paper %
phi0_const = 1;
n_a_const = 1;
sigma_const = 1;
v_const = 1;

set_no_of_activation_energies = 1; % 0 : automatic number of activation energies, 1 : number of activation energies
% set below in the variable no_of_activation_energies
no_of_activation_energies = [1 2 1];

moving_average_time_span = [10 30 10]; % in data points
% length has to be the same number as temperatures array
% all entries > 1

fitting_parameter_guess = [[NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]
                           [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]
                           [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];


plot_every_n_th_datapoint = [1 1 1 1 1];
% length has to be the same number as temperatures array

show_errorbars = 0; % 0 no errorbars, 1 with errorbars

maximum_data_length = 2920; % number of data points

tauzero_initial_guess = log(7.71e-6); % in log( 1 * seconds)

% number of iterations
% e.g. 100
number_of_iterations = 50;

% the fraction of total iterations where tau refining is performed, e.g.
% for a value of 0.2, means the last 20 percent of iterations include tau 
% refining 
frac_refine = 0.0;

% distance between two activation energies where we apply the tau zero
% refining equation
ea_tolerance_taurefine = 0.01;

% difference in activation energies (only at the plotting stage) to be as
% considered to come from the same activation energy --
% you can set the ea_tolerance_taurefine and ea_tolerance_samecolor as
% the same
ea_tolerance_samecolor = 0.05;

% plot from 1e{time_lower_limit} seconds to 1e{time_upper_limit} seconds
time_lower_limit = 9;
time_upper_limit = 14;

% color scheme in hexadecimal for plotting %
color_scheme = ["red", "green", "blue", "yellow",  ...
                "magenta",  "cyan",  "#FF8F00",  "#FFDB00", "red", "red", "red", ...
                "red", "red", "red"];