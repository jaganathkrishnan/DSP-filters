function [snr_before, snr_after, improvement] = snr_comparison(clean_signal, noisy_signal, filtered_signal, fs)
    % Compute SNR before filtering
    noise = noisy_signal - clean_signal;
    snr_before = 10 * log10(var(clean_signal) / var(noise));

    % Compute SNR after filtering
    noise_after = filtered_signal - clean_signal;
    snr_after = 10 * log10(var(clean_signal) / var(noise_after));

    % Calculate improvement as a percentage
    improvement = snr_after - snr_before;
    if isnan(snr_before) || isnan(snr_after)
        snr_before = 0;
        snr_after = 0;
        improvement = 0;
    end
    if abs(snr_before) > 1e-10
        improvement = (improvement / abs(snr_before)) * 100;
    else
        improvement = 0;
    end
end