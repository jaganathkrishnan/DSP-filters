function filtered_signal = chebyshev_filter(input_signal, fs)
    Wp = 0.6 * pi; Ws = 0.3 * pi; Ap = 0.6; As = 0.1; T = 1/fs;
    alpha_p = -20 * log10(Ap); alpha_s = -20 * log10(As);
    [n, Wn] = cheb1ord(Wp, Ws, alpha_p, alpha_s, 's');
    [b, a] = cheby1(n, alpha_p, Wn, 's');
    [Nr, Dr] = bilinear(b, a, T);
    filtered_signal = filter(Nr, Dr, input_signal);
end