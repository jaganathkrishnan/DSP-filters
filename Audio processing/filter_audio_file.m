% Filtering an Audio File
clc; clear; close all;

[audio_signal, fs] = audioread('sample_audio.wav'); %change audio file to whicher is the file
N = 100;
fc_lp = 200;
h_lp = fir1(N, fc_lp/(fs/2), 'low', rectwin(N+1));
filtered_signal = filter(h_lp, 1, audio_signal);

audiowrite('filtered_audio.wav', filtered_signal, fs);

subplot(2,1,1);
plot(audio_signal);
title('Original Audio Signal');

subplot(2,1,2);
plot(filtered_signal);
title('Filtered Audio Signal');
