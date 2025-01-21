figure;
set(gcf,'position', [50,50,500,750]);
% sgtitle("Activation Energies");

for i = 1:length(temperatures)
    
    temperature = temperatures(i);
    
    time = all_data(i, :, 1);
    nt = all_data(i, :, 2);

    time = time(~isnan(time));
    nt = nt(~isnan(nt));

    time_series = linspace(time_lower_limit, time_upper_limit, 500);
    y_fit = zeros(500, 1);

    for ind = 1:length(time_series)
        y_fit(ind) = fit_params(i, 1);
        for j = 1:no_of_defects(i)
            y_fit(ind) = y_fit(ind) + exponential2(fit_params(i, 2*j), fit_params(i, 2*j+1), time_series(ind));
        end
        
    end
    
    subplot(length(temperatures), 1, i);
    
    hold on
    
    if show_errorbars == 0
        scatter(log(time), nt, 'filled', 'DisplayName', 'data', 'Color', 'blue');
    elseif show_errorbars == 1
        errorbar(log(data.time(1:plot_every_n_th_datapoint(i):end)), data.Nt(1:plot_every_n_th_datapoint(i):end), data.Nt_err(1:plot_every_n_th_datapoint(i):end), ...
            'LineStyle', 'none', 'Marker','.', 'MarkerSize',10, 'DisplayName', 'data', 'Color', "#0072BD");
    else
    end
    plot(time_series, y_fit, 'DisplayName', 'fit','Color', 'black', 'LineWidth', 1);
    
    if i == length(temperatures)
        for index=1:min(color_plotting(i,:)) - 1
            plot(time_series, -150*ones(500, 1), 'color', color_scheme(index), 'LineWidth', 2, 'DisplayName', string(round(final_found_activation_energies(index), 2)) + " eV");

        end
    end

    % plot colored curves %
    for j=1:no_of_defects(i)
        y_fit_color = zeros(500, 1);
        for ind = 1:length(time_series)
            y_fit_color(ind) = fit_params(i, 1) + exponential2(fit_params(i, 2*j), fit_params(i, 2*j+1), time_series(ind));
        end
        plot(time_series, y_fit_color, 'color', color_scheme(color_plotting(i,j)), 'LineWidth', 2, 'DisplayName', string(round(final_found_activation_energies(color_plotting(i,j)), 2)) + " eV");

    end
    %
    
    if i == length(temperatures)
        legend('Position', [0.5 0.95 0.01 0.01], 'NumColumns', 4);
    end

    text(16 - 0.2*(16-(-2)), max(nt) - 0.05 * (max(nt) - min(nt)), ...
        append("T = ", string(temperatures(i)), " ", char(176) , "C" ), 'fontweight','bold');

    xlabel('ln(t[s])');
    y_min = min([min(nt), min(y_fit)]);
    y_max = max([max(nt), max(y_fit)]);
    margin = 0.1 * (y_max - y_min); % Add 10% margin
    ylim([y_min - margin, y_max + margin]);
    ylabel('Norm. Rel. Defect Conc.');

    % Calculate dynamic x-limits with margin
    x_min = time_lower_limit;
    x_max = time_upper_limit;
    x_margin = 0.1 * (x_max - x_min); % Add 10% margin
    
    % Apply new x-limits with margin
    xlim([x_min - x_margin, x_max + x_margin]);
    

    hold off
    
end