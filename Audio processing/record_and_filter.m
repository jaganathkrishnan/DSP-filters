% Audio Recording and FIR Filtering
clc; clear; close all;

fs = 10000;
N = 100;
fc_lp = 200;

recObj = audiorecorder(fs, 8, 1);
disp("Start speaking...");
recordblocking(recObj, 5);
disp("Recording complete.");

audio_data = getaudiodata(recObj);
t = (0:length(audio_data)-1) / fs;

h_lp = fir1(N, fc_lp/(fs/2), 'low', rectwin(N+1));
filtered_audio = filter(h_lp, 1, audio_data);

subplot(2,1,1);
plot(t, audio_data);
title('Original Audio Signal');

subplot(2,1,2);
plot(t, filtered_audio);
title('Filtered Audio Signal');
    