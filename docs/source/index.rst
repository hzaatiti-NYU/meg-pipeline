###################################
MEG/EEG-pipeline documentation page
###################################


************************************
Chapter -- Asterisks above and below
************************************


Title -- Number Signs
#####################

Suptitle -- Asterisks
*********************

Section -- Equal Signs
======================

Subsection -- Hyphens
---------------------

Subsubsection -- Circumflex
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Paragraph -- Double Quotes
""""""""""""""""""""""""""


Status of the documentation build

.. image:: https://readthedocs.org/projects/meg-pipeline/badge/?version=latest
    :target: https://example-sphinx-basic.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

**MEG/EEG-pipeline** provides documentation for the Magnetoencephalography (MEG) and ElectroEncephaloGraphy (EEG) systems in the MEG laboratory and EEG setup within Brain Imaging Core Technology Platform.
It offers a *simple* and *intuitive* overview on how MEG machines work, the specification of the system, what kind of data are generated and how to process them using *ready-to-use* pipelines. This documentation additionally provides a guide to build your own MEG-system experiment and what is required to successfully execute the experiment.

If you like to get a .PDF document of this website, click here `Download PDF <https://meg-pipeline.readthedocs.io/_/downloads/en/latest/pdf/>`_


.. image:: graphic/MEG-image.png
  :width: 400
  :alt: AI generated MEG-system image

Check out the :doc:`systems/megsystem` section for further information, including
how to :ref:`installation` the project.

.. note::

   This project is under active development.

********
Contents
********

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Systems Overview

   systems
   systems/megsystem
   systems/opmsystem
   systems/eegsystem
   systems/quizz

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Experiments and operational protocol
   experimentdesign
   operationprotocol

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Data storage and pipeline processing
   pipelineoverview
   pipeline/datastorage
   pipeline/kit2fif
   pipeline/softwarestack

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Maintenance and Emergency procedures
   maintenance
   maintenance-emergency/maintenance
   maintenance-emergency/emergency

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Glossary and API
   glossary
   api
