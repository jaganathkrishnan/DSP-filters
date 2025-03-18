function filtered_signal = high_pass_filter(input_signal, fs)
    N = 50;
    fc = 3000; % Cutoff frequency from your GUI
    h = fir1(N, fc/(fs/2), 'high', hamming(N+1));
    filtered_signal = filter(h, 1, input_signal);
end