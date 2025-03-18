function dsp_filter_gui
    fig = uifigure('Name', 'DSP Filter GUI', 'Position', [100 100 600 500]);

    % Upload Button
    btnUpload = uibutton(fig, 'Text', 'Upload File', 'Position', [50, 420, 120, 30]);
    btnUpload.ButtonPushedFcn = @(btnUpload, event) upload_file();

    % File Type Dropdown (Audio or Image)
    fileTypeDropDown = uidropdown(fig, 'Items', {'Audio', 'Image'}, ...
        'Position', [200, 420, 120, 30]);

    % Filter Selection Drop-Down
    filterDropDown = uidropdown(fig, 'Items', {'Low-Pass', 'High-Pass', 'Band-Pass', 'Band-Stop'}, ...
        'Position', [350, 420, 120, 30]);

    % Apply Filter Button
    btnApply = uibutton(fig, 'Text', 'Apply Filter', 'Position', [500, 420, 100, 30]);
    btnApply.ButtonPushedFcn = @(btnApply, event) apply_filter(filterDropDown.Value, fileTypeDropDown.Value);

    % Info Label for SNR Results
    snrLabel = uilabel(fig, 'Position', [50, 380, 500, 30], 'Text', 'SNR Before: -- dB | SNR After: -- dB | Improvement: --%');

    function upload_file()
        [file, path] = uigetfile({'*.wav', 'Audio Files (*.wav)'; '*.jpg;*.png', 'Image Files (*.jpg, *.png)'});
        if file ~= 0
            global input_data fs fileType;
            fileType = fileTypeDropDown.Value;
            fullFilePath = fullfile(path, file);

            if strcmp(fileType, 'Audio')
                [input_data, fs] = audioread(fullFilePath);
                uialert(fig, 'Audio file uploaded successfully!', 'Success');
            else
                input_data = imread(fullFilePath);
                uialert(fig, 'Image file uploaded successfully!', 'Success');
            end
        end
    end

   function apply_filter(filter_type, file_type)
    global noisy_signal fs fileType;
    if isempty(noisy_signal)
        uialert(fig, 'Upload a file first!', 'Error');
        return;
    end

    if strcmp(file_type, 'Audio')
        % Ensure Noisy Signal is Mono (1D Vector)
        if size(noisy_signal, 2) > 1
            noisy_signal = mean(noisy_signal, 2); % Convert Stereo to Mono
        end

        % Save a Copy of the Noisy Signal for SNR Computation
        original_noisy_signal = noisy_signal + 0.05 * randn(size(noisy_signal));

        % Apply 1D Audio Filtering
        N = 30;
        fc = 3000;
        switch filter_type
            case 'Low-Pass'
                h = fir1(N, fc/(fs/2), 'low', hamming(N+1));
            case 'High-Pass'
                h = fir1(N, fc/(fs/2), 'high', hamming(N+1));
            case 'Band-Pass'
                h = fir1(N, [1000 4000]/(fs/2), 'bandpass', hamming(N+1));
            case 'Band-Stop'
                h = fir1(N, [1000 4000]/(fs/2), 'stop', hamming(N+1));
        end
        filtered_audio = filter(h, 1, noisy_signal);

        % Normalize Filtered Audio to Prevent Clipping
        filtered_audio = filtered_audio / max(abs(filtered_audio));

        % Compute SNR (Avoiding NaN and Zero Noise)
        noise_before = noisy_signal - original_noisy_signal;
        noise_after = filtered_audio - original_noisy_signal;
        noise_before = max(noise_before, 1e-10);  % Avoid zero values
        noise_after = max(noise_after, 1e-10);

        snr_before = snr(original_noisy_signal, noise_before);
        snr_after = snr(original_noisy_signal, noise_after);
        noise_reduction = snr_after - snr_before;

        % Handle NaN Cases
        if isnan(snr_before) || isnan(snr_after)
            snr_before = 0;
            snr_after = 0;
            noise_reduction = 0;
        end

        % Ensure No Division by Zero
        if abs(snr_before) > 1e-10
            percentage_improvement = (noise_reduction / abs(snr_before)) * 100;
        else
            percentage_improvement = 100;
        end

        % Update GUI Label
        snrLabel.Text = sprintf('SNR Before: %.2f dB | SNR After: %.2f dB | Improvement: %.2f%%', snr_before, snr_after, percentage_improvement);

        % Save & Display Filtered Signal
        audiowrite('../data/filtered_output.wav', filtered_audio, fs);

        % Ensure Signal is Vector Before Spectrogram
        if isvector(noisy_signal) && isvector(filtered_audio)
            figure; 
            subplot(2,1,1); spectrogram(noisy_signal, 256, [], [], fs, 'yaxis'); title('Spectrogram Before Filtering');
            subplot(2,1,2); spectrogram(filtered_audio, 256, [], [], fs, 'yaxis'); title('Spectrogram After Filtering');
        else
            uialert(fig, 'Spectrogram cannot be computed: Input is not a 1D signal.', 'Error');
        end

    else
        % Apply 2D Image Filtering
        kernel_size = 5;
        switch filter_type
            case 'Low-Pass'
                h = fspecial('average', kernel_size);
            case 'High-Pass'
                h = -1 * ones(kernel_size) / (kernel_size^2);
                h(floor(kernel_size/2)+1, floor(kernel_size/2)+1) = 2;
            case 'Band-Pass'
                h1 = fspecial('gaussian', kernel_size, 1);
                h2 = fspecial('gaussian', kernel_size, 2);
                h = h1 - h2;
            case 'Band-Stop'
                h = fspecial('laplacian', 0.5);
        end

        % Apply the filter
        filtered_image = imfilter(noisy_signal, h, 'replicate');

        % Save and display the filtered image
        imwrite(filtered_image, '../data/filtered_output.png');
        figure; imshow(filtered_image);
        title(['Filtered Image - ', filter_type]);

        % No SNR Calculation for Images
        snrLabel.Text = 'Image Filtering Applied - No SNR Computation';
    end
end

end
