temperature = 50;

data = readtable(append( fileparts(mfilename('fullpath')), append('/', ...
        input_data_folder, '/', string(temperature) , '.xlsx')));
data.Properties.VariableNames = {'T', 'time', 'Nt'};

time_series = logspace(-2, 6, 500);
y_fit = NaN(500, 1);

% x0 = [0.1 0.5 1];
x0 = [mean(data.Nt) max(data.Nt)-min(data.Nt) 1];

% AHHH ICH MUSS THE X OPTS IN EINEM VEKTOR PACKEN
sed = @(par, t) simple_exp_decay(par(1), par(2), par(3), t);

% fitting for one temperature %
[par_opt, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(sed, x0, ...
                                data.time, data.Nt);

for ind = 1:length(time_series) 
    y_fit(ind) = simple_exp_decay(par_opt(1), par_opt(2), par_opt(3), time_series(ind));
    % y_fit(ind) = simple_exp_decay(10.6, 0.1, 100, time_series(ind));
end

disp(par_opt);

figure;

hold on

sgtitle("Test");
plot(time_series, y_fit);
scatter(data.time, data.Nt, 'filled');
xlabel('Time [s]');
ylabel('Relative Defect Concentration');
set(gca,'xscale','log');

