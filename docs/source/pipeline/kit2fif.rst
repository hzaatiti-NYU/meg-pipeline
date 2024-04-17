
Kit2Fiff Tutorial
=================

There are multiple files produced before and during magnetoencephalography. We will use the following here:

- Headscan basic surface .txt
- Headscan points .txt
- Marker measurement (x2) .mrk
- MEG recording .con

Kit2Fiff
--------

The first step is to convert the recording into a standard format for analysis in MNE, the premier software suite for M/EEG analysis.

1. Launch your terminal and activate your anaconda environment for MNE analysis. If you haven’t set up an environment yet, do so.

2. In your terminal, run ``mne kit2fiff``. This will launch a GUI with the following interface:

3. Using the diagram here as a guide, join the files listed above:


.. image:: ../graphic/kit2fif1.png
  :alt: AI generated MEG-system image


After the files are all loaded, you will see the headscan plotted in the gray panel in the middle of the GUI. You can rotate it around. A small sanity check should be performed here to see if the markers are in their expected position around the head.

.. note:: The parameters indicated by the red circle below should be set according to the experiment control software.

For experiments run in PsycoPy, the events should be indicated as “Trough”, and for experiments run in Presentation, the triggers should be indicated as “Peak”. Click “Find Events”. If you find a list of events, you probably do have triggers indicating stimuli times. Hooray! If not, make sure the parameters in red are set as shown here. If that doesn’t fix it, triggers were not sent properly.

4. After making sure the correct event type is selected for the experiment control software used, save the file by clicking on “Save Fiff”. MNE suggests a filename; it is good practice to use the following naming convention: ``subjID_experimentname-raw.fiff``.

5. When the .fiff has been saved, close the GUI.

Coreg without native MRI
-----------------------

In your terminal, run ``mne coreg``. This will launch a GUI with the following interface.

1. Navigate to the MRI folder for your experiment in the spot indicated by the blue arrow. If this is the first coreg you are processing for this dataset, you will need to put the fsaverage in the MRI folder to serve as a basis for transformations of your subjects’ heads.

2. In Digitization Source, put the .fiff created from earlier for the appropriate subject.

.. note:: This part of the preprocessing takes the most subjective judgment and hard work thus far.

You will need to align the white net of dots (representing the MEG recording linked with the subject headshape) to the fsaverage headshape. You will do this by manipulating two parameters: translation of the net and transformation of the fsaverage headshape. The former is done with the controls in blue. Current versions of MNE allow the translation to be performed automatically by hitting the buttons marked “Fit (ICP)” and “Fit Fid.”. Fit (ICP) will fit the white dots to the headshape. Fit Fid will fit the markers/points to the headshape markers/points. This approach should be alternated with transforming the headshape using the controls in red. First, you should change Scaling mode to “3-axis”. This will allow the headshape to be transformed in three dimensions independently. To transform, hit Fit (ICP) within red.

.. note:: If a subject had a particularly thick hairstyle, you can add hair by putting a number (in mm) in green. You can also omit white dots that are too far


