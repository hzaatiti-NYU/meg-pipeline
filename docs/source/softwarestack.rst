Software stack
==============

There are different software that can be used in a MEG experiment:


MEG acquisition: MEGLAB

MEG experiment design:

* `PsychToolbox` package for MATLAB
* `PsycoPy`,


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






Running the experiment
----------------------

Navigate to `/Experiments/Samantha/Savant/main` and run the .exp

The stimulus buttons in the MEG lab seem to work fine
How to get the projector on?
