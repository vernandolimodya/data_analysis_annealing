temperatures = [50 100 150 230] ; % in celsius

single_c0s = NaN(1, length(temperatures));
single_c1s = NaN(1,length(temperatures));
single_taus = NaN(1, length(temperatures));

figure;
set(gcf,'position', [50,50,500,750]);
sgtitle("Single Defect Approximation (Step 2)");

for i = 1:length(temperatures)

    temperature = temperatures(i);

    data = readtable(append( fileparts(mfilename('fullpath')), append('/', ...
        input_data_folder, '/', string(temperature) , '.xlsx')));
    data.Properties.VariableNames = {'T', 'time', 'Nt'};
    
    time_series = logspace(-2, 7, 500);
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

    % save into the variables
    
    single_c0s(i) = par_opt(1);
    single_c1s(i) = par_opt(2);
    single_taus(i) = par_opt(3);

    subplot(length(temperatures), 1, i);
    
    hold on

    scatter(data.time, data.Nt, 'filled', 'DisplayName', 'data');
    plot(time_series, y_fit, 'DisplayName', 'fit');
    
    text(10^(7 - 0.1*(7-(-2))), max(data.Nt) - 0.05 * (max(data.Nt) - min(data.Nt)), ...
        append("T = ", string(temperatures(i)), " ", char(176) , "C" ), 'fontweight','bold');
    text(10^(-2 + 0.05*(7-(-2))), min(data.Nt) + 0.4 * (max(data.Nt) - min(data.Nt)), ...
        append("c_0 = ", string(par_opt(1))));
    text(10^(-2 + 0.05*(7-(-2))), min(data.Nt) + 0.2 * (max(data.Nt) - min(data.Nt)), ...
        append("c_1 = ", string(par_opt(2))));
    text(10^(-2 + 0.05*(7-(-2))), min(data.Nt) + 0.0 * (max(data.Nt) - min(data.Nt)), ...
        append("\tau = ", string(par_opt(3)), " s"));
    
    if i == length(temperatures)
        legend('Position', [0.9 0.5 0.01 0.01]);
    end

    xlabel('Time [s]');
    ylim([min(data.Nt) - 0.2 * (max(data.Nt) - min(data.Nt)) max(data.Nt) + 0.2 * (max(data.Nt) - min(data.Nt))]);
    ylabel('Rel. Defect Conc.');
    set(gca,'xscale','log');

    hold off

end