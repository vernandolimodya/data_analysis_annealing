equated_ea = NaN([ length(temperatures) 5 ]);

for i=1:length(temperatures)
    for j=1:no_of_defects(i)
        equated_ea(i,j) = sum( fillmissing(ea_array, 'constant', 0) .* squeeze(fillmissing(ea_equal(i,j,:,:), 'constant', 0)), "all") /...
            sum(squeeze(fillmissing(ea_equal(i,j,:,:), 'constant', 0)), "all");
    end
end

ea_array = equated_ea;

clear equated_ea;

% recalculate refine tauzero

refined_tauzero_arr = NaN([length(temperatures) 5 length(temperatures) 5]); % delete this if you already have an algorithm

for i=1:length(temperatures)
    for j=1:no_of_defects(i)
        for k=1:length(temperatures)
            for l=1:no_of_defects(k)
                if i~=k && j~=l && ea_equal(i,j,k,l) == 1 && ...
                       fit_params(i, 1 + 2*j) > 0 && fit_params(k, 1 + 2*l) > 0
%                     func = @(x) tauzero_calib(fit_params(i, 1 + 2*j), ...
%                      temperatures(i) + 273.15, fit_params(k, 1 + 2*l), ...
%                      temperatures(k) + 273.15, x);
                      T1 = temperatures(i) + 273.15;
                      T2 = temperatures(k) + 273.15;
%                     refined_tauzero_arr(i,j,k,l) = fzero(func, tauzero);
                     refined_tauzero_arr(i,j,k,l) = (fit_params(k, 1 + 2*l) - T1*fit_params(i, 1 + 2*j)/T2)/(1-T1/T2);

                     clear T1
                     clear T2
                else
                end
            end
        end
    end
end

if ~isnan(nanmean(refined_tauzero_arr, "all"))
     tauzero = nanmean(refined_tauzero_arr, "all");
else
end


% recalculate the taui s using the refined tauzero

for i=1:length(temperatures)
    for j=1:no_of_defects(i)
        fit_params(i, 1+2*j) = tauzero + ea_array(i,j)/(kb*(temperatures(i) + 273.15));
    end
end


