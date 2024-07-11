%% Loading the MEG and MATLAB data

confile = 'MEG data\Subj_001_02.con'; % Ensure correct file path to MEG data

matFilePath = fullfile('MATLAB Data', 'Sub_001_vcp.mat');
load_data_MAT = load(matFilePath); 
data_MAT = load_data_MAT.EXP.data; % extracting the table from the structure

cfg =[];
cfg.dataset = confile;
cfg.coilaccuracy = 0;
data_MEG = ft_preprocessing(cfg);

%% Filtering the data using bandpass and notch filter

% Band-pass filter the data 
cfg = [];
cfg.bpfilter = 'yes';
cfg.bpfreq = [4 40]; % Band-pass filter range
cfg.bpfiltord = 4;    % Filter order
data_bp = ft_preprocessing(cfg, data_MEG);

% Notch filter the data at 50 Hz
cfg = [];
cfg.bsfilter = 'yes';
cfg.bsfreq = [49 51]; % Notch filter range
data_filtered = ft_preprocessing(cfg, data_bp);


%% Extract the time vector and plot first channel of the data (raw and filtered)

time = data_MEG.time{1}; % Extract time vector from struct

% plot raw and filtered data
MEG_raw = data_MEG.trial{1}(1,:);
MEG_filtered = data_filtered.trial{1}(1,:); % commented out from previous
section

figure
plot(time, MEG_raw)
hold on 
plot(time,MEG_filtered)

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
cfg.trialdef.poststim   = 1; % 1s after stimulus onset
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

% figure
% plot(segmented_data.time{1}, segmented_data.trial{1}(40,:))

% Plotting the first few trials
for trialsel=1:10
  chansel = 1; % this is the STIM channel that contains the trigger
  figure
  plot(segmented_data.time{trialsel}, segmented_data.trial{trialsel}(chansel, :))
  xlabel('time (s)')
  ylabel('channel amplitude (a.u.)')
  title(sprintf('trial %d', trialsel));
end

%% Inspect and exclude trials for artefacts 

% Identify the MEG channels (assuming MEG channels are 1 to 224)
meg_channels = 1:224;

% Use ft_databrowser for interactive visualization excluding trigger channels
cfg = [];
cfg.method   = 'trial';
cfg.ylim = [-1e-12 1e-12];  % Set appropriate ylim for MEG channels
cfg.megscale = 1;  % Scaling factor for MEG channels
cfg.channel = meg_channels;  % Include only MEG channels
dummy        = ft_rejectvisual(cfg, segmented_data);

%%
% cfg=[];
% cfg.trials = (data_all.trialinfo==3);
% dataFIC = ft_selectdata(cfg, data_all);
% 
% cfg.trials = (data_all.trialinfo==5);
% dataIC = ft_selectdata(cfg, data_all);
% 
% cfg.trials = (data_all.trialinfo==9);
% dataFC = ft_selectdata(cfg, data_all);
