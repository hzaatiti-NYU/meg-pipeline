Operation Protocol
==================
Lead author:

Step 1 is to acquire a scan of the head surface generating a .ext (to be added) file for the participant

.. raw:: html
    :file: graphic/operational_protocol.drawio.html


Step 2 is to

.. raw:: html
    :file: graphic/meg_data_generation.drawio.html


Pipeline Overview
=================
Lead author: Hadi Zaatiti



.. raw:: html
    :file: graphic/overview_diagram.html




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
=============

The code for an example.

.. code-block:: python
    :caption: This installs dependencies

    # Install required Meg-pipeline dependencies
    import matplotlib as plt
    import mne