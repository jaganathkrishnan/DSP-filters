function dsp_filter_gui
    fig = uifigure('Name', 'DSP Filter GUI', 'Position', [100 100 500 400]);

    % Upload Button
    btnUpload = uibutton(fig, 'Text', 'Upload Audio', 'Position', [50, 350, 120, 30]);
    btnUpload.ButtonPushedFcn = @(btnUpload, event) upload_audio();

    % Filter Selection Drop-Down
    filterDropDown = uidropdown(fig, 'Items', {'Low-Pass', 'High-Pass', 'Band-Pass', 'Band-Stop'}, ...
        'Position', [200, 350, 120, 30]);

    % Apply Filter Button
    btnApply = uibutton(fig, 'Text', 'Apply Filter', 'Position', [350, 350, 100, 30]);
    btnApply.ButtonPushedFcn = @(btnApply, event) apply_filter(filterDropDown.Value);

    function upload_audio()
        [file, path] = uigetfile('*.wav');
        if file ~= 0
            global audio_signal fs;
            [audio_signal, fs] = audioread(fullfile(path, file));
            uialert(fig, 'Audio uploaded successfully!', 'Success');
        end
    end

    function apply_filter(filter_type)
        global audio_signal fs;
        if isempty(audio_signal)
            uialert(fig, 'Upload an audio file first!', 'Error');
            return;
        end

        % Apply the selected filter
        N = 50;
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
        filtered_audio = filter(h, 1, audio_signal);
        audiowrite('../data/filtered_output.wav', filtered_audio, fs);
        figure; plot(filtered_audio);
        title(['Filtered Audio - ', filter_type]);
    end
end
