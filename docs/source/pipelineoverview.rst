Pipeline Description
====================
Lead author: Hadi Zaatiti

General overview
----------------

.. raw:: html
    :file: graphic/general_pipeline.drawio.html


.. _installation:


Data preparation
----------------

.. raw:: html
    :file: graphic/data_preparation.html


Head surface scan generates:
- _basic.txt
- _points.txt
- .fsn

MEGLab acquisition generates:
- .con file
- _NR.con file (after analysing noise reduction)
- .mrk : an experiment will produce atleast 2 .mrk files, they contain the markers data


All data generated from KIT or OPM are saved on NYU Box `Data access <https://nyu.box.com/s/wefkhu5yn7tzzhw2gcr45zvnsqqnbyuf>`_

.. note::
    The link is invitation based only and not publicly available.

Installation
------------

To use MEG-Pipeline, first install it using pip:

.. code-block:: console

   (.venv) $ pip install megpipeline

Reading the Raw Data
--------------------

The ``kind`` parameter should be either ``"raw"``, ``"fif"``,
or ``"fll"``.


.. literalinclude:: ../../pipeline/import_raw_data.py
  :language: python

The above script will later be implemented as part of the following class :py:class:`MEGpipeline` and function :py:func:`megpipeline.get_raw_data`.

.. autofunction:: megpipeline.MEGpipeline.get_raw_data

.. autoclass::MEGpipeline

The ``kind`` parameter should be either ``"raw"``, ``"fif"``,
or ``"fll"``. Otherwise, :py:func:`megpipeline.get_raw_data`
will raise an exception.



For example:

>>> import megpipeline
>>> megpipeline.get_raw_data()
['shells', 'gorgonzola', 'parsley']







Manual labelling of "bad" channels
----------------------------------


Denoising
---------

Awareness of the many sources of noise:

- Related to the site in which the MEG system is installed
- Related to conditions that could happen from time to time (parking garage nearby,)

Once the reasons are understood, we can identify the pattern that the noise makes.

With training data of the different possible noises, it is very possible to train a neural classifier
that could identify the noise coming from the different sources and be able to denoise it from the MEG data.


Independent component analysis
------------------------------

Independent component analysis (ICA) is commonly used to generate what is supposed a set of independent
signals from a given set of assumingly correlated signals.

The signals produced by MEG are highly correlated, therefore ICA is suitable to reduce correlation.
Given a set of MEG signal X(t), ICA learns a matrix W and the output signals S(t) such that

add latex here: X(t) = W.S(t)

ICA can perform well to identify the noise signals that has a certain long lasting continuous-time pattern, but less efficient when the noise is a single event, happening at irregular periods of time.

.. code-block:: python
   :caption: Calling ICA withint a Python pipeline

    projs, raw.info['projs'] = raw.info['projs'], []
    ica.fit(raw)
    raw.info['projs'] = projs


Frequency Analysis
------------------
Fast-oscillating signals means high frequencies, while slow oscillations are low frequencies.
In fourier space (signal represented by its Fourier transform) we can see the frequency components constituting
the signal. FFT (Fast Fourier Transform) algorithm is commonly to identify the frequency components.


Research showed that signals at different frequencies have different functions at different locations of the brain.
In other words, given a region of the brain, signals of frequency 8Hz are responsible of an activity that is much different than signals with frequency 20 Hz


Brain Source Estimate
---------------------

When neurons become active, they do so in large groups.




Code Overview
-------------

The code for an example.

.. code-block:: python
    :caption: This installs dependencies

    # Install required Meg-pipeline dependencies
    import matplotlib as plt
    import mne


Notebook test
-------------

.. include:: notebooks/test
