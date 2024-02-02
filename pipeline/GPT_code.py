import mne

# Replace these file paths with your actual file paths
mrk_file = 'path_to_your.mrk'
con_file = './MEG_DATA_HADI/Y0440/Mahdi_Y0440_01.con'
fsn_file = 'path_to_your.fsn'  # If you have this file
output_fif_file = 'output_file.fif'

# Load the raw data
raw = mne.io.read_raw_ctf(con_file, preload=True)

# Add marker information
# This step is specific to how your markers are defined in the .mrk file
# You might need to write custom code to read and align marker data

# Add fine calibration information (if you have an .fsn file)
# If your dataset requires fine calibration, you can apply it here
# This is often specific to the Neuromag system

# Save the data in FIF format
raw.save(output_fif_file, overwrite=True)
