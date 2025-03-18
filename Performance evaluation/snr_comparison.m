clc; clear; close all;

fs = 8000; % Sampling frequency
t = 0:1/fs:2; % 2 seconds of data

% Generate a clean signal and add noise
clean_signal = sin(2*pi*300*t); % 300Hz sine wave
noise = 0.3 * randn(size(clean_signal)); % Gaussian noise
noisy_signal = clean_signal + noise;

% Apply a Low-Pass FIR Filter
N = 50;
fc = 500;
h_lp = fir1(N, fc/(fs/2), 'low', hamming(N+1));
filtered_signal = filter(h_lp, 1, noisy_signal);

% Compute SNR before and after filtering
snr_before = snr(clean_signal, noise);
snr_after = snr(clean_signal, filtered_signal - clean_signal);

% Display results
disp(['SNR Before Filtering: ', num2str(snr_before), ' dB']);
disp(['SNR After Filtering: ', num2str(snr_after), ' dB']);

% Plot frequency response
figure;
freqz(h_lp, 1, 1024, fs);
title('Low-Pass Filter Frequency Response');
