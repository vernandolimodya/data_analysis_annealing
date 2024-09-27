th_nrg = k*(temperatures + 273.15); % thermal energy, k*T where T is in Kelvin, units of thermal energies in eV
inverse_th_nrg = th_nrg.^(-1); % units in (eV)^{-1}

ln_tau = log(single_taus);

% do linear regression to extract tau_0
arrhenius_lin_reg = @(par, x) par(1) + par(2)*x;

[par_opt_arrh, resnorm, residual, exitflag, output, lambda, J] = lsqcurvefit(arrhenius_lin_reg, [1 1], ...
                                    inverse_th_nrg, ln_tau);

inverse_th_nrg_fit = linspace(min(inverse_th_nrg) - 0.1 * (max(inverse_th_nrg) - min(inverse_th_nrg)), ...
                              max(inverse_th_nrg) + 0.1 * (max(inverse_th_nrg) - min(inverse_th_nrg)), 500);
ln_tau_fit = NaN(500, 1);

for ind = 1:length(inverse_th_nrg_fit) 
        ln_tau_fit(ind) = arrhenius_lin_reg( [par_opt_arrh(1) par_opt_arrh(2)], inverse_th_nrg_fit(ind));
end

figure;
set(gcf,'position', [650,80,500,500]);
sgtitle("Arrhenius Equation to extract \tau_0 and estimate for E_A (Step 3)");

hold on
scatter(inverse_th_nrg, ln_tau, 'filled');
plot(inverse_th_nrg_fit, ln_tau_fit);
text(min(inverse_th_nrg) - 0.05 * (max(inverse_th_nrg) - min(inverse_th_nrg)), ...
    min(ln_tau) + 0.100 * (max(ln_tau) - min(ln_tau)), ...
    append("\tau_0 = ", string(par_opt_arrh(1))));
text(min(inverse_th_nrg) - 0.05 * (max(inverse_th_nrg) - min(inverse_th_nrg)), ...
    min(ln_tau) + 0.005 * (max(ln_tau) - min(ln_tau)), ...
    append("E_A = ", string(par_opt_arrh(2)), " eV"));
xlim([min(inverse_th_nrg) - 0.2 * (max(inverse_th_nrg) - min(inverse_th_nrg)) ...
    max(inverse_th_nrg) + 0.2 * (max(inverse_th_nrg) - min(inverse_th_nrg))]);
ylim([min(ln_tau) - 0.2 * (max(ln_tau) - min(ln_tau)) max(ln_tau) + 0.2 * (max(ln_tau) - min(ln_tau))]);
xlabel('(kT)^{-1} [eV^{-1}]');
ylabel('ln(\tau / 1 s) []');

hold off