clc; clear; close all;

fs = 8000;
Wp = 0.6 * pi;
Ws = 0.3 * pi;
Ap = 0.6;
As = 0.1;
T = 1;

alpha_p = -20 * log10(Ap);
alpha_s = -20 * log10(As);

[n, Wn] = cheb1ord(Wp, Ws, alpha_p, alpha_s, 's');
[b, a] = cheby1(n, alpha_p, Wn, 's');
[Nr, Dr] = bilinear(b, a, 1/T);

[noisy_signal, fs] = audioread('../data/sample_audio.wav');
filtered_signal = filter(Nr, Dr, noisy_signal);
filtered_signal = filtered_signal / max(abs(filtered_signal));
audiowrite('../data/filtered_output.wav', filtered_signal, fs);

snr_before = snr(noisy_signal);
snr_after = snr(filtered_signal);
disp(['SNR Before: ', num2str(snr_before), ' dB']);
disp(['SNR After: ', num2str(snr_after), ' dB']);
disp(['Noise Reduction: ', num2str(snr_after - snr_before), ' dB']);
