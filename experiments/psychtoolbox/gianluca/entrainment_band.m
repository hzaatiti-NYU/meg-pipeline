%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resting and Low Contrast Entrainment Paradigm % %
% Gianluca Marsicano: gianluca.marsicano2@unibo.it%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Setting Screen Parameters
sca;
close all;
clearvars;

% Psychtoolbox setup
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
screens = Screen('Screens');
screenNumber = max(screens);
%screenNumber = 1; % max(screens);

% PARTICIPANT DATA
    name1='Participant Data';
    prompt1={'Subject Number', ...
        'Subject ID', ...
        'Sex (f/m)', ...
        'Age'};
    numlines1=1;
    defaultanswer1={ '0', 'p', 'M', '0'};
    answer1=inputdlg(prompt1,name1,numlines1,defaultanswer1);
    DEMO.num = str2double(answer1{1});
    DEMO.ID  = answer1{2};
    DEMO.sex = answer1{3};
    DEMO.age = str2double(answer1{4});
    %DEMO.IAF = str2double(answer1{5});    
    
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = (black + white) / 2;  % Computes the CLUT color code for gray.
% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, gray); % Gray background
[screenXpixels, ~] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
screenWidth = windowRect(3);
screenHeight = windowRect(4);
%rectColor = (black + white) / 1.90;
% Entrainment position (edges)
rectX = [80 1840];
rectY = [80 1000]; 
% Set the text size
Screen('TextSize', window, 50);

%-------------------------------------------
% TRIGGERS SETUP
%-------------------------------------------
% % Define trigger pixels for all usable MEG channels
% trig.ch224 = [4  0  0]; %224 meg channel
% trig.ch225 = [16  0  0];  %225 meg channel
% trig.ch226 = [64 0 0]; % 226 meg channel
% trig.ch227 = [0  1 0]; % 227 meg channel
% trig.ch228 = [0  4 0]; % 228 meg channel
% trig.ch229 = [0 16 0]; % 229 meg channel
% trig.ch230 = [0 64 0]; % 230 meg channel
% trig.ch231 = [0 0  1]; % 231 meg channel

trigRect = [0 0 1 1];
trig.start = [4  0  0];
trig.end   = [16  0  0];
% Rest
trig.closed = [64 0 0];
trig.open = [0  1 0];
% Entrainment
trig.alpha_upper = [0  4 0]; % Alpha Upper
trig.alpha_lower = [0 16 0]; % Alpha Lower
trig.theta = [0 64 0]; % Theta
trig.beta = [0 0  1]; % Beta

%-------------------------------------------
% VPIXX SETUP
%-------------------------------------------    
Datapixx('Open');
Datapixx('EnablePixelMode'); 
Datapixx('RegWr');
    
%-------------------------------------------
% Cycle and entrainment parameters
%-------------------------------------------
% Get frame ms, refresh rate, and frames corresponding to stim frequency
ifi = Screen('GetFlipInterval', window);
refRate = ceil(1 / ifi);
freq_desired_alpha_upper = 13; 
frame_value_alpha_upper = Entr_freq_stim(refRate, freq_desired_alpha_upper);
disp(['Closest frames to alpha upper ', num2str(freq_desired_alpha_upper), ' Hz is ', num2str(frame_value_alpha_upper)]);
freq_desired_alpha_lower= 8; 
frame_value_alpha_lower = Entr_freq_stim(refRate, freq_desired_alpha_lower);
disp(['Closest frames to alpha lower ', num2str(freq_desired_alpha_lower), ' Hz is ', num2str(frame_value_alpha_lower)]);
freq_desired_theta= 5; 
frame_value_theta = Entr_freq_stim(refRate, freq_desired_theta);
disp(['Closest frames to theta ', num2str(freq_desired_theta), ' Hz is ', num2str(frame_value_theta)]);
freq_desired_beta= 25; 
frame_value_beta = Entr_freq_stim(refRate, freq_desired_beta);
disp(['Closest frames to beta ', num2str(freq_desired_beta), ' Hz is ', num2str(frame_value_beta)]);

% Desired value closest to alpha upper cycle 13 Hz based on current ifi
alpha_cycle_dur_upper = frame_value_alpha_upper*ifi;
multiplier_alpha_upper = alpha_cycle_dur_upper / ifi;
alpha_cycles_upper = round(multiplier_alpha_upper);
% Define alpha_upper
num_repetitions_alpha_upper = floor(refRate*3 / (2 + (alpha_cycles_upper-2))); % 3 seconds of stimulation!!
alpha_upper = [repmat([ones(1, 2), zeros(1, alpha_cycles_upper-2)], 1, num_repetitions_alpha_upper)];

% Desired value closest to alpha lower 8 Hz based on current ifi
alpha_cycle_dur_lower = frame_value_alpha_lower*ifi;
multiplier_alpha_lower = alpha_cycle_dur_lower / ifi;
% Round to the nearest integer
alpha_cycles_lower = round(multiplier_alpha_lower);
% Define alpha_lower
num_repetitions_alpha_lower = floor(refRate*3 / (2 + (alpha_cycles_lower-2)));
alpha_lower = [repmat([ones(1, 2), zeros(1, alpha_cycles_lower-2)], 1, num_repetitions_alpha_lower)];

% Desired value closest to theta 5 Hz based on current ifi
theta_cycle_dur_lower = frame_value_theta*ifi;
multiplier_theta = theta_cycle_dur_lower / ifi;
theta_cycles_lower = round(multiplier_theta);
% Define theta
num_repetitions_theta = floor(refRate*3 / (2 + (theta_cycles_lower-2)));
theta = [repmat([ones(1, 2), zeros(1, theta_cycles_lower-2)], 1, num_repetitions_theta)];

% Desired value closest to bera 25 Hz based on current ifi
beta_cycle_dur_lower = frame_value_beta*ifi;
multiplier_beta = beta_cycle_dur_lower / ifi;
beta_cycles_lower = round(multiplier_beta);
% Define beta
num_repetitions_beta = floor(refRate*3 / (2 + (beta_cycles_lower-2)));
beta = [repmat([ones(1, 2), zeros(1, beta_cycles_lower-2)], 1, num_repetitions_beta)];

stand_contrast = 0.53;
tot_trials_cond = 40; % Numbers of Trials for each condition

%-------------------------------------------
% Start Experiment - RESTING STATE
%-------------------------------------------

Screen('FillRect', window, getRGB(trig.start), trigRect);
Screen('Flip', window);
expStart = GetSecs();

% Start EYES CLOSED
DrawFormattedText(window, 'PRESS RED BUTTON AND START CLOSED EYES REST', 'center', 'center', white);
Screen('Flip', window);
listenButton(0); % Red Button
    Screen('FillRect', window, getRGB(trig.closed), trigRect);
    Screen('Flip', window);
      % Check for ESC key press
    [~, ~, keyCode] = KbCheck;
keyCode(KbName('ESCAPE'))
    WaitSecs(180)

% Start EYES OPEN
DrawFormattedText(window, 'PRESS RED BUTTON AND START OPEN EYES REST', 'center', 'center', white); 
Screen('Flip', window);
listenButton(0); % Red Button
Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
    Screen('FillRect', window, getRGB(trig.open), trigRect);
    Screen('Flip', window);
      % Check for ESC key press
    [~, ~, keyCode] = KbCheck;
    keyCode(KbName('ESCAPE'))
    WaitSecs(180)

%-------------------------------------------
% Define number of trials and repetitions for 
% THRESHOLD Logistic Fitting
%-------------------------------------------
numTrialsPerCondition = 5;
numConditions = 10;
tot_numTrials = numTrialsPerCondition * numConditions;
trialMatrix = zeros(tot_numTrials, 1); 
baseContrast = 0.53;
conRange = 0.05;
numSteps = 10;
con_conds = linspace(-conRange / 2, conRange / 2, numSteps) + baseContrast;
con_conds = con_conds';
allConditions = repmat(con_conds, numTrialsPerCondition, 1);
shuffledConditions = allConditions(randperm(tot_numTrials), :);
trialMatrix(:, :) = shuffledConditions;

%-------------------------------------------
% Start Threshold Loop
%-------------------------------------------
% Display instructions
DrawFormattedText(window, 'Great, now look at the fixation and report\n\n if you have a vivid perception or not of a flickering light', 'center', 'center', white);
Screen('Flip', window);
listenButton(0); % Red Button

% Main experiment loop Upper Alpha
for trial = 1:tot_numTrials
    ISI = 0.8;
    % Check for ESC key press
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
      
    presentationType = trialMatrix(trial, 1);
    
    % Fixation dot for Initial ISI
    Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
    Screen('Flip', window);
    WaitSecs(ISI); % Wait for 500 ms ISI
    
    % Present Entrainment
    for i = 1:length(alpha_upper)  
        dur(i) = GetSecs();  
        if alpha_upper(i) == 1
           Screen('FrameRect', window, presentationType, [rectX(1) rectY(1) rectX(2) rectY(2)], 25);
        end
        Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
        Screen('Flip', window);
    end  
    
    % 1 Detection: Present response screen
    DrawFormattedText(window, 'Did you strongly perceive it?\n\nYellow Button = Yes       Green Button = No', 'center', 'center', white);
    Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
    Screen('Flip', window);
    % 1 Detection: Collect participant Accuracy
     [resp, time] = listenButtons(1,2); 
     if resp == 8 % yellow button - Seen
        response_det = 1;
     elseif resp == 7 % green button - Unseen
        response_det = 0;
     end
    
    trialOrderMatrix(trial, :) = [trial, presentationType, response_det];
end

expLabels = {'nTrial', 'contrast', 'resp'};
expTable = array2table(trialOrderMatrix, 'VariableNames',expLabels);
sortedTable = sortrows(expTable, 2);
result = groupsummary(expTable, {'contrast'}, 'mean', 'resp');
result = table2array(result);
xData_res = result(:,1); yData_res = result(:,3);
[xData, yData] = prepareCurveData( xData_res, yData_res );
ft = fittype( '1/(1+exp(b*(t-x)))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.792207329559554 0.959492426392903];
[fitresult, gof] = fit( xData, yData, ft, opts);
contrast = fitresult.t;
if fitresult.t >= 0.55
    contrast = stand_contrast;
elseif fitresult.t <= 0.50
    contrast = stand_contrast;
else 
    contrast = fitresult.t; 
end

%-------------------------------------------
% Start Experiment - ENTRAINMENT
%-------------------------------------------

% Display instructions
DrawFormattedText(window, 'Great, now continue to looking at the fixation while resting\n\n Press Red Button to start', 'center', 'center', white);
Screen('Flip', window);
listenButton(0); % Red Button
DrawFormattedText(window, 'Press any button to begin - 1st Block\n\n Press Red Button to start', 'center', 'center', white);
Screen('Flip', window);
listenButton(0); % Red Button

% Main loop Upper Alpha
for trial = 1:tot_trials_cond
    ISI = 0.8;
  % Check for ESC key press
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
    
    % Fixation dot for Initial ISI
    Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
    Screen('Flip', window);
    WaitSecs(ISI); % Wait for 500 ms ISI
    
    % Present Entrainment
    for i = 1:length(alpha_upper) 
            [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
        dur(i) = GetSecs();      
      if i == 1
          stim = trig.alpha_upper;
          Screen('FillRect', window, getRGB(stim), trigRect);
          Screen('Flip', window);
      end
        if alpha_upper(i) == 1
           Screen('FrameRect', window, contrast, [rectX(1) rectY(1) rectX(2) rectY(2)], 25);
        end
        Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
        Screen('Flip', window);
    end  
end

% 2nd block
DrawFormattedText(window, 'Press any button to begin - 2nd Block\n\n Press Red Button to start', 'center', 'center', white);
Screen('Flip', window);
listenButton(0); % Red Button

% Main loop Alpha Lower
for trial = 1:tot_trials_cond
    ISI = 0.8;
  % Check for ESC key press
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
    
    % Fixation dot for Initial ISI
    Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
    Screen('Flip', window);
    WaitSecs(ISI); % Wait for 500 ms ISI
    
    % Present Entrainment
    for i = 1:length(alpha_lower)
                    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
      if i == 1
          stim = trig.alpha_lower;
          Screen('FillRect', window, getRGB(stim), trigRect);
          Screen('Flip', window);
      end        
        if alpha_lower(i) == 1
           Screen('FrameRect', window, contrast, [rectX(1) rectY(1) rectX(2) rectY(2)], 25);
        end
        Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
        Screen('Flip', window);
    end  
end

% 3rd block
DrawFormattedText(window, 'Press any button to begin - 3rd Block\n\n Press Red Button to start', 'center', 'center', white);
Screen('Flip', window);
listenButton(0); % Red Button

% Main loop Theta
for trial = 1:tot_trials_cond
    ISI = 0.8;
  % Check for ESC key press
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
    
    % Fixation dot for Initial ISI
    Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
    Screen('Flip', window);
    WaitSecs(ISI); % Wait for 500 ms ISI
    
    % Present Entrainment
    for i = 1:length(theta)
                    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
      if i == 1
          stim = trig.theta;
          Screen('FillRect', window, getRGB(stim), trigRect);
          Screen('Flip', window);
      end
        if theta(i) == 1
           Screen('FrameRect', window, contrast, [rectX(1) rectY(1) rectX(2) rectY(2)], 25);
        end
        Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
        Screen('Flip', window);
    end  
end

% 4th block
DrawFormattedText(window, 'Press any button to begin - 4th Block\n\n Press Red Button to start', 'center', 'center', white);
Screen('Flip', window);
listenButton(0); % Red Button

% Main loop beta
for trial = 1:tot_trials_cond
    ISI = 0.8;
  % Check for ESC key press
    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
    
    % Fixation dot for Initial ISI
    Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
    Screen('Flip', window);
    WaitSecs(ISI); % Wait for 500 ms ISI
    
    % Present Entrainment
    for i = 1:length(beta)
                    [~, ~, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break;
    end
              if i == 1
          stim = trig.beta;
          Screen('FillRect', window, getRGB(stim), trigRect);
          Screen('Flip', window);
              end
        if beta(i) == 1
           Screen('FrameRect', window, contrast, [rectX(1) rectY(1) rectX(2) rectY(2)], 25);
        end
        Screen('DrawDots', window, [xCenter; yCenter], 10, white, [], 2);
        Screen('Flip', window);
    end  
end

    WaitSecs(1);
    Screen('Flip', window);
    Screen('FillRect', window, getRGB(trig.end), trigRect);

DrawFormattedText(window, 'Experiment Finished, thanks a lot!', 'center', 'center', white);
Screen('Flip', window);
WaitSecs(3);

% Clear the screen
sca;

save([answer1{1} 'Entrainment_Band_' answer1{2} '.mat'], 'trialOrderMatrix')
