clc; clear; close all;

fs = 8000; % Sampling frequency
N = 50;
fc = [500 3000]; % Cutoff frequencies for Band-Pass filter

% Different filters
h_lp = fir1(N, fc(1)/(fs/2), 'low', hamming(N+1));
h_hp = fir1(N, fc(2)/(fs/2), 'high', hamming(N+1));

% Plot responses
figure;
subplot(2,1,1);
freqz(h_lp, 1, 1024, fs);
title('Low-Pass Filter Frequency Response');

subplot(2,1,2);
freqz(h_hp, 1, 1024, fs);
title('High-Pass Filter Frequency Response');
