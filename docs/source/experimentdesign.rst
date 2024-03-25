Your experiment design and requirements
=======================================

Purpose
-------

This section provides information to help you out designing your MEG experiment.
What is meant by experiment, is the stimuli involving usually visual and auditory or other perception-type stimulus.
The experiment defines the timing of display of the stimuli, tracks responses from the participants and controls the different settings related
to the content being presented to the participant.
This section also provides the requirements that should be met to run your experiment in the NYUAD MEG Lab.

There are three tools primarily used for designing the experiment

- Psychotoolbox
- Presentation
- Psychopy


Experiment example
------------------

- Resting state experiment: Using PsychToolBox the following script executes a resting state experiment.

The participant is asked to close their eyes for some time, then to open their eyes while fixing a centered shape for a same duration.
Two triggers are sent from the 'Datapixx3' to the KIT-MEG on channels 224 (closing eyes) and 225 (opening eyes).
The code for the experiment can be found here: Source file link
`resting_state_meg.m <https://github.com/hzaatiti-NYU/meg-pipeline/blob/main/experiments/general/resting_state_meg.m>`_.

`resting_state_meg.m <../../experiments/general/resting_state_meg.m>`_.

.. literalinclude:: ../../experiments/general/resting_state_meg.m
  :language: matlab

- Response buttons experiment



Files produced by the experiment design
---------------------------------------


An experiment in PsychToolBox is a `.m` MATLAB script.

Presentation provides a `.exp` file, an experiment file.
PsychoPy is a `.py` experiment file.

We will be using as example:

"Is this a real Arabic word?" Samantha experiment



If using python library PsychoPy:

* Open the file with .psyexp extension
* you can run from within the psycopy builder the experiment file with .psyexp extension c

