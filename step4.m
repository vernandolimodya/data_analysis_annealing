figure;
set(gcf,'position', [1000,50,500,750]);
sgtitle("Triple Defect Approximation (Step 4)");

for i = 1:length(temperatures)
    
    temperature = temperatures(i);

    data = readtable(append( fileparts(mfilename('fullpath')), append('/', ...
        input_data_folder, '/', string(temperature) , '.xlsx')));
    data.Properties.VariableNames = {'T', 'time', 'Nt'};

    x0 = [single_c0s(i) single_c1s(i) par_opt_arrh(2) single_c1s(i) par_opt_arrh(2) single_c1s(i) par_opt_arrh(2)];

    ted = @(par, t) triple_exp_decay(par(1), par(2), par(3), par(4), par(5), par(6), par(7), par_opt_arrh(1), inverse_th_nrg(i) , t);

    % fitting for one temperature %
    [par_opt_trip, resnorm_triple, residual_triple, exitflag_triple, output_triple, lambda_triple, J_triple] = lsqcurvefit(ted, x0, ...
                                    data.time, data.Nt);
    
    
    time_series = logspace(-2, 7, 500);
    y_fit = NaN(500, 1);

    for ind = 1:length(time_series) 
        y_fit(ind) = triple_exp_decay(par_opt_trip(1), par_opt_trip(2), par_opt_trip(3), par_opt_trip(4), par_opt_trip(5), par_opt_trip(6), ...
                                      par_opt_trip(7), par_opt_arrh(1), inverse_th_nrg(i), time_series(ind));
    end

    disp(par_opt_trip);

    subplot(length(temperatures), 1, i);
    
    hold on

    plot(time_series, y_fit);
    scatter(data.time, data.Nt, 'filled');
    text(10^(7 - 0.1*(7-(-2))), max(data.Nt) - 0.05 * (max(data.Nt) - min(data.Nt)), ...
        append("T = ", string(temperatures(i)), " ", char(176) , "C" ), 'fontweight','bold');
    xlabel('Time [s]');
    ylim([min(data.Nt) - 0.2 * (max(data.Nt) - min(data.Nt)) max(data.Nt) + 0.2 * (max(data.Nt) - min(data.Nt))]);
    ylabel('Rel. Defect Conc.');
    set(gca,'xscale','log');

    hold off

end