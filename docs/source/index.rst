###################################
MEG/EEG-pipeline documentation page
###################################


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

Check out the :doc:`1-systems/megsystem` section for further information, including
how to :ref:`installation` the project.

.. note::

   This project is under active development.


.. toctree::
   :maxdepth: 2
   :caption: Systems Overview

   1-systems/megsystem
   1-systems/opmsystem
   1-systems/eegsystem
   1-systems/quizz

.. toctree::
   :maxdepth: 2
   :caption: Operation Protocol

   2-operationprotocol/operationprotocol

.. toctree::
   :maxdepth: 2
   :caption: Experiments Design

   3-experimentdesign/experimentdesign
   3-experimentdesign/requirements

.. toctree::
   :maxdepth: 2
   :caption: Pipelines and Data

   4-pipeline/1-overview
   4-pipeline/2-datastorage
   4-pipeline/settingupenvironment
   4-pipeline/pipelines


.. toctree::
   :maxdepth: 2
   :caption: Maintenance

   5-maintenance/maintenance

.. toctree::
   :maxdepth: 2
   :caption: Emergency and Risk Asessment

   6-emergency/emergency

.. toctree::
   :maxdepth: 2
   :caption: Glossary and API

   glossary
   api
