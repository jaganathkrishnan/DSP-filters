function filtered_signal = band_stop_filter(input_signal, fs)
    N = 50;
    fc1 = 2000; fc2 = 3000; % Band-stop range from your GUI
    h = fir1(N, [fc1 fc2]/(fs/2), 'stop', hamming(N+1));
    filtered_signal = filter(h, 1, input_signal);
end