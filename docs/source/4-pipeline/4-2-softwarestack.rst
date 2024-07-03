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


AC choosing: start with sagittal, pick the last end of the white matter fibers
then go to coronal and pick the point where the white matter fibers are linked from left to right hemisphere(above the black point)


Set the nasion on the surface of the skin, because the digitization is performed on the top of the ksin


Connectivity analysis:
SOme regions can be activated at the same time
However, in other situations, one region fires and then triggers other regions.

It is an unsolved question to identify which begins the activity

Source montage (add to glossary): is definition of the sources

Epilepsy:can be one region activated or many other regions activating at the same time
another kind of epilepsy where all the brain gets activated
another kind, right hemisphere then left hemisphere




MNe kit2fiff to get a fif from .con and .mrk
then open the .fif in BESA

To quickly inspect the data, and have a view of the field at a specific time, on a template head, within the sensor layout loaded from the .fif
you can enable in Options -> Mapping -> Enable direct mapping by double clicking
Then double click at a specific time and see the field on the template head

Radial activity within the brain cannot be picked up except for partially by the SQUIDS
There is examples folder in BESA, with different datasets

Algorithms for source localization
sLoreta, Loreta (named Clara in BESA, which is recursively applied), dspm
Equal end current dipole (good when the phenomona is triggered by one area of the brain and not multiple areas at once)
EQUILAVENT Current Dipole
Beamformer (

Issues to resolve:
- number of digitized head points, and alignment during coregistration
- triggers in oddball experiment how to pick them up by Besa software

Open file and clear DB(to erase previous settings)

- Identify the metrics used in computing the artifact rejection heatmap (see if we can have different metrics of these)

In artifact rejection:
Low signal is to cut flat signals (that are saturated with noise)



Question about PCA components time axis

Question: Save solution works for dipoles only but not for CLARA
Question: Saving activity coregistered with MRI-T1


If source analysis crashes using CLARA, reduce the voxel size


Source localization steps:

after coregistration, make sure in BESA Research, File, Coregistration, the coreg file is checked
define your trials and average them, then pick a window, right click -> source analysis
Pick BEM or FEM as conducting model. (the spherical model is only a template and is not used for source localization)
choose a window on the left top window then pick Clara or another algorithm


Check how the USB license can be hosted on a server


Agenda:
- global presentation on besa
- beamformer
- OPM trigger processing and coregistration

We can find the coregistration files in C:\Users\Public\Documents\BESA MRI\Projects\AS-oddball-task_19010101\

After source localization, you can use up and down arrows to change the sensitivity of the heatmap



SESAME uses bayesian statistics to estimate the number of sources, cortical loreta

Cortical Loreta = Loreta not on MRI but the reconstructed brain model (inflated or not inflated)

Batch-processing is the automation workflow in BESA to run similar steps multiple times

DONETODO:MATLAB import from BESA
DONETODO: seeding dipole


Clara operation: goes through each time point and does the inverse (for each time point) then show the average of the time region of activation

When to use Clara or Beamformer or SESAME?
Clinically: Clara (distributed model, each voxel have an activity) and Dipole fitting are approved clinically
For MEG: beamformer (coz MEG has better spatial separation than EEG)
SESAME (uses a dipole model, and does not assume that each voxel has an activity):
DONETODO: Clara followed by SESAME, CLARA can show you regions of activity, and then SESAME can use dipoles on these regions as a prior to its operation
a CLARA followed by SESAME should give a more accurate pointy result, you need to click Weight By Image (to use output of clara as input to sesame [prior])


PCA: The PCA can indicate how many sources you need, if you have 3 high activity components then you need 3 dipoles

right click a PCA component, and add to solution, this will show you where the dipole is located for that component


In Source Analysis: Residual to see what data is not covered, you can uncheck the data and keep the residual and then fit again just for the residual part

There is something called confidence level to see how the dipole explains the data (but this is nnot a validation)

In source analysis, never forget to set the baseline properly on areas where there is not much activity, prior to the stimulus






