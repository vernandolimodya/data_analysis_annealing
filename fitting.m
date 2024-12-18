no_of_defects = zeros([length(temperatures) 1]);

for i = 1:length(temperatures)
    
    temperature = temperatures(i);
    
    time = all_data(i, :, 1);
    nt = all_data(i, :, 2);

    time = time(~isnan(time));
    nt = nt(~isnan(nt));

    % try fitting with one, two, three, four and five terms for the graph
    % whether to use one, two, three, four or five terms we can see which
    % one gives the best resnorm
    best_par_opt = NaN([2*5+1 1]);
    best_resnorm = NaN;

    if set_no_of_activation_energies == 1
        term_number = no_of_activation_energies(i);
        x0 = fit_params(i, 1:(1+2*term_number));
        if term_number == 1
            dec_func = @(par, t) one_term(par(1), par(2), par(3), t);
        elseif term_number == 2
            dec_func = @(par, t) two_terms(par(1), par(2), par(3), par(4), par(5), t);
        elseif term_number == 3
            dec_func = @(par, t) three_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), t);
        elseif term_number == 4
            dec_func = @(par, t) four_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), ...
                par(8), par(9), t);
        elseif term_number == 5
            dec_func = @(par, t) five_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), ...
                par(8), par(9), par(10), par(11), t);
        end

        [par_opt, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(dec_func, x0, ...
                         log(time), nt);

        for index=1:length(par_opt)
            no_of_defects(i) = term_number;
            best_par_opt(index) = par_opt(index);
        end

    else
        for term_number = 1:5
            x0 = fit_params(i, 1:(1+2*term_number));
            if term_number == 1
                dec_func = @(par, t) one_term(par(1), par(2), par(3), t);
            elseif term_number == 2
                dec_func = @(par, t) two_terms(par(1), par(2), par(3), par(4), par(5), t);
            elseif term_number == 3
                dec_func = @(par, t) three_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), t);
            elseif term_number == 4
                dec_func = @(par, t) four_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), ...
                    par(8), par(9), t);
            elseif term_number == 5
                dec_func = @(par, t) five_terms(par(1), par(2), par(3), par(4), par(5), par(6), par(7), ...
                    par(8), par(9), par(10), par(11), t);
            end
    
            [par_opt, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(dec_func, x0, ...
                             log(time), nt);
            
            % update if appropriate
            if isnan(best_resnorm)
                no_of_defects(i) = term_number;
                best_resnorm = resnorm;
                for index=1:length(par_opt)
                    best_par_opt(index) = par_opt(index);
                end
            else
                if best_resnorm > resnorm
                    no_of_defects(i) = term_number;
                    best_resnorm = resnorm;
                    for index=1:length(par_opt)
                        best_par_opt(index) = par_opt(index);
                    end
                end
            end
        end
    end

    

    for index = 1:length(best_par_opt)
        if ~isnan(best_par_opt(index))
            fit_params(i, index) = best_par_opt(index);
        end
    end

end