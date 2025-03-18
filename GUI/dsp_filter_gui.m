function dsp_filter_gui
    % Create GUI Window
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

    function upload_file()
        [file, path] = uigetfile({'*.wav;*.jpg;*.png', 'Audio & Images (*.wav, *.jpg, *.png)'; ...
                                  '*.wav', 'Audio Files (*.wav)'; ...
                                  '*.jpg;*.png', 'Image Files (*.jpg, *.png)'});
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
        global input_data fs fileType;
        if isempty(input_data)
            uialert(fig, 'Upload a file first!', 'Error');
            return;
        end

        if strcmp(file_type, 'Audio')
            % Apply 1D Audio Filtering
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
            filtered_audio = filter(h, 1, input_data);
            audiowrite('../data/filtered_output.wav', filtered_audio, fs);
            figure; plot(filtered_audio);
            title(['Filtered Audio - ', filter_type]);

        else
            % Apply 2D Image Filtering
            kernel_size = 5;  % Define kernel size
            switch filter_type
                case 'Low-Pass'
                    h = fspecial('average', kernel_size);
                case 'High-Pass'
                    h = -1 * ones(kernel_size) / (kernel_size^2);
                    h(floor(kernel_size/2)+1, floor(kernel_size/2)+1) = 2;
                case 'Band-Pass'
                    h1 = fspecial('gaussian', kernel_size, 1); % Low-Pass
                    h2 = fspecial('gaussian', kernel_size, 2); % High-Pass
                    h = h1 - h2; % Band-Pass
                case 'Band-Stop'
                    h = fspecial('laplacian', 0.5); % Band-Stop approximation
            end

            % Apply the filter
            filtered_image = imfilter(input_data, h, 'replicate');

            % Save and display the filtered image
            imwrite(filtered_image, '../data/filtered_output.png');
            figure; imshow(filtered_image);
            title(['Filtered Image - ', filter_type]);
        end
    end
end
