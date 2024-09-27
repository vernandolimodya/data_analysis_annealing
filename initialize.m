% check if number of no_of_activation_energies has the same length as temperatures
if set_no_of_activation_energies == 1
    if length(no_of_activation_energies) ~= length(temperatures)
        error("The length of no_of_activation_energies must be the same as the length as temperatures!")
    end
else
end

no_of_defects = zeros([length(temperatures) 1]);
fit_params = zeros([length(temperatures) 1+2*5]);

% initialize fit_params based on the data %

for i=1:length(temperatures)
    time = all_data(i, :, 1);
    nt = all_data(i, :, 2);

    time = time(~isnan(time));
    nt = nt(~isnan(nt));

    fit_params(i, :) = [0.9*min(nt) 0.5*(max(nt)-min(nt)) median(log(time)) 0.5*(max(nt)-min(nt)) ...
                median(log(time)) 0.5*(max(nt)-min(nt)) median(log(time)) 0.5*(max(nt)-min(nt)) ...
                median(log(time)) 0.5*(max(nt)-min(nt)) median(log(time))];

end

clear i;
clear time;
clear nt;

% initialize array containing activation energies
ea_array = NaN([length(temperatures) 5]);

% set tau_0 as tau_0_initial_estimate
tauzero = tauzero_initial_guess;

% if they were equal then 1 or else 0, but based on ea_tolerance_taurefine
ea_equal = NaN([length(temperatures) 5 length(temperatures) 5]);

% which color to based on ea_tolerance_samecolor
color_plotting = NaN([length(temperatures) 5]);
% and which mean energies do we have
mean_energies = NaN();
