% Butterworth Filter
clc; clear; close all;

As = 0.1;
Ap = 0.6;
Wp = 0.6 * pi;
Ws = 0.3 * pi;
T = 1;

alpha_p = -20 * log10(Ap);
alpha_s = -20 * log10(As);

[n, Wn] = buttord(Wp, Ws, alpha_p, alpha_s, "s");
[a, b] = butter(n, Wn, 's');
[Nr, Dr] = bilinear(a, b, 1/T);

freqz(Nr, Dr);
title('Butterworth Filter Response');
