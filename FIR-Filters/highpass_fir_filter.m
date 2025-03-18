% High-Pass FIR Filter using Various Windows
clc; clear; close all;

fs = 8000;  % Sampling Frequency
fc = 2000;  % Cutoff Frequency
N = 30;     % Filter Order
n = -N/2:N/2;
w_c = 2 * pi * fc / fs;

hd = sin(w_c * n) ./ (pi * n);
hd(n == 0) = w_c / pi;

delta = zeros(1, N+1);
delta(N/2 + 1) = 1;
hd_hpf = delta - hd;

w_rect = ones(1, N+1);
w_hamm = 0.54 - 0.46 * cos(2 * pi * n / (N-1));
h_rect = hd_hpf .* w_rect;
h_hamm = hd_hpf .* w_hamm;

figure;
freqz(h_rect, 1, 1024, fs);
title('Rectangular Window - High-pass Filter');

figure;
freqz(h_hamm, 1, 1024, fs);
title('Hamming Window - High-pass Filter');
