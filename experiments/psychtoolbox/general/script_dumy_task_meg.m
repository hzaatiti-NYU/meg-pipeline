
  

 
 
 %% dummy task for training purposes in MEG at NYUAD

% Aniol Santo-Angles, PhD
% asantoangles@gmail.com

% this is a training script from the MEG at NYUAD: 
% to test meg triggers sent by the the Pixel Model in the Vpixx
% system implemented in psychtoolbox matlab

% MEG triggers 
% a) when red dot appears on the screen (stimulus-specific),
% b) when the left red button (Vpixx) is pressed
% to trigger other response buttons, see commented lines 418-452 

% press scape to skip the task

%% settings path and subject info

% Clear the workspace and the screen
sca; close all; clear;

%% settings script

% settings experiment
debug = 0;
% 1 for coding in laptop (skip synchronization tests)
% 0 for experiment in MEG (keep synchronization tests)

datapixx_open = 0;
% 1 for datapixx open for trigger and response
% 0 for datapixx NOT open (no trigger, no vpixx response)

little_window = 0; 
% display little window in the same screen: 1 true, 0 false

trigger_test = 1; 
% if 0, trigger is 1 pixel, 
% if 1 trigger is bigger (to be able to see it)

Vpixx_response = 1; 
% if 0, laptop keyboard responses (debugging)
% if 1, Vpixx response buttons

%% settings task

% settings timing (seconds)
stim_duration = 1;
isi_duration = 0.2;

% settings stimulus feature
dotSizePix = 50; % size of stimulus
if little_window == 1
    eccentricity = 100; % pixels
else
    eccentricity = 350; % pixels
end

% settings stimulus location
number_locations = 8; 
theta = linspace(0, 2*pi, number_locations+1);
theta = theta(1:(end-1));
% angle theta = 0 radians, in position (1,0), running counter clock wise
% (pi / 2 radians in position (0,1))

% Pen width for the frames
penWidthPixels = 2;

% settings colours
grey   = [128 128 128];
white  = [255 255 255];
black  = [0 0 0];
red    = [255 0 0];   % stimulus
orange = [255 140 0]; % non-red stimulus

% settings fixation point
size_fixation_point = 15; % size
color_fixation_point = [255 255 255];


% input data
functional_localizer = [];
functional_localizer.data = [1 3 5 4 2 6 7 3 8 2;
                             0 0 0 0 1 0 0 0 1 0];

%% setting up Psychtoolbox

% skip synchronization test
if debug == 1
    Screen('Preference', 'SkipSyncTests', 1);
end

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = max(screens);

if little_window == 1

    % Start cordinate in pixels of our window. Note that setting both of these
    % to zero will make the window appear in the top right of the screen.
    startXpix = 1100;
    startYpix = 50;
    
    % Dimensions in pixels of our window in the X (left-right) and Y (up down)
    % dimensions
    dimX = 600;
    dimY = 400;
    
    % Open (partial) window with black background  
    [window, windowRect] = Screen('OpenWindow', screenNumber, black,...
        [startXpix startYpix startXpix + dimX startYpix + dimY], [], [], [], [], [], kPsychGUIWindow);

else

    % Open (full) window with black background  
    [window, windowRect] = Screen('OpenWindow', screenNumber, black);

end

% Set up alpha-blending for smooth (anti-aliased) lines
% https://www.youtube.com/watch?v=7eFGY6JVTnc
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Set maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

%% settings of response buttons with keyboard

% unify key names across computers
KbName('UnifyKeyNames');

% The avaliable keys to press
escapeKey = KbName('ESCAPE');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
barKey = KbName('space');

%% trigger and response setup (Vpixx)
% https://vpixx.com/vocal/pixelmode/
 
% trigger_224: localizer onset (right before stimulus appears)
% trigger_225: stimulus onset
% trigger_226: response onset

% triggers as color (RGB) of tope-left pixel in the screen
trigger_224 = [4  0 0]; % 224 meg channel
trigger_225 = [16 0 0]; % 225 meg channel
trigger_226 = [64 0 0]; % 226 meg channel
trigger_227 = [0  1 0]; % 227 meg channel
trigger_228 = [0  4 0]; % 228 meg channel
trigger_229 = [0 16 0]; % 229 meg channel
trigger_230 = [0 64 0]; % 230 meg channel
trigger_231 = [0 0  1]; % 231 meg channel

trigger_location1 = trigger_224;
trigger_location2 = trigger_224 + trigger_225;
trigger_location3 = trigger_225;
trigger_location4 = trigger_226;
trigger_location5 = trigger_225 + trigger_226;
trigger_location6 = trigger_224 + trigger_225 + trigger_226;
trigger_location7 = trigger_227;
trigger_location8 = trigger_226 + trigger_227;

trigger_start = trigger_228;
trigger_response = trigger_229;

% size and location of trigger pixel
if trigger_test == 0
    baseRect_trigger = [0 0 1 1];
    centeredRect_trigger = CenterRectOnPointd(baseRect_trigger, 0.5, 0.5);
elseif trigger_test == 1
    baseRect_trigger = [0 0 50 50];
    centeredRect_trigger = CenterRectOnPointd(baseRect_trigger, 25, 25);
end

if datapixx_open == 1

    Datapixx('Open');
    Datapixx('EnablePixelMode'); % trigger pixel mode
    Datapixx('RegWrRd'); % Synchronize DATAPixx registers to local register cache

end

%% prompt instructions

duration_text = 2;

% The coordinates define the top left and bottom right coordinates of our rect
% [top-left-x top-left-y bottom-right-x bottom-right-y].
baseRect = [0 0 screenXpixels screenYpixels];

% Center the rectangle on the centre of the screen 
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);

% Draw grey background to the screen.
Screen('FillRect', window, grey, centeredRect);

% Trigger (black)
Screen('FillRect', window, black, centeredRect_trigger);

% Flip to the screen
Screen('Flip', window);

% Draw text in the middle of the screen in Courier in white
Screen('TextSize', window, 60);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'Dummy task for training purposes', 'center', screenYpixels * 0.25, white);
Screen('FillRect', window, black, centeredRect_trigger);
Screen('Flip', window);
WaitSecs(duration_text);

Screen('TextSize', window, 60);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'Dummy task for training purposes', 'center', screenYpixels * 0.25, white);
DrawFormattedText(window, 'Trigger at stimulus onset', 'center', screenYpixels * 0.5, white);
Screen('FillRect', window, black, centeredRect_trigger);
Screen('Flip', window);
WaitSecs(duration_text);

Screen('TextSize', window, 60);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'Dummy task for training purposes', 'center', screenYpixels * 0.25, white);
DrawFormattedText(window, 'Trigger at stimulus onset', 'center', screenYpixels * 0.5, white);
DrawFormattedText(window, 'Trigger (burst) while pressing left red button', 'center', screenYpixels * 0.75, white);
Screen('FillRect', window, black, centeredRect_trigger);
Screen('Flip', window);
WaitSecs(duration_text);

% set variable
timeout = 0;      

%% stimulus presentation

% set variable
exit_task = 0;

% Matrix of color dots
ovalColorMatrix = repmat(white', 1, number_locations);

% Dot size in pixels
dotSizePixMatrix = repmat(dotSizePix, 1, number_locations);

% Make a base Rect
baseRect = [0 0 dotSizePix dotSizePix];
    
% Center the rectangle on the centre of the screen
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);

% Vertex of ovals (1-3 x axis; 2-4 y-axis) 
ovalPositionMatrix = nan(4, number_locations);
for pos_i = 1:number_locations

    ovalPositionMatrix(1, pos_i) = centeredRect(1) + eccentricity * cos(theta(pos_i));
    ovalPositionMatrix(3, pos_i) = centeredRect(3) + eccentricity * cos(theta(pos_i));

    ovalPositionMatrix(2, pos_i) = centeredRect(2) - eccentricity * sin(theta(pos_i));
    ovalPositionMatrix(4, pos_i) = centeredRect(4) - eccentricity * sin(theta(pos_i));

end

% coordinates of dots
dotPositionMatrix = nan(2, number_locations); % rows (x-position, y-position), columns (locations)
for pos_i = 1:number_locations
    dotPositionMatrix(1, pos_i) = xCenter + eccentricity * cos(theta(pos_i));
    dotPositionMatrix(2, pos_i) = yCenter - eccentricity * sin(theta(pos_i));
end

%%% trigger on

% Draw fixation point
Screen('DrawDots', window, [xCenter yCenter],...
    size_fixation_point, white, [], 2);

% empty backgrond dots
Screen('FrameOval', window, ovalColorMatrix, ovalPositionMatrix, penWidthPixels);

% trigger start of task
Screen('FillRect', window, trigger_start, centeredRect_trigger);

% Flip to the screen. 
Screen('Flip', window);

%%% trigger off

% Draw fixation point
Screen('DrawDots', window, [xCenter yCenter],...
    size_fixation_point, white, [], 2);

% empty backgrond dots
Screen('FrameOval', window, ovalColorMatrix, ovalPositionMatrix, penWidthPixels);

% trigger stimulus
Screen('FillRect', window, black, centeredRect_trigger);

% Flip to the screen. 
Screen('Flip', window);

WaitSecs(1);

% display sequences
for stim_i = 1:size(functional_localizer.data, 2)

    trigger_stim_first = 0;

    if ~exit_task

        time = 0; % seconds
    
        timeout_stimulus = 0;
    
        while ~timeout_stimulus

            response = 0;
                    
            dotSizePixMatrix_stim = dotSizePixMatrix(functional_localizer.data(1, stim_i));
            dotPositionMatrix_stim = dotPositionMatrix(:, functional_localizer.data(1, stim_i));

            if functional_localizer.data(2, stim_i) == 1
                colour = orange;
            elseif functional_localizer.data(2, stim_i) == 0
                colour = red;
            end

            %%% trigger on

            if trigger_stim_first == 0

                % Trigger (colour)
                if functional_localizer.data(1, stim_i) == 1
                    trigger_stim = trigger_location1;
                elseif functional_localizer.data(1, stim_i) == 2
                    trigger_stim = trigger_location2;
                elseif functional_localizer.data(1, stim_i) == 3
                    trigger_stim = trigger_location3;
                elseif functional_localizer.data(1, stim_i) == 4
                    trigger_stim = trigger_location4;
                elseif functional_localizer.data(1, stim_i) == 5
                    trigger_stim = trigger_location5;
                elseif functional_localizer.data(1, stim_i) == 6
                    trigger_stim = trigger_location6;
                elseif functional_localizer.data(1, stim_i) == 7
                    trigger_stim = trigger_location7;
                elseif functional_localizer.data(1, stim_i) == 8
                    trigger_stim = trigger_location8;
                end

                % Draw fixation point
                Screen('DrawDots', window, [xCenter yCenter],...
                    size_fixation_point, white, [], 2);
            
                % empty backgrond dots
                Screen('FrameOval', window, ovalColorMatrix, ovalPositionMatrix, penWidthPixels);
                
                % Draw the dot to the screen. 
                Screen('DrawDots', window, dotPositionMatrix_stim, dotSizePixMatrix_stim, colour, [], 2);
            
                % trigger stimulus
                Screen('FillRect', window, trigger_stim, centeredRect_trigger);
                
                % Flip to the screen. 
                Screen('Flip', window);

                trigger_stim_first = 1;

            end

            %%% trigger off

            % Draw fixation point
            Screen('DrawDots', window, [xCenter yCenter],...
                size_fixation_point, white, [], 2);
            
            % empty backgrond dots
            Screen('FrameOval', window, ovalColorMatrix, ovalPositionMatrix, penWidthPixels);
            
            % Draw the dot to the screen. 
            Screen('DrawDots', window, dotPositionMatrix_stim, dotSizePixMatrix_stim, colour, [], 2);
                    
            % trigger black
            Screen('FillRect', window, black, centeredRect_trigger);
            
            % Flip to the screen. 
            Screen('Flip', window);

            %%% responses

            if Vpixx_response == 1
                    
                % Check the keyboard to see if a button has been pressed
                % (only for escape key)
                [keyIsDown,secs, keyCode] = KbCheck;
            
                % Check the Vpixx response buttons to see if a button has been pressed
                Datapixx('RegWrRd');
                kbcheck = dec2bin(Datapixx('GetDinValues'));
    
                if keyCode(escapeKey)
    
                    exit_task = 1;
                    
                elseif kbcheck(end)   == '1' % left red
        
                    response = 1;
    
%                 elseif kbcheck(end-2) == '1' % left green
%         
%                     response = 1;
%         
%                 elseif kbcheck(end-3) == '1' % left blue
%         
%                     response = 1;
%         
%                 elseif kbcheck(end-1) == '1' % left yellow
%         
%                     response = 1;
%         
%                 elseif kbcheck(end-4) == '1' % left white
%         
%                     response = 1;
%                 
%                 elseif kbcheck(end-5) == '1' % right red   
%         
%                     response = 1;
%         
%                 elseif kbcheck(end-7) == '1' % right green
%         
%                     response = 1;
%         
%                 elseif kbcheck(end-8) == '1' % right blue
%         
%                     response = 1;
%         
%                 elseif kbcheck(end-6) == '1' % right yellow
%         
%                     response = 1;
%         
%                 elseif kbcheck(end-9) == '1' % right white
%         
%                     response = 1;
        
                end


                if response == 1

                    % Draw fixation point
                    Screen('DrawDots', window, [xCenter yCenter],...
                        size_fixation_point, white, [], 2);
                
                    % empty backgrond dots
                    Screen('FrameOval', window, ovalColorMatrix, ovalPositionMatrix, penWidthPixels);
                            
                    % Draw the dot to the screen. 
                    Screen('DrawDots', window, dotPositionMatrix_stim, dotSizePixMatrix_stim, colour, [], 2);
                                
                    % trigger response
                    Screen('FillRect', window, trigger_response, centeredRect_trigger);

                    % Flip to the screen. 
                    Screen('Flip', window);

                end

            end
        
            % Increment the time
            time = time + ifi;
    
            if time > stim_duration
    
                timeout_stimulus = 1;
                
            end
    
        end
    
        timeout_isi = 0;
    
        while ~timeout_isi    

            %%% trigger off

            % Draw fixation point
            Screen('DrawDots', window, [xCenter yCenter],...
                size_fixation_point, white, [], 2);
        
            % empty backgrond dots
            Screen('FrameOval', window, ovalColorMatrix, ovalPositionMatrix, penWidthPixels);            

            % trigger black
            Screen('FillRect', window, black, centeredRect_trigger);
            
            % Flip to the screen. 
            Screen('Flip', window);

            % Increment the time
            time = time + ifi;
    
            if time > isi_duration + stim_duration
    
                timeout_isi = 1;
                
            end
    
        end
        
    end
    
end

% Draw text in the middle of the screen in Courier in white
Screen('TextSize', window, 60);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'MEG training at NYUAD', 'center', screenYpixels * 0.25, white);
Screen('FillRect', window, black, centeredRect_trigger);
Screen('Flip', window);
WaitSecs(duration_text);

Screen('TextSize', window, 60);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'MEG training at NYUAD', 'center', screenYpixels * 0.25, white);
DrawFormattedText(window, 'MEG training at NYUAD', 'center', screenYpixels * 0.5, white);
Screen('FillRect', window, black, centeredRect_trigger);
Screen('Flip', window);
WaitSecs(duration_text);

Screen('TextSize', window, 60);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, 'MEG training at NYUAD', 'center', screenYpixels * 0.25, white);
DrawFormattedText(window, 'MEG training at NYUAD', 'center', screenYpixels * 0.5, white);
DrawFormattedText(window, 'MEG training at NYUAD', 'center', screenYpixels * 0.75, white);
Screen('FillRect', window, black, centeredRect_trigger);
Screen('Flip', window);
WaitSecs(duration_text);

