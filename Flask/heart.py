import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from flask import Flask, request, send_file
import numpy as np
import librosa
import librosa.display
from PIL import Image
import os
import tensorflow as tf
import scipy.signal as signal
from io import BytesIO

app = Flask(__name__)
heart_model = tf.keras.models.load_model("/Users/rishikabethi/Desktop/Heart/heart_resnet_valid.hdf5")
urban_model = tf.keras.models.load_model('/Users/rishikabethi/Desktop/UrbanSound/urban_sound')

heart_d = {0: 'Artifact', 1: 'Extrasystole', 2: 'Murmur', 3: 'Normal'}
urban_d = {0: 'air_conditioner', 1: 'car_horn', 2: 'children_playing', 3: 'dog_bark', 4: 'drilling', 5: 'engine_idling', 6: 'gun_shot', 7: 'jackhammer', 8: 'siren', 9: 'street_music'}

# Step 1: Denoising using a low pass filter
def apply_low_pass_filter(audio, sampling_rate, cutoff_freq):
    nyquist_freq = 0.5 * sampling_rate
    normalized_cutoff_freq = cutoff_freq / nyquist_freq
    b, a = signal.butter(4, normalized_cutoff_freq, btype='low', analog=False)
    denoised_audio = signal.lfilter(b, a, audio)
    return denoised_audio

# Downsampling audio
def downsample_audio(audio, original_sampling_rate, target_sampling_rate):
    resampled_audio = librosa.resample(audio, orig_sr=original_sampling_rate, target_sr=target_sampling_rate)
    return resampled_audio

# Split audio into fixed-length segments
def split_audio(audio, segment_length):
    num_segments = len(audio) // segment_length
    segments = [audio[i*segment_length:(i+1)*segment_length] for i in range(num_segments)]
    return segments

def func(filename):
    audio, sample_rate = librosa.load(filename)
    mfccs_features = librosa.feature.mfcc(y=audio, sr=sample_rate, n_mfcc=40)
    mfccs_scaled_features = np.mean(mfccs_features.T,axis=0)
    mfccs_scaled_features=mfccs_scaled_features.reshape(1,-1)
    predicted_label=np.argmax(urban_model.predict(mfccs_scaled_features),axis=1)
    return urban_d[predicted_label[0]]

@app.route('/urban_predict',methods=['POST'])
def urban_predict():
    if 'audio' not in request.files:
        return 'No file provided', 400

    audio_file = request.files['audio']
    if not audio_file.filename.lower().endswith('.wav'):
        return 'Invalid file type, must be .wav', 400
    prediction = func(audio_file)
    return prediction
    # print(prediction)

@app.route('/predict', methods=['POST'])
def predict():
    if 'audio_file' not in request.files:
        return 'No audio found.', 400

    audio = request.files['audio_file']
    if not audio.filename.lower().endswith('.wav'):
        return 'Invalid file type, must be .wav', 400

    heart_class = []
    heart_confidence = []

    data, sampling_rate = librosa.load(audio, sr=None)

    # Denoising
    cutoff_frequency = 195
    denoised_audio = apply_low_pass_filter(data, sampling_rate, cutoff_frequency)

    # Downsampling
    target_sampling_rate = sampling_rate // 10
    downsampled_audio = downsample_audio(denoised_audio, sampling_rate, target_sampling_rate)

    # Splitting audio
    segment_length = target_sampling_rate * 3
    segments = split_audio(downsampled_audio, segment_length)
    
    for segment in segments:
        spectrogram = librosa.feature.melspectrogram(y=segment, sr=target_sampling_rate)

        # Convert to decibels
        spectrogram_db = librosa.power_to_db(spectrogram, ref=np.max)

        # Plot spectrogram
        plt.figure(figsize=(1.28, 1.28))
        librosa.display.specshow(spectrogram_db, sr=target_sampling_rate)
        plt.savefig('spectrogram.png', transparent=True)
        plt.close()

        img = Image.open('spectrogram.png').convert('RGB')
        img_arr = np.asarray(img)
        img_arr = img_arr / 255

        img_arr = img_arr.reshape(1, 128, 128, 3)

        prediction = heart_model.predict(img_arr)
        x = np.argmax(prediction)
        confidence = prediction[0, x]
        heart_class.append(heart_d[x])
        heart_confidence.append(confidence)
        os.remove('spectrogram.png')
    
    predicted_class = heart_class[heart_confidence.index(max(heart_confidence))]

    return predicted_class

@app.route('/waveplot', methods=['POST'])
def waveplot():
    if 'audio_file' not in request.files:
        return 'No audio found.', 400

    audio = request.files['audio_file']
    if not audio.filename.lower().endswith('.wav'):
        return 'Invalid file type, must be .wav', 400

    # Load audio data
    audio_data, sampling_rate = librosa.load(audio, sr=None)

    # Generate wave plot
    plt.figure(figsize=(6,2))
    librosa.display.waveshow(audio_data, sr=sampling_rate)
    plt.xlabel('Time')
    plt.ylabel('Amplitude')
    wave_buf = BytesIO()
    plt.savefig(wave_buf, format='png')
    wave_buf.seek(0)

    return send_file(wave_buf, mimetype='image/png')

@app.route('/specplot', methods=['POST'])
def specplot():
    if 'audio_file' not in request.files:
        return 'No audio found.', 400

    audio = request.files['audio_file']
    if not audio.filename.lower().endswith('.wav'):
        return 'Invalid file type, must be .wav', 400

    # Load audio data
    audio_data, sampling_rate = librosa.load(audio, sr=None)

    # Generate spectrogram plot
    spectrogram = librosa.feature.melspectrogram(y=audio_data, sr=sampling_rate)
    spectrogram_db = librosa.power_to_db(spectrogram, ref=np.max)
    plt.figure(figsize=(6,2))
    librosa.display.specshow(spectrogram_db, sr=sampling_rate)
    plt.xlabel('Time')
    plt.ylabel('Frequency')
    plt.colorbar(format='%+2.0f dB')
    spec_buf = BytesIO()
    plt.savefig(spec_buf, format='png')
    spec_buf.seek(0)
    return send_file(spec_buf, mimetype='image/png')

if __name__ == '__main__':
    app.run()
