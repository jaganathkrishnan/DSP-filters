# 📡 Digital Signal Processing (DSP) Filters and Applications

## 📜 Overview
This project focuses on **Digital Signal Processing (DSP)** techniques, implementing **Finite Impulse Response (FIR)** and **Infinite Impulse Response (IIR) filters** in **MATLAB** for both **audio and image processing**. 

It allows users to **enhance speech, filter ECG signals, and apply image processing techniques** using an interactive **MATLAB GUI**. The project covers **windowing techniques**, **Butterworth and Chebyshev filters**, and **real-time filtering of audio and images**.

---

## 🚀 Features
✅ **FIR Filters**: Rectangular, Hanning, Hamming, Blackman, and Triangular Windows  
✅ **IIR Filters**: Butterworth & Chebyshev (Type I & II)  
✅ **Speech Processing**: Noise filtering for voice signals  
✅ **Biomedical Filtering**: Removing noise from ECG signals  
✅ **Image Filtering**: Low-Pass, High-Pass, Band-Pass, and Band-Stop filters for images  
✅ **SNR Performance Evaluation**: Signal-to-Noise Ratio (SNR) before and after filtering  
✅ **MATLAB GUI**: Upload an image/audio file, apply filters, and save the results  
✅ **Graphical & Frequency Response Visualization**  
## 🎛️ How to Use the MATLAB GUI
The **MATLAB GUI** allows users to:
1. **Upload an audio or image file**  
2. **Select a filter type (Low-Pass, High-Pass, Band-Pass, Band-Stop)**  
3. **Apply the selected filter**  
4. **View and save the processed output**  

### **🔹 Running the GUI**
1. **Open MATLAB** and navigate to the project directory.  
2. Run the GUI using:  
   ```matlab
   run('GUI/dsp_filter_gui.m')
3. Upload an image or audio file.
4. Select a filter and apply it.
5. View and save the filtered output.
🎤 Audio Processing
This project processes speech and general audio signals using FIR & IIR filters to:

1. Remove noise from speech signals
2. Apply band-pass filtering to extract important frequencies
3. Enhance audio quality for better clarity
🔹 Running Audio Filtering Scripts
1. Navigate to the Audio_Processing or Speech_Processing folder.
2. Open a script (e.g., speech_filtering.m) in MATLAB.
3. Run the script to process an audio file.
🏥 Biomedical Signal Processing (ECG Filtering)
This project filters ECG signals to remove 60Hz powerline interference and high-frequency noise.

🔹 Running ECG Filtering
1. Open MATLAB and navigate to the Biomedical_Processing folder.
2. Run the ECG filtering script to process an ECG signal.
🖼️ Image Processing
This project applies digital filtering to images using:

1. Low-Pass Filters (Blur & Noise Reduction)
2. High-Pass Filters (Edge Detection)
3. Band-Pass Filters (Sharpening)
4. Band-Stop Filters (Noise Suppression)
🔹 Running Image Filtering
1. Run the GUI and upload an image file.
2. Select a filter type and apply it.
3. View and save the filtered output.
📊 Performance Evaluation (SNR Comparison)
This project calculates the Signal-to-Noise Ratio (SNR) before and after filtering, showing how effectively the filters reduce noise.

🔹 Running SNR Evaluation
1. Navigate to the Performance_Evaluation folder.
2. Open the script for SNR comparison.
3. Run it to see how filtering improves signal quality.

📖 Installation & Running MATLAB Scripts

🔹 Clone the Repository
    git clone https://github.com/jaganathkrishnan/DSP-filters.git
    
    cd DSP-Filters-Project

🔹 Run MATLAB Scripts

1. Navigate to the correct folder (FIR, IIR, Speech, Biomedical, etc.).
2. Run a script, for example:
   ```matlab
    run('FIR_Filters/highpass_fir_filter.m')