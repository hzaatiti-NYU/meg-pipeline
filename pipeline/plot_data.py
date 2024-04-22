import mne


# Replace 'your_data-raw.fif' with the path to your FIFF file
raw = mne.io.read_raw_fif(r'C:\Users\hz3752\Box\MEG\Data\resting-state\sub-01\meg-kit\sub-01_01-eyes-closed-raw.fif')




# Specify the channel name you want to plot
channel_name = 'MISC 001'
raw.pick_channels([channel_name])
scalings = {'misc':0.1}

raw.plot(scalings = scalings, duration=320, start=0, n_channels=1)


