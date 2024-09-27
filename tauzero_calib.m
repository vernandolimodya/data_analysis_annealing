function output = tauzero_calib(log_tau1, T1, log_tau2, T2, log_tauzero_inp)
    output = (T1/T2)*(log_tau1 - log_tauzero_inp) + log_tauzero_inp - log_tau2;
end

