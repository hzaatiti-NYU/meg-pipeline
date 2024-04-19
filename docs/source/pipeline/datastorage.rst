Data storage
------------


The data is securely stored on NYU BOX, access is given through invitations.
The *Data* folder is structured in the **BIDS** standardized format.
Please raise an issue on *github* repository if you think the structure does not conform to **BIDS**.

.. admonition:: Link to MEG data (Box Invitation Only)

    `https://nyu.box.com/v/meg-datafiles <https://nyu.box.com/v/meg-datafiles>`_


Data naming and uploading protocol
----------------------------------

In the following, [SUB_ID] should be replaced with the ID of the subject for naming purposes.
The different data files generated from a MEG experiment are the following.

.. note::
    If you have suggestions to make the naming convention better, please raise an issue on github
    or create a pull request with your proposed modifications.

Laser scan files
################

#. A .fsn filename that should be named ``sub-\[SUB_ID\]_scan.fsn`` : This file is obtained by saving
   the whole fastscan laser project (File Save)

#. Several .txt
    * ``sub-[SUB_ID]_scan.txt``  is the head scan of the participant
    * ``sub-[SUB_ID]_scan_stylus.txt`` is the stylus location file of the participant

KIT-MEG files
#############

Depending on the experiment, many .con files can be produced by the KIT machine.

#. .con files are named
    *. ``sub-[SUB_ID]_[date].con``
#. .mrk files are named
    *. ``sub-[SUB_ID]_[date].mrk``

OPM files
#########

The OPM system generates a BIDS directory with the .fif files


Data uploading
##############

Data uploading will be
