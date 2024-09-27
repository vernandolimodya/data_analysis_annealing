function Nt = exponential2(ci,tau,t)
    Nt = ci * exp(-exp(t-tau));
end