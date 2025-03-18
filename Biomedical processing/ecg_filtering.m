clc; clear; close all;

% Parameters
fs = 1000; % Sampling frequency for ECG
t = 0:1/fs:10; % 10 seconds of data

% Simulated ECG Signal with 60Hz noise
ecg_signal = 1.2*sin(2*pi*1*t) + 0.3*sin(2*pi*60*t) + 0.1*randn(size(t));

% Design a 60 Hz notch filter
f0 = 60; % Notch frequency (60 Hz)
Q = 35; % Quality factor (adjust for sharper notch)
wo = f0/(fs/2); % Normalized frequency
bw = wo/Q; % Bandwidth
[b_notch, a_notch] = iirnotch(wo, bw); % IIR Notch filter

% Apply the notch filter
filtered_ecg_notch = filter(b_notch, a_notch, ecg_signal);

% Design a Butterworth bandpass filter
fc_low = 0.5; % Lower cutoff frequency
fc_high = 40; % Upper cutoff frequency
[b_butter, a_butter] = butter(4, [fc_low fc_high]/(fs/2), 'bandpass'); % 4th order Butterworth filter

% Apply the Butterworth filter
filtered_ecg_combined = filter(b_butter, a_butter, filtered_ecg_notch);

% Calculate SNR before filtering
signal_power = rms(1.2*sin(2*pi*1*t))^2; % Power of the clean ECG signal
noise_power = rms(ecg_signal - 1.2*sin(2*pi*1*t))^2; % Power of the noise
snr_before = 10 * log10(signal_power / noise_power);

% Calculate SNR after filtering
filtered_signal_power = rms(filtered_ecg_combined)^2;
filtered_noise_power = rms(filtered_ecg_combined - 1.2*sin(2*pi*1*t))^2;
snr_after = 10 * log10(filtered_signal_power / filtered_noise_power);

% Display SNR results
fprintf('SNR before filtering: %.2f dB\n', snr_before);
fprintf('SNR after filtering: %.2f dB\n', snr_after);

% Visualization
figure;
subplot(3,1,1);
plot(t, ecg_signal);
title('Noisy ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
xlim([0 10]);

subplot(3,1,2);
plot(t, filtered_ecg_notch);
title('ECG Signal After 60 Hz Notch Filter');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
xlim([0 10]);

subplot(3,1,3);
plot(t, filtered_ecg_combined);
title('Filtered ECG Signal (Notch + Bandpass)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
xlim([0 10]);

% Save the final filtered signal
try
    save('../data/filtered_ecg_improved.mat', 'filtered_ecg_combined');
    disp('Improved filtered ECG signal saved successfully.');
catch ME
    warning('Failed to save the filtered ECG signal: %s', ME.message);
end