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


Installation
------------

To use MEG-Pipeline, first install it using pip:

.. code-block:: console

   (.venv) $ pip install megpipeline

Reading the Raw Data
--------------------

To retrieve a list of random ingredients,
you can use the ``megpipeline.get_raw_data()`` function:

.. autofunction:: megpipeline.get_raw_data

The ``kind`` parameter should be either ``"raw"``, ``"fif"``,
or ``"fll"``. Otherwise, :py:func:`megpipeline.get_raw_data`
will raise an exception.



For example:

>>> import megpipeline
>>> megpipeline.get_raw_data()
['shells', 'gorgonzola', 'parsley']




Manual labelling of "bad" channels
----------------------------------




Independent component analysis
------------------------------

Independent component analysis (ICA) is commonly used to generate what is supposed a set of independent
signals from a given set of assumingly correlated signals.

The signals produced by MEG are highly correlated, therefore ICA is suitable to reduce correlation.
Given a set of MEG signal X(t), ICA learns a matrix W and the output signals S(t) such that

add latex here: X(t) = W.S(t)

.. code-block:: python
   :caption: Calling ICA withint a Python pipeline

    projs, raw.info['projs'] = raw.info['projs'], []
    ica.fit(raw)
    raw.info['projs'] = projs


Code Overview
-------------

The code for an example.

.. code-block:: python
    :caption: This installs dependencies

    # Install required Meg-pipeline dependencies
    import matplotlib as plt
    import mne




