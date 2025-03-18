% Chebyshev Type I and II Filters
clc; clear;

fs = 10000;
Ap = 0.6;
As = 0.1;
Wp = 0.35 * pi;
Ws = 0.7 * pi;
T = 1;

Ap_dB = -20 * log10(Ap);
As_dB = -20 * log10(As);

[n1, Wn1] = cheb1ord(Wp, Ws, Ap_dB, As_dB, 's');
[b1, a1] = cheby1(n1, Ap_dB, Wn1, 's');
[Nr1, Dr1] = bilinear(b1, a1, 1/T);

figure;
freqz(Nr1, Dr1);
title('Chebyshev Type I Filter');
