# import mne
#
# # mne.gui.coregistration(
# #     inst="C:/Users/hz3752/Desktop/MEG/Data/meg_data/sub-GS/sub-GS_01_analysis_01-raw.fif",
# #     subject='Sub0255',
# #     subjects_dir='C:/Users/hz3752/Desktop/MEG/Data/subjects/sub-GS',  # contains a sub-folder for subject
# #     head_high_res=True,
# #     # trans=None,  # only if you already have one
# #     interaction='terrain',
# # )
#
#
# mne.gui.coregistration(
#     inst='../input_data/meg/Y0119/Y0119_SavantAra_1-40-raw.fif',
#     subject='Y0119',
#     subjects_dir='../input_data/mri/',  # contains a sub-folder for subject
#     head_high_res=True,
#     # trans=None,  # only if you already have one
# )



import mne
from PyQt5.QtWidgets import QApplication
import sys

app = QApplication.instance()  # checks if QApplication already exists
if not app:  # create QApplication if it doesnt exist
    app = QApplication(sys.argv)

mne.gui.coregistration(
    inst='../input_data/meg/Y0119/Y0119_SavantAra_1-40-raw.fif',
    subject='Y0119',
    subjects_dir='../input_data/mri/',  # contains a sub-folder for subject
    head_high_res=True,
)

app.exec_()



