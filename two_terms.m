function Nt = two_terms(c0, c1, tau1, c2, tau2, t)
    % Nt = c0 + exponential(c1, tau1, t) + exponential(c2, tau2, t);
    Nt = c0 + exponential2(c1, tau1, t) + exponential2(c2, tau2, t);
end

