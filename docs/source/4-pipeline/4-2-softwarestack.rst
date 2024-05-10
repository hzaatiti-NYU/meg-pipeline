Software stack
==============





MEG data analysis:

* `LabMaestroSimulator`
* BEESA
* MNE Python library




Example:
--------
Samantha's experiment called Arabic Tark_VpixxEdit contains a .sce, .exp, .tem

What is Tark Localizer?

they are called
Tark_Localiser.sce
Task_localiser.exp
Tark_Loc_Main_Trial_GR.tem


When you open the .sce, you see a code that define the name of the scenario, font size, active buttons



Everytime the experiment is ran, a logfile seems to be created in




Output:

On the computer of the MEG MAIN PC, an experiment can yield different files:

* a .con file shows the signals on top of each other, and the strength of the magnetic field on what part of the brain the unit can be
    * pT: picoTesla
    * fT: femtoTesla
* a .mrk file


This website adds quite a few details to these extensions https://mne.tools/stable/auto_tutorials/io/10_reading_meg_data.html




The files can be opened with `MEG Lab`



BESA Software
=============

The following steps are primary to process MEG data using the BESA MRI and BESA Research suite

You have MRI data of your participant
-------------------------------------

Open BESA MRI, start a new segmentation project, check all the segmentation options (especially BEM and FEM), pick the landmarks for segmentation
and start the process. Once done, BESA will save the segmentation, BEM, FEM model outputs.

In BESA MRI, start a new coregistration project.

Open BESA Research, load your MEG data from a .fif format.








