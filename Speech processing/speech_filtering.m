clc; clear; close all;

% Load speech audio file
[audio_signal, fs] = audioread('../data/sample_audio.wav');

% Add artificial noise
noisy_signal = audio_signal + 0.05 * randn(size(audio_signal));

% Apply Low-Pass FIR filter to remove high-frequency noise
N = 50;
fc = 3000; % Cutoff frequency for speech
h_lp = fir1(N, fc/(fs/2), 'low', hamming(N+1));
filtered_signal = filter(h_lp, 1, noisy_signal);

% Plot results
subplot(3,1,1); plot(audio_signal); title('Original Speech Signal');
subplot(3,1,2); plot(noisy_signal); title('Noisy Speech Signal');
subplot(3,1,3); plot(filtered_signal); title('Filtered Speech Signal');

% Save the filtered speech file
audiowrite('../data/filtered_speech.wav', filtered_signal, fs);
