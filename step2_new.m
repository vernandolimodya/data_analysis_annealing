
no_of_defects = zeros([length(temperatures) 1]);
fit_params = zeros([length(temperatures) 1+2*5]);

for i = 1:length(temperatures)
    
    temperature = temperatures(i);

    data = readtable(append( fileparts(mfilename('fullpath')), append('/', ...
        input_data_folder, '/', string(temperature) , '.xlsx')));
    data.Properties.VariableNames = {'T', 'time', 'Nt'};
    
    % try fitting with one, two, three, four and five terms for the graph
    % whether to use one, two, three, four or five terms we can see which
    % one gives the best resnorm
    best_resnorm = NaN;
    for term_number = 1:5
        if term_number == 1
            % x0 = [0.1 0.5 1]; 
            x0 = [mean(data.Nt) max(data.Nt)-min(data.Nt) 1];
            dec_func = @(par, t) one_term(par(1), par(2), par(3), t);
            [par_opt, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(dec_func, x0, ...
                         data.time, data.Nt);
        elseif term_number == 2
            % x0 = [0.1 0.5 0.1 0.5 1];
            x0 = [mean(data.Nt) max(data.Nt)-min(data.Nt) 1 max(data.Nt)-min(data.Nt) 1];
            dec_func = @(par, t) two_terms(par(1), par(2), par(3), par(4), par(5), t);
            [par_opt, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(dec_func, x0, ...
                         data.time, data.Nt);
        elseif term_number == 3
            % x0 = [0.1 0.5 0.1 0.5 0.1 0.5 1];
            x0 = [mean(data.Nt) max(data.Nt)-min(data.Nt) 1 max(data.Nt)-min(data.Nt) 1 max(data.Nt)-min(data.Nt) 1];
            dec_func = @(par, t) three_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), t);
            [par_opt, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(dec_func, x0, ...
                         data.time, data.Nt);
        elseif term_number == 4
            % x0 = [0.1 0.5 0.1 0.5 0.1 0.5 0.1 0.5 1];
            x0 = [mean(data.Nt) max(data.Nt)-min(data.Nt) 1 max(data.Nt)-min(data.Nt) ...
                 1 max(data.Nt)-min(data.Nt) 1 max(data.Nt)-min(data.Nt) 1];
            dec_func = @(par, t) four_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), ...
                par(8), par(9), t);
            [par_opt, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(dec_func, x0, ...
                         data.time, data.Nt);
        elseif term_number == 5
            % x0 = [0.1 0.5 0.1 0.5 0.1 0.5 0.1 0.5 0.1 0.5 1];
            x0 = [mean(data.Nt) max(data.Nt)-min(data.Nt) 1 max(data.Nt)-min(data.Nt) ...
                 1 max(data.Nt)-min(data.Nt) 1 max(data.Nt)-min(data.Nt) ...
                 1 max(data.Nt)-min(data.Nt) 1];
            dec_func = @(par, t) five_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), ...
                par(8), par(9), par(10), par(11), t);
            [par_opt, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(dec_func, x0, ...
                         data.time, data.Nt);
        end
        
        % update if appropriate
        if isnan(best_resnorm)
            no_of_defects(i) = term_number;
            best_resnorm = resnorm;
            for index=1:length(par_opt)
                fit_params(i, index) = par_opt(index);
            end
        else
            if best_resnorm > resnorm
                no_of_defects(i) = term_number;
                best_resnorm = resnorm;
                for index=1:length(par_opt)
                    fit_params(i, index) = par_opt(index);
                end
            end
        end

    end

end

figure;
set(gcf,'position', [50,50,500,750]);
sgtitle("First Iteration");

for i = 1:length(temperatures)
    
    % reread the data
    temperature = temperatures(i);

    data = readtable(append( fileparts(mfilename('fullpath')), append('/', ...
        input_data_folder, '/', string(temperature) , '.xlsx')));
    data.Properties.VariableNames = {'T', 'time', 'Nt'};
    
    % ....

    time_series = logspace(-2, 7, 500);
    y_fit = zeros(500, 1);

    for ind = 1:length(time_series)
        % y_fit(ind) = one_term(1, 0.2, 400508.168910774, time_series(ind));
        y_fit(ind) = fit_params(i, 1);
        for j = 1:no_of_defects(i)
            y_fit(ind) = y_fit(ind) + exponential(fit_params(i, 2*j), fit_params(i, 2*j+1), time_series(ind));
        end
        
    end
    
    subplot(length(temperatures), 1, i);
    
    hold on

    scatter(data.time, data.Nt, 'filled', 'DisplayName', 'data');
    plot(time_series, y_fit, 'DisplayName', 'fit');
    
    if i == length(temperatures)
        legend('Position', [0.9 0.5 0.01 0.01]);
    end

    text(10^(7 - 0.1*(7-(-2))), max(data.Nt) - 0.05 * (max(data.Nt) - min(data.Nt)), ...
        append("T = ", string(temperatures(i)), " ", char(176) , "C" ), 'fontweight','bold');

    xlabel('Time [s]');
    ylim([min(data.Nt) - 0.2 * (max(data.Nt) - min(data.Nt)) max(data.Nt) + 0.2 * (max(data.Nt) - min(data.Nt))]);
    ylabel('Rel. Defect Conc.');
    set(gca,'xscale','log');

    hold off
    
end