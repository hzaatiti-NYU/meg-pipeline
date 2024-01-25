Usage
=====

.. _installation:

Installation
------------

To use MEG-Pipeline, first install it using pip:

.. code-block:: console

   (.venv) $ pip install megpipeline

Creating recipes
----------------

To retrieve a list of random ingredients,
you can use the ``megpipeline.get_random_ingredients()`` function:

.. autofunction:: megpipeline.get_random_ingredients

The ``kind`` parameter should be either ``"meat"``, ``"fish"``,
or ``"veggies"``. Otherwise, :py:func:`megpipeline.get_random_ingredients`
will raise an exception.

.. autoexception:: megpipeline.InvalidKindError

For example:

>>> import megpipeline
>>> megpipeline.get_random_ingredients()
['shells', 'gorgonzola', 'parsley']

