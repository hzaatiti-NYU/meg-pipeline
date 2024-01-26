MEG System description
======================

.. image:: graphic/meg-system.png
  :alt: MEG System

The MEG  Room

The magnetically shielded room is a product of Vacuumschmelze (Hanau, Germany). The shielding effect is provided by two layers of mu metal; the inner layer is 3 mm and the outer layer is 2 mm thick. Predicted shielding performance was rated to be -60 dB at 1 Hz; actual performance exceeds this prediction. The exterior dimensions of the room are 2.9 x 3.5 x 2.9 m, and the inner dimensions are 2.4 x 3.0 x 2.4 m.

We refer to our system as having 160 channels, but in actuality it contains:

157 axial gradiometers used to measure brain activity,

3 orthogonally-oriented (reference) magnetometers located in the dewar but away from the brain area, used to measure and reduce external? noise offline, and

32 open positions, of which we currently use 8 to record stimulus triggers and the other 24 channels to record Eye Tracker data directly, auditory signals from our mixer and vocalization information from our optoacoustic fiber-optic microphone.

The system is located inside a magnetically shielded room.







References
----------

The following is a list of references for further understanding on MEG systems

* MNE-Python: Overview and tutorials
    * https://mne.tools/stable/auto_tutorials/intro/10_overview.html#sphx-glr-auto-tutorials-intro-10-overview-py

* Marijn van Vliet's "Introduction to MNE-Python"
    * https://mybinder.org/v2/gh/wmvanvliet/neuroscience_tutorials/master?filepath=mne-intro%2Findex.ipynb

* Processing and analysis scripts from various Nellab members/alumni
    * https://github.com/benebular/mne-python-preproc-templates
    * https://github.com/jdirani/MEGmvpa
    * https://github.com/jdirani/mne-preprocessing-template
    * https://github.com/jdirani/meg-analysis-templates
    * https://github.com/grahamflick/Nellab-MRI-Pipeline
    * https://github.com/grahamflick/Tools-for-Combined-MEG-and-Eye-tracking

* Kit2fiff and ICA examples:
    * https://docs.google.com/document/d/1zoxPCngUmyXuKYTNWM8W-_ncTld9okRuYncGXdVUtV0/edit?usp=sharing
    * https://docs.google.com/document/d/1OrVP9ts1gTGB5fhzx8YcK3JKZQgm0HM4Ic3hKtVzHzA/edit?usp=sharing
    * https://docs.google.com/document/d/1X9Tj28ekJ93TubJ52TnrebDvIh8zeXHLp2aMURNV40Y/edit?usp=sharing


* Books:
    * Hansen, Peter & Kringelbach, Morten & Salmelin, Riitta. (2010). MEG: An introduction to methods. 10.1093/acprof:oso/9780195307238.001.0001.