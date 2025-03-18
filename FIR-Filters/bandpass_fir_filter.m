function filtered_signal = band_pass_filter(input_signal, fs)
    N = 50;
    fc1 = 1000; fc2 = 2000; % Band-pass range from your GUI
    h = fir1(N, [fc1 fc2]/(fs/2), 'bandpass', hamming(N+1));
    filtered_signal = filter(h, 1, input_signal);
end