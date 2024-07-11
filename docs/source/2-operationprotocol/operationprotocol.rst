Operation Protocol
==================
Lead author:


Advice to participants: 1.	Don’t bring any magnetic things (e.g., a magnet) into the MSR.
Strong magnetic fields may cause damage to the MEG sensors.

Step 1 is to acquire a scan of the head surface generating a .ext (to be added) file for the participant

.. raw:: html
    :file: ../graphic/operation_protocol.drawio.html


Step 2 is to

.. raw:: html
    :file: ../graphic/meg_data_generation.drawio.html




Noise reduction of the .con data
--------------------------------

Open the .con file in the default app `MEG160` then apply a Noise Reduction filter using Edit -> Noise Reduction
Make sure the Magnetometers on channels 208, 209, 210 are used.
Execute the noise reduction, then File -> Save As -> add `_NR` at the end of the file name.
Transfer both files to NYU BOX as detailed in the data uploading section.


Stylus location and markers
---------------------------

.. image:: ../graphic/markers1.jpeg
  :width: 400
  :alt: AI generated MEG-system image

.. image:: ../graphic/markers2.jpeg
  :width: 400
  :alt: AI generated MEG-system image


The following table sumarises the position of each registered stylus location and whether or not a KIT coil will be placed on that position.

+-------+-----------------+--------------------------------------+
| Index | Body Part       | Marker Coil Information              |
+=======+=================+======================================+
| 1     | Nasion          | KIT: NO, OPM:                        |
+-------+-----------------+--------------------------------------+
| 2     | Left Traps      | KIT: NO, OPM:                        |
+-------+-----------------+--------------------------------------+
| 3     | Right Traps     | KIT: NO, OPM:                        |
+-------+-----------------+--------------------------------------+
| 4     | Left Ear        | KIT: YES, OPM:                       |
+-------+-----------------+--------------------------------------+
| 5     | Right Ear       | KIT: YES, OPM:                       |
+-------+-----------------+--------------------------------------+
| 6     | Center Forehead | KIT: YES, OPM:                       |
+-------+-----------------+--------------------------------------+
| 7     | Left Forehead   | KIT: YES, OPM:                       |
+-------+-----------------+--------------------------------------+
| 8     | Right Forehead  | KIT: YES, OPM:                       |
+-------+-----------------+--------------------------------------+



Training to become an MEG authorized operator
=============================================

A project owner can be trained by the MEG lab scientists to become an authorized operator.
Over the course of a day, they will be taught about the operation protocol described above, the emergency procedures to perform, the safety rules to folow and any
operation that must be done in the lab prior/post data acquisition.

Once the training is performed, the folowing form should be submitted to the MEG lab scientists.

.. note::
    `Access to training attendance form <https://docs.google.com/forms/d/e/1FAIpQLScLW1MOvo-9aAwX2_04FcyLGPR9xtDso9hu9SEixUy2VzuAiw/viewform>`_