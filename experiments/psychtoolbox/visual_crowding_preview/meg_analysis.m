% Add FieldTrip directory to the top of the MATLAB path to fix the error of
% the 'nearest' function
addpath('C:\Users\tasni\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\FieldTrip\utilities');

% Set FieldTrip defaults
ft_defaults;

% Verify the correct 'nearest' function is being used
which nearest

%% Loading the MEG and MATLAB data

confile = 'MEG data\Sub_001_01_vcp.con'; % Ensure correct file path to MEG data

matFilePath = fullfile('MATLAB Data', 'Sub_001_vcp.mat');
load_data_MAT = load(matFilePath); 
data_MAT = load_data_MAT.EXP.data; % extracting the table from the structure

cfg =[];
cfg.dataset = confile;
cfg.coilaccuracy = 0;
data_MEG = ft_preprocessing(cfg);



%% Output the number of triggers on channel 227 for preview event
% Number of triggers should corespond to the number of trials in the
% experiment

% Extract the trigger channel (channel 227)
previewTrigger = data_MEG.trial{1}(227, :);

% Define a threshold to detect transitions
threshold = (max(previewTrigger) + min(previewTrigger)) / 2;

% Detect transitions from low to high
transitions = diff(previewTrigger > threshold);

% Count the number of positive transitions (indicating trigger onsets)
num_triggers = sum(transitions == 1);

% Output the number of triggers
fprintf('Number of triggers: %d\n', num_triggers);


%% Deifne trials and segment the data

cfg = [];
cfg.dataset  = confile;
cfg.trialdef.eventvalue = 1; % placeholder for the conditions
cfg.trialdef.prestim    = 1; % 1s before stimulus onset
cfg.trialdef.poststim   = 0.5; % 1s after stimulus onset
cfg.trialfun = 'ft_trialfun_general';
cfg.trialdef.chanindx = 227; 
cfg.trialdef.threshold = threshold; 
cfg.trialdef.eventtype = 'combined_binary_trigger'; % this will be the type of the event if combinebinary = true
cfg.trialdef.combinebinary = 1;
cfg = ft_definetrial(cfg);

% Update the fourth column (eventvalue placeholder) of cfg.trl with the conditions
cfg.trl(:, 4) = data_MAT.crowding;

% Segment the data based on the defined trials
segmented_data = ft_preprocessing(cfg);

% Verify the number of segments
num_segments = length(segmented_data.trial);
fprintf('Number of segments: %d\n', num_segments);

% Plotting the first few trials
% for trialsel=1:10
%   chansel = 1; % this is the STIM channel that contains the trigger
%   figure
%   plot(segmented_data.time{trialsel}, segmented_data.trial{trialsel}(chansel, :))
%   xlabel('time (s)')
%   ylabel('channel amplitude (a.u.)')
%   title(sprintf('trial %d', trialsel));
% end

%% Cleaning: Filtering the data using bandpass and notch filter

% Band-pass filter the data 
cfg = [];
cfg.bpfilter = 'yes';
cfg.bpfreq = [4 40]; % Band-pass filter range
cfg.bpfiltord = 4;    % Filter order
data_bp = ft_preprocessing(cfg, segmented_data);

% Notch filter the data at 50 Hz
cfg = [];
cfg.bsfilter = 'yes';
cfg.bsfreq = [49 51]; % Notch filter range
data_filtered = ft_preprocessing(cfg, data_bp);

%% Cleaning: Inspect and exclude trials for artefacts 

% Identify the MEG channels (assuming MEG channels are 1 to 224)
meg_channels = 1:208;

% Use ft_databrowser for interactive visualization excluding trigger channels
cfg = [];
cfg.method   = ['summary'];
cfg.ylim = [-1e-12 1e-12];  % Set appropriate ylim for MEG channels
cfg.megscale = 1;  % Scaling factor for MEG channels
cfg.channel = meg_channels;  % Include only MEG channels
dummy2        = ft_rejectvisual(cfg, data_filtered);

%% Cleaning: ICA





%% separate the trials into the conditions

cfg=[];

cfg.trials = (dummy2.trialinfo==1);
dataCrowding1 = ft_selectdata(cfg, dummy2); 

cfg.trials = (dummy2.trialinfo==2);
dataCrowding2 = ft_selectdata(cfg, dummy2);

cfg.trials = (dummy2.trialinfo==3);
dataCrowding3 = ft_selectdata(cfg, dummy2);

% Visualize the first trial of channel 20
figure
plot(dataCrowding1.time{1}, dataCrowding1.trial{1}(20,:))

%% Timelockanalysis 

cfg = [];
avgCWDG1 = ft_timelockanalysis(cfg, dataCrowding1);
avgCWDG2 = ft_timelockanalysis(cfg, dataCrowding2);
avgCWDG3 = ft_timelockanalysis(cfg, dataCrowding3);


% Plot all ERPs in sensor space 
cfg = [];
cfg.showlabels = 'no';
cfg.fontsize = 6;
%cfg.layout = 'CTF151_helmet.mat';
cfg.baseline = [-0.2 0];
cfg.xlim = [-0.2 1.0];
cfg.ylim = [-3e-13 3e-13];
ft_multiplotER(cfg, avgCWDG1, avgCWDG2, avgCWDG3);

% Plot all ERPs from a specific channel
cfg = [];
cfg.xlim = [-0.2 1.0];
cfg.ylim = [-1e-13 3e-13];
cfg.channel = 'AG001';
ft_singleplotER(cfg, avgCWDG1, avgCWDG2, avgCWDG3);

% Topographic plot of the ERP
cfg = [];
cfg.xlim =  [0.3 0.5];
cfg.colorbar = 'yes';
%cfg.layout = 'CTF151_helmet.mat';
ft_topoplotER(cfg, avgCWDG1);

cfg = [];
cfg.xlim = [0.3 0.5];
cfg.colorbar = 'yes';
%cfg.layout = 'CTF151_helmet.mat';
ft_topoplotER(cfg, avgCWDG2);

cfg = [];
cfg.xlim = [0.3 0.5];
cfg.colorbar = 'yes';
%cfg.layout = 'CTF151_helmet.mat';
ft_topoplotER(cfg, avgCWDG3);