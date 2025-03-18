% Band-Stop FIR Filter
clc; clear; close all;

fs = 8000;
fc1 = 2000;
fc2 = 3000;
N = 30;
n = -N/2:N/2;

w_c1 = 2 * pi * fc1 / fs;
w_c2 = 2 * pi * fc2 / fs;

hd = sin(w_c2 * n) ./ (pi * n) - sin(w_c1 * n) ./ (pi * n);
hd(n == 0) = (w_c2 - w_c1) / pi;

delta = zeros(1, N+1);
delta(N/2 + 1) = 1;
hd_bsf = delta - hd;

w_hamm = 0.54 - 0.46 * cos(2 * pi * n / (N-1));
h_hamm = hd_bsf .* w_hamm;

freqz(h_hamm, 1, 1024, fs);
title('Hamming Window - Band-Stop Filter');
