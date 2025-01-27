% unlike the loop in calculate_ea, I use another ea tolerance

current_index = 1;

for i=1:length(temperatures)
    for j=1:no_of_defects(i)
        if isnan(color_plotting(i,j))
            color_plotting(i,j) = min([mod(current_index, length(color_scheme)), ...
                length(color_scheme)]) ;
            for k=1:length(temperatures)
                for l=1:no_of_defects(k)
                    if abs(ea_array(i,j) - ea_array(k,l)) < ea_tolerance_samecolor && ...
                            isnan(color_plotting(k,l))
                        color_plotting(k, l) = color_plotting(i,j);
                    end
                end
            end
            
            current_index = current_index + 1;

        end
    end
end

%%%%% list of all equal activation energies s %%%%%

final_found_activation_energies = zeros([ sum(no_of_defects) 1 ]);

for m=1:length(final_found_activation_energies)
    final_found_activation_energies(m, 1) = nansum(ea_array .* (color_plotting == m),"all") / ...
        nansum((color_plotting == m),"all");
end


