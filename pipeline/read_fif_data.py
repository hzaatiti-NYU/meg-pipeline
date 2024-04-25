import mne
import matplotlib.pyplot as plt

raw = mne.io.read_raw_fif('../output/Y0440/Y0440_01_meg.fif')

raw.crop(11.5, 302.9).load_data()



raw.plot(duration = 15)
print(raw.info.get_channel_types())

plt.show()

b=1