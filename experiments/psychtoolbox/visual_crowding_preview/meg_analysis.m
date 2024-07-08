
confile = 'MEG data\Subj_001_02.con';
%Load the data into fieldtrip

cfg =[];

cfg.dataset = confile;

cfg.coilaccuracy = 0;

data_all = ft_preprocessing(cfg);

% % Example time-domain data
% Fs = 1000;  % Sampling frequency in Hz
% 
% % Number of data points
% N = length(data_all.trial{1}(1,:));
% 
% % Apply FFT
% Y = fft(data_all.trial{1}(1,:));
% 
% % Compute the two-sided spectrum P2
% P2 = abs(Y/N);
% 
% % Compute the single-sided spectrum P1 based on P2 and the even-valued signal length N
% P1 = P2(1:N/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% % Compute the frequency axis
% f = Fs*(0:(N/2))/N;
% 
% % Plot the single-sided amplitude spectrum
% figure;
% plot(f, P1);
% title('Single-Sided Amplitude Spectrum of Data');
% xlabel('Frequency (f) [Hz]');
% ylabel('|P1(f)|');

% Plot the data

% cfg = [];
% 
% cfg.viewmode = 'vertical';
% cfg.blocksize = 300; %in seconds;
% ft_databrowser(cfg, data_all);

% Band-pass filter the data 
cfg = [];
cfg.bpfilter = 'yes';
cfg.bpfreq = [4 40]; % Band-pass filter range
cfg.bpfiltord = 4;    % Filter order
data_bp = ft_preprocessing(cfg, data_all);

% Notch filter the data at 50 Hz
cfg = [];
cfg.bsfilter = 'yes';
cfg.bsfreq = [49 51]; % Notch filter range
data_filtered_EC = ft_preprocessing(cfg, data_bp);

time = data_filtered_EC.time{1}; % Extract time vector from struct

% plot raw and filtered data
%
first_chan_raw = data_all.trial{1}(1,:);
second_chan_filtered = data_filtered_EC.trial{1}(1,:);

figure
plot(time,first_chan_raw)
hold on 
plot(time,second_chan_filtered)

