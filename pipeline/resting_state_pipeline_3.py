import mne
from mne.time_frequency import tfr_morlet
import matplotlib.pyplot as plt
import numpy as np

# Load your raw data (using an example dataset here)
raw1 = mne.io.read_raw_fif(r"C:\Users\hz3752\Box\MEG\Data\resting-state\sub-01\meg-kit\sub-01_01-eyes-closed-raw.fif", preload=True)

raw2 = mne.io.read_raw_fif(r"C:\Users\hz3752\PycharmProjects\mne_bids_pipeline\data\meg\Sub-0037\sub-01_02-eyes-open-raw.fif", preload=True)

croped_data1 = raw1.copy()

croped_data1.crop(100, 250)

croped_data2 = raw2.copy()

croped_data2.crop(100, 250)

# Select a specific channel by name
channel_name = 'MEG 194'  # Change this to the name of the channel you want to plot
channel_index = croped_data1.ch_names.index(channel_name)

# Define frequencies of interest
frequencies = np.arange(1, 51, 1)  # Frequencies from 1 to 50 Hz

# Define the number of cycles in each frequency
n_cycles = frequencies / 2.  # Different number of cycles per frequency




# Identify channels with zero or infinite values in the PSD
channels_with_issues = ['MEG 041', 'MEG 056', 'MEG 059', 'MEG 148', 'MEG 053', 'MEG 067', 'MEG 102', 'MEG 137', 'MEG 154', 'MEG 181', 'MEG 182', 'MEG 183', 'MEG 157']

# Mark bad channels
croped_data1.info['bads'] = channels_with_issues
croped_data2.info['bads'] = channels_with_issues

croped_data1 = croped_data1.copy().drop_channels(croped_data1.info['bads'])
croped_data2 = croped_data2.copy().drop_channels(croped_data1.info['bads'])



# Define the duration of each epoch (in seconds)
epoch_duration = 2  # 2 sec

epochs_closed = mne.make_fixed_length_epochs(croped_data1, duration=epoch_duration, preload=True)
epochs_open = mne.make_fixed_length_epochs(croped_data2, duration=epoch_duration, preload=True)




# Plot sensors with kind='select' to allow channel selection
fig, selected_channels = mne.viz.plot_sensors(raw1.info, kind='select', show_names=True)

# Show the plot to interactively select channels
import matplotlib.pyplot as plt
plt.show()

# Print the selected channels



selected_channels = [element for element in selected_channels if element not in channels_with_issues]

print("Selected channels:", selected_channels)

#selected_channels = ['MEG 149', 'MEG 208', 'MEG 194', 'MEG 205', 'MEG 129', 'MEG 170', 'MEG 165']

# Pick the specific channels
epochs_closed.pick(selected_channels)
epochs_open.pick(selected_channels)



# Plot PSD for cleaned data with labels
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6), sharex=True)


# Plot PSD for the first 1 minute (eyes closed)
# First half is eyes closed

epochs_closed.plot_psd(fmin=1, fmax=40, ax=ax1, color='blue', show=False, average=True, spatial_colors=False, line_alpha=0.5, dB=True, xscale='log')
epochs_open.plot_psd(fmin=1, fmax=40, ax=ax2, color='blue', show=False, average=True, spatial_colors=False, line_alpha=0.5, dB=True, xscale='log')


print('Plotting psd')

# Add labels
ax1.set(title='Power Spectral Density (First 1 Minute - Eyes Closed)', xlabel='Frequency (Hz)', ylabel='Power Spectral Density (dB)')
ax2.set(title='Power Spectral Density (Last 1 Minute - Eyes Open)', xlabel='Frequency (Hz)', ylabel='Power Spectral Density (dB)')

# Show the plot
plt.tight_layout()
plt.show()



# Compute the power spectral density (PSD) using Morlet wavelets
freqs = np.logspace(*np.log10([1, 40]), num=50)  # Define frequency range

n_cycles = freqs / 2

power_closed = tfr_morlet(epochs_closed, freqs=freqs, n_cycles=n_cycles, return_itc=False, average=True)


# Plot the PSD
fig, ax = plt.subplots(figsize=(10, 6))
power_closed.plot([0], baseline=None, mode='logratio', title='Average power', axes=ax, show=False)

plt.show()