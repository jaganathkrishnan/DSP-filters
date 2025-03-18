function dsp_filter_gui
    [current_path, ~, ~] = fileparts(mfilename('fullpath')); 
    base_path = fullfile(current_path, '..'); % Parent directory (DSP-filters/)
    fir_path = fullfile(base_path, 'FIR-Filters');
    iir_path = fullfile(base_path, 'IIR-Filters');
    utils_path = fullfile(base_path, 'Performance evaluation');
    
    % Add paths if not already in MATLAB path
    if ~contains(path, fir_path), addpath(fir_path); end
    if ~contains(path, iir_path), addpath(iir_path); end
    if ~contains(path, utils_path), addpath(utils_path); end

    % GUI Setup
    fig = uifigure('Name', 'DSP Filter GUI', 'Position', [100 100 600 500]);
    btnUpload = uibutton(fig, 'Text', 'Upload File', 'Position', [50, 420, 120, 30], ...
        'ButtonPushedFcn', @upload_file);
    fileTypeDropDown = uidropdown(fig, 'Items', {'Audio', 'Image'}, 'Position', [200, 420, 120, 30]);
    filterDropDown = uidropdown(fig, 'Items', {'High-Pass', 'Band-Pass', 'Band-Stop', 'Chebyshev', 'Butterworth'}, ...
        'Position', [350, 420, 120, 30]);
    btnApply = uibutton(fig, 'Text', 'Apply Filter', 'Position', [500, 420, 100, 30], ...
        'ButtonPushedFcn', @(btn, event) apply_filter(filterDropDown.Value, fileTypeDropDown.Value));
    snrLabel = uilabel(fig, 'Position', [50, 380, 500, 30], 'Text', 'SNR Before: -- dB | SNR After: -- dB | Improvement: --%');

    function upload_file(~, ~)
        [file, path] = uigetfile({'*.wav', 'Audio Files (*.wav)'; '*.jpg;*.png', 'Image Files (*.jpg, *.png)'});
        if file ~= 0
            global input_data fs fileType clean_signal;
            fileType = fileTypeDropDown.Value;
            fullFilePath = fullfile(path, file);
            if strcmp(fileType, 'Audio')
                [input_data, fs] = audioread(fullFilePath);
                clean_signal = input_data;
                uialert(fig, 'Audio file uploaded successfully!', 'Success');
            else
                input_data = imread(fullFilePath);
                clean_signal = input_data;
                uialert(fig, 'Image file uploaded successfully!', 'Success');
            end
        end
    end

    function apply_filter(filter_type, file_type)
        global clean_signal fs fileType;
        if isempty(clean_signal)
            uialert(fig, 'Upload a file first!', 'Error');
            return;
        end
        if strcmp(file_type, 'Audio') && isempty(fs)
            uialert(fig, 'Sampling frequency (fs) not defined. Please upload an audio file.', 'Error');
            return;
        end

        if strcmp(file_type, 'Audio')
            process_audio(clean_signal, fs, filter_type, snrLabel);
        else
            process_image(clean_signal, filter_type, snrLabel);
        end
    end

    function process_audio(clean_signal, fs, filter_type, snrLabel)
        if size(clean_signal, 2) > 1, clean_signal = mean(clean_signal, 2); end
        noisy_signal = clean_signal + 0.3 * sin(2 * pi * 2500 * (0:1/fs:(length(clean_signal)-1)/fs)');
        switch filter_type
            case 'High-Pass'
                filtered_audio = highpass_fir_filter(noisy_signal, fs);
            case 'Band-Pass'
                filtered_audio = bandpass_fir_filter(noisy_signal, fs);
            case 'Band-Stop'
                filtered_audio = bandstop_fir_filter(noisy_signal, fs);
            case 'Chebyshev'
                filtered_audio = chebyshev_filter(noisy_signal, fs);
            case 'Butterworth'
                filtered_audio = butterworth_filter(noisy_signal, fs);
        end
        filtered_audio = normalize_signal(filtered_audio);
        [snr_before, snr_after, improvement] = snr_comparison(clean_signal, noisy_signal, filtered_audio, fs);
        update_label(snrLabel, 'SNR', snr_before, snr_after, improvement);
        audiowrite(fullfile(base_path, 'data', 'filtered_output.wav'), filtered_audio, fs);
        plot_spectrogram(noisy_signal, filtered_audio, fs);
    end

    function process_image(clean_image, filter_type, snrLabel)
        clean_image = double(clean_image);
        noisy_image = clean_image + 0.05 * randn(size(clean_image));
        filtered_image = apply_image_filter(noisy_image, filter_type);
        update_label(snrLabel, 'PSNR', 0, 0, 0); % Placeholder since no PSNR computed
        imwrite(uint8(filtered_image), fullfile(base_path, 'data', 'filtered_output.png'));
        figure; imshow(filtered_image); title(['Filtered Image - ', filter_type]);
    end

    function signal = normalize_signal(signal)
        signal = signal / max(abs(signal));
    end

    function plot_spectrogram(noisy, filtered, fs)
        if isvector(noisy) && isvector(filtered)
            figure;
            subplot(2,1,1); spectrogram(noisy, 256, [], [], fs, 'yaxis'); title('Spectrogram Before Filtering');
            subplot(2,1,2); spectrogram(filtered, 256, [], [], fs, 'yaxis'); title('Spectrogram After Filtering');
        else
            uialert(gcf, 'Spectrogram cannot be computed: Input is not a 1D signal.', 'Error');
        end
    end

    function filtered = apply_image_filter(image, filter_type)
        kernel_size = 5;
        switch filter_type
            case 'High-Pass'
                h = -1 * ones(kernel_size) / (kernel_size^2);
                h(floor(kernel_size/2)+1, floor(kernel_size/2)+1) = 2;
            case 'Band-Pass'
                h1 = fspecial('gaussian', kernel_size, 1);
                h2 = fspecial('gaussian', kernel_size, 2);
                h = h1 - h2;
            case 'Band-Stop'
                h = fspecial('laplacian', 0.5);
            case {'Chebyshev', 'Butterworth'}
                h = fspecial('average', kernel_size);
        end
        filtered = imfilter(image, h, 'replicate');
    end

    function update_label(label, type, before, after, improvement)
        if strcmp(type, 'SNR')
            label.Text = sprintf('%s Before: %.2f dB | %s After: %.2f dB | Improvement: %.2f%%', ...
                type, before, type, after, improvement);
        else
            label.Text = sprintf('%s Before: -- dB | %s After: -- dB | Improvement: -- dB', ...
                type, type);
        end
    end
end