clc; clear; close all;

fs = 1000; % Sampling frequency for ECG
t = 0:1/fs:10; % 10 seconds of data

% Simulated ECG Signal with 60Hz noise
ecg_signal = 1.2*sin(2*pi*1*t) + 0.3*sin(2*pi*60*t) + 0.1*randn(size(t));

% Apply a Band-Pass FIR Filter (0.5Hz - 40Hz)
N = 50;
fc = [0.5 40];
h_bp = fir1(N, fc/(fs/2), 'bandpass', hamming(N+1));
filtered_ecg = filter(h_bp, 1, ecg_signal);

% Plot results
subplot(2,1,1); plot(t, ecg_signal); title('Noisy ECG Signal');
subplot(2,1,2); plot(t, filtered_ecg); title('Filtered ECG Signal');

% Save filtered ECG signal
save('../data/filtered_ecg.mat', 'filtered_ecg');
