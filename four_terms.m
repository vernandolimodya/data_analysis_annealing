function Nt = four_terms(c0, c1, tau1, c2, tau2, c3, tau3, c4, tau4, t)
    % Nt = c0 + exponential(c1, tau1, t) + exponential(c2, tau2, t) + exponential(c3, tau3, t) + exponential(c4, tau4, t);
    Nt = c0 + exponential2(c1, tau1, t) + exponential2(c2, tau2, t) + exponential2(c3, tau3, t) + exponential2(c4, tau4, t);
end

