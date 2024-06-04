%% read in the data and enforce the units to be in 'mm'

headshape = ft_read_headshape('example1_head_markers.pos');

headshape = ft_convert_units(headshape, 'mm');

%% visualization, coordinate axes are initially ALS
figure
ft_plot_headshape(headshape)
ft_plot_axes(headshape)
view([-27 20])

headshape.coordsys = 'ctf';
headshape = ft_convert_coordsys(headshape, 'neuromag');  % this rotates it such that the X-axis points to the right

%% visualization, coordinate axes are now RAS
figure
ft_plot_headshape(headshape)
ft_plot_axes(headshape)
view([114 20])

%% select the reference points on the helmets, with their corresponding label
fid_measured = [];
fid_measured.pos(1,:) = headshape.pos(end-7,:);
fid_measured.pos(2,:) = headshape.pos(end-6,:);
fid_measured.pos(3,:) = headshape.pos(end-5,:);
fid_measured.pos(4,:) = headshape.pos(end-4,:);
fid_measured.pos(5,:) = headshape.pos(end-3,:);
fid_measured.pos(6,:) = headshape.pos(end-2,:);
fid_measured.pos(7,:) = headshape.pos(end-1,:);
fid_measured.pos(8,:) = headshape.pos(end-0,:);
fid_measured.label = {'A5', 'A6', 'A7', 'A8', 'A1', 'A2', 'A3', 'A4'};


[fid_measured.label, indx] = sort(fid_measured.label);
fid_measured.pos = fid_measured.pos(indx,:);

headshape.fid = fid_measured;

fieldlinebeta2 = ft_read_sens('fieldlinebeta2.mat'); % from fieldtrip/template/grad
fieldlinebeta2 = ft_convert_units(fieldlinebeta2, 'mm');
fid_helmet     = fieldlinebeta2.fid;

% dewar3.pos = dewar2.pos(7:end, :);
% dewar3.label = {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8'};
% 
% 
% % Now we need to define the helmet coordinates based on the excel spreadsheet
% helmet.pos(1, :) = [55.703, 119.485, -0.749];
% helmet.pos(2, :) = [92.105, 59.254, -28.708];
% helmet.pos(3, :) = [102.325, 0.221, 16.345];
% helmet.pos(4, :) = [58.503, -94.717, -69.944];
% helmet.pos(5, :) = [-55.703, 119.485, -0.749];
% helmet.pos(6, :) = [-92.105, 59.254, -28.708];
% helmet.pos(7, :) = [-102.325, 0.221, 16.345];
% helmet.pos(8, :) = [-58.503, -94.717, -69.944];
% helmet.label = {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8'};


% find the rigid body transform to the helmet coordinates as defined by the
% spreadsheet:
cfg = [];
cfg.method = 'template';
cfg.target = fid_helmet;
cfg.elec = fid_measured;
helmet2 = ft_electroderealign(cfg); 

% Check: We verify what is helmet2.chanpos is the same as helmet.pos.


%%

helmet3.pos = ft_warp_apply(helmet2.rigidbody, fid_measured.pos, 'rigidbody');
% helmet3.fid.pos = helmet2.elecpos;
% helmet3.fid.label = helmet2.label;
% helmet3.coordsys = 'neuromag';

figure;
% ft_plot_sens(helmet2, 'marker', 'o'); 
ft_plot_headshape(helmet3, 'vertexcolor', 'b');
ft_plot_sens(fieldlinebeta2, 'vertexcolor', 'm')
title('Coordinate system from 8 points in the helmet as given by FieldLine');
% looks good