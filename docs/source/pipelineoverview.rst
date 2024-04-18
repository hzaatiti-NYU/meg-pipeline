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










Notebooks
---------

.. toctree::
   :maxdepth: 2

   notebooks/test

