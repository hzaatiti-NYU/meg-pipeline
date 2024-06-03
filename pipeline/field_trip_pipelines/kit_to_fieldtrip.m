% MRI-MEG KIT coregisteration
clear all
close all
clc
% It is important that you use T1.mgz instead of orig.mgz as T1.mgz is normalized to [255,255,255] dimension
mrifile     = fullfile('/Users/oa22/Desktop/toolkit2024/practice/meg_kit_oddball/T1w/T1w_acpc_dc_restore.nii.gz');
confile    = fullfile('/Users/oa22/Desktop/toolkit2024/practice/meg_kit_oddball/sub-03-raw-kit.con');    
laser_surf = fullfile('/Users/oa22/Desktop/toolkit2024/practice/meg_kit_oddball/sub-03-basic-surface.txt');
laser_points = '/Users/oa22/Desktop/toolkit2024/practice/meg_kit_oddball/sub-03-stylus.txt';
mrkfile1 = '/Users/oa22/Desktop/toolkit2024/practice/meg_kit_oddball/240524-1.mrk'
mrkfile2 = '/Users/oa22/Desktop/toolkit2024/practice/meg_kit_oddball/240524-2.mrk'
%% Read Laser headshape (points and fudicials)
lasershape   = read_head_shape_laser(laser_surf,laser_points);
lasershape   = ft_convert_units(lasershape, 'cm');
laser2ctf = ft_headcoordinates(lasershape.fid.pos(1,:),lasershape.fid.pos(4,:),lasershape.fid.pos(5,:),'ctf');
lasershape = ft_transform_geometry(laser2ctf, lasershape)
ft_determine_coordsys(lasershape, 'interactive', 'no')
% Deface the laser mesh under a certain plan (change the 140) Define the configuration for ft_defacemesh
planecut = 140;
cfg = [];
cfg.method    = 'plane';       % Use a plane for exclusion
cfg.translate = [0 planecut 0]; % A point on the plane (adjust z_value as needed)
cfg.rotate    = [0 0 0];       % Rotation vector, modify if the plane is not axis-aligned
cfg.selection = 'outside';     % Remove points below the plane
% Apply ft_defacemesh to remove points below the plane
mesh = ft_defacemesh(cfg, lasershape);
% Plot the resulting mesh to check the results
ft_plot_mesh(mesh);
lasershape = mesh
%% read mri and mri-headshape
mri = ft_read_mri(mrifile); % read mri file
mri = ft_convert_units(mri, 'cm'); %make sure units cm
% mri = ft_determine_coordsys(mri, 'interactive', 'no');
cfg             = [];
cfg.method      = 'interactive';
cfg.coordsys    = 'ctf'; %use CTF coordinates (pos x toward nose, +y to left)
mri_init = ft_volumerealign(cfg,mri)
ft_determine_coordsys(mri_init, 'interactive', 'no'); % sanity check, should be CTF
%% Align MEG Dewar to Laser scan Head model
% now we want to align the 3 markers in the *.con file with the 3 markers
% in the lasershape, where 1:5 markers match to the 4:9 lasershape
% fiducials
mrk1 = ft_read_headshape(mrkfile1);
mrk1 = ft_convert_units(mrk1, lasershape.unit);
mrk2 = ft_read_headshape(mrkfile2);
mrk2 = ft_convert_units(mrk2, lasershape.unit);
mrka = mrk1;
mrka.fid.pos = (mrk1.fid.pos+mrk2.fid.pos)/2;
p1 = mrka.fid.pos(1:5,:);
p2 = lasershape.fid.pos;
t1 = ft_headcoordinates(p1(1,:), p1(2,:), p1(3,:), 'ctf');%J
t2 = ft_headcoordinates(p2(6,:), p2(4,:), p2(5,:), 'ctf');%J
% t1 = ft_headcoordinates(p1(1,:), p1(2,:), p1(3,:), 'ctf');
% t2 = ft_headcoordinates(p2(1,:), p2(4,:), p2(5,:), 'ctf');
transform_mrk2laser = t2\t1;
% p1t = ft_warp_apply(transform_mrk2laser, p1)
grad = ft_read_sens(confile,'senstype','meg');
grad = ft_transform_geometry(transform_mrk2laser, grad);
%% align MRI and Laser
cfg = []
cfg.method = 'headshape';
cfg.headshape = lasershape;
cfg.headshape.interactive = 'no'
cfg.headshape.icp = 'yes'
mri_aligned = ft_volumerealign(cfg,mri_init)
% ft_determine_coordsys(mri_aligned,'interactive', 'no')
%% segmentation MRI
cfg           = [];
cfg.output    = {'brain', 'skull', 'scalp'};
segmentedmri  = ft_volumesegment(cfg, mri_aligned);
save segmentedmri segmentedmri
cfg = [];
cfg.method='singleshell';
mriskullmodel = ft_prepare_headmodel(cfg, segmentedmri);
cfg = [];
cfg.tissue      = {'brain', 'skull', 'scalp'};
cfg.numvertices = [3000 2000 1000];
mesh = ft_prepare_mesh(cfg, segmentedmri);
% ft_plot_mesh(mesh(3), 'facecolor', 'none'); % scalp
%% 
cfg = [];
%   cfg.elec              = structure, see FT_READ_SENS
   cfg.grad              = grad;%structure, see FT_READ_SENS
%   cfg.opto              = structure, see FT_READ_SENS
  cfg.headshape         = mesh(3)%structure, see FT_READ_HEADSHAPE
  cfg.headmodel         = mriskullmodel% structure, see FT_PREPARE_HEADMODEL and FT_READ_HEADMODEL
%   cfg.sourcemodel       = structure, see FT_PREPARE_SOURCEMODEL
%   cfg.dipole            = structure, see FT_DIPOLEFITTING
  cfg.mri               = mri_aligned;
  cfg.mesh              = lasershape;
  cfg.axes              = 'yes'
ft_geometryplot(cfg)