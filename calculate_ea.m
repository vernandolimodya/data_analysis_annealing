for i=1:length(temperatures)
    for j=1:no_of_defects(i)
        ea_array(i,j) = kb*(temperatures(i) + 273.15) * (fit_params(i, 1+2*j) - tauzero);
    end
end

for i=1:length(temperatures)
    for j=1:no_of_defects(i)
        for k=1:length(temperatures)
            for l=1:no_of_defects(k)
                if abs(ea_array(i,j) - ea_array(k,l)) < ea_tolerance_taurefine  
                    ea_equal(i,j,k,l) = 1;
                else
                    ea_equal(i,j,k,l) = 0;
                end
            end
        end
    end
end