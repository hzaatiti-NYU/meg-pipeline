import mne
import matplotlib.pyplot as plt

raw = mne.io.read_raw_fif(r'C:\Users\hz3752\Box\MEG\Data\resting-state\sub-01\meg-kit\sub-01_01-eyes-closed-raw.fif')

raw.crop(11.5, 302.9).load_data()



raw.plot(duration = 15)
print(raw.info.get_channel_types())

plt.show()