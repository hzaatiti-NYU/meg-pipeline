%% Experiment for testing/template for response buttons
% https://docs.vpixx.com/matlab/recording-digital-input-from-a-responsepixx




clearvars

Screen('Preference', 'SkipSyncTests', 1);

AssertOpenGL;  


vpix_use = 1; % 0 if vpixx is not conected


% Colors definition
grey = [128 128 128];
white = [255 255 255];

% Screen setup
screens = Screen('Screens');
screenNumber = max(screens);


% Get window

[window, windowRect] = Screen('OpenWindow', screenNumber, grey);

% Get screen size in pixels

[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);

% Smooth lines via blending
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

KbName('UnifyKeyNames');

escapeKey = KbName('ESCAPE');
cwKey = KbName('t');
ccwKey = KbName('b');
ansKey = KbName('space');

%% Datapixx
    
Datapixx('Open')
Datapixx('StopAllSchedules');
Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache


%% Get response


text =['Press red button'];

% Draw text
Screen('TextSize', window, 60);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, text, 'center', 'center', white);

% Flip to the screen
Screen('Flip', window);

timeout = 0;    

        % while timeout keeps being equal to zero
%while ~timeout

    %check the buttonbox response
    Datapixx('RegWrRd');
    kbcheck = dec2bin(Datapixx('GetDinValues'));
%end


      if kbcheck(end) == '1' || kbcheck(end-5)=='1'
                        if kbcheck(end) == '1'
                            button='left red';
                            % Draw text
                            Screen('TextSize', window, 60);
                            Screen('TextFont', window, 'Courier');
                            DrawFormattedText(window, [button ' pressed'], 'center', 'center', white);
                            % Flip to the screen
                            Screen('Flip', window);
                            WaitSecs(2);
                        else
                            button='right red';
                            % Draw text
                            Screen('TextSize', window, 60);
                            Screen('TextFont', window, 'Courier');
                            DrawFormattedText(window, [button ' pressed'], 'center', 'center', white);
                            % Flip to the screen
                            Screen('Flip', window);
                            WaitSecs(2);
                        end
                        timeout=1;
      end
