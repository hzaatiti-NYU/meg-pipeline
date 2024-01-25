Usage
=====

.. _installation:

Installation
------------

To use MEG-Pipeline, first install it using pip:

.. code-block:: console

   (.venv) $ pip install meg-pipeline

Creating recipes
----------------

To retrieve a list of random ingredients,
you can use the ``meg-pipeline.get_random_ingredients()`` function:

.. autofunction:: meg-pipeline.get_random_ingredients

The ``kind`` parameter should be either ``"meat"``, ``"fish"``,
or ``"veggies"``. Otherwise, :py:func:`meg-pipeline.get_random_ingredients`
will raise an exception.

.. autoexception:: meg-pipeline.InvalidKindError

For example:

>>> import meg-pipeline
>>> meg-pipeline.get_random_ingredients()
['shells', 'gorgonzola', 'parsley']

