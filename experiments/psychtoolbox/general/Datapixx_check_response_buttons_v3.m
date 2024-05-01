%% Datapixx System Check

% Description : Checks the vpix input and records it. Based on Aniol's task design
% Written : Gayathri Sateesh, 31 Jan 2023, gayathri.satheesh@nyu.edu
%-----------------------------------------------------------------------------------------

% Clear the workspace and the screen
sca; close all; clear;

% subject and session
subject = 'sub01';
session = 'sess01';

%experiment variables
debug=0;
no_dial=1;
scanner=0;
noTrials=7;

% paths
path_input = [pwd '/input'];
path_output =[pwd '/behavior'];
%path_input = '/Users/as14864/Data/Analysis/geometry_replay/scripts';
% path_output = '/Users/as14864/Data/Analysis/geometry_replay/behavior';

% create output folder
output_folder = [path_output '/' subject '/' session];
if ~isfolder(output_folder)
    mkdir(output_folder);
end

%% create response csv

filename = strcat(output_folder,'/latest_debug_',datestr(now,'ddmmmyy_HHMM'));
bevfile = strcat(filename,'.csv');
fileIDd = fopen(bevfile,'w'); file_closed = 0;

headerString = 'Subject,Session,Trial,ButtonPressed,DialMoved\n';
fprintf(fileIDd,headerString);


%% settings task

% settings experiment
code = 1; % 1 for coding, 0 for experiment (skeep synchronization tests)
little_window = 0; % 1 true, 0 false

% settings timing (seconds)
baseline_duration = 0.1;
stim_duration = 0.3;
delay_duration = 0.1;
response_duration = 3;

% settings stimulus feature
dotSizePix = 60; % size of stimulus
if little_window == 1
    excentricity = 100; % pixels
else
    excentricity = 400; % pixels
end

number_locations = 8;
theta = linspace(0, 2*pi, number_locations+1);
theta = theta(1:(end-1));
% angle theta = 0 radians, in position (1,0), running counter clock wise
% (pi/2 radians in position (0,1))

% settings background colours
type_background_dots = 2; % 0 no background dots, 1 filled background dots, 2 empty background dots
background_color = 0.7; % [0 1] means [black white] in 255 steps
background_filleddots_color = [128 128 128]; % grey
background_emptydots_color = [255 255 255]; % white
% Color is defined by red green and blue components (RGB). So we have three numbers which
% define our RGB values. The maximum number for each is 1 and the minimum
% 0. So, "full red" is [1 0 0]. "Full green" [0 1 0] and "full blue" [0 0
% 1].

% set sequence trials
% load([path_input '/task_sequences_240trials_456seq_v1.mat']) % sequences_task
% sequences = sequences_task;

sequences = [1 2 3 4 5];

% randomize trials
random_trials = randi([1 size(sequences, 1)], 1, size(sequences, 1));
sequences = sequences(random_trials,:);

% save trial presentation after randomization
save([output_folder '/task_trial_presentation.mat'], 'sequences'); 

% empty matrix for responses
responses = nan(size(sequences));

%% setting up Psychtoolbox

% skip synchronization test
if code == 1
    Screen('Preference', 'SkipSyncTests', 1);
end

% if debug==1
%     PsychDebugWindowConfiguration(0,0.6);
% % Here we call some default settings for setting up Psychtoolbox
% else
%     PsychDefaultSetup(2);
% 
% end

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = max(screens);

% % Define black and white (white will be 1 and black 0). This is because
% % in general luminace values are defined between 0 and 1 with 255 steps in
% % between. With our setup, values defined between 0 and 1.
% white = WhiteIndex(screenNumber);
% black = BlackIndex(screenNumber);
% grey=0.7;

white = [255 255 255];
grey = [128 128 128];
black = [0 0 0];

% settings for small window (1) or full screen presentation
if little_window == 1

    % Start cordinate in pixels of our window. Note that setting both of these
    % to zero will make the window appear in the top right of the screen.
    startXpix = 900;
    startYpix = 50;
    
    % Dimensions in pixels of our window in the X (left-right) and Y (up down)
    % dimensions
    dimX = 600;
    dimY = 400;
    
    % Open an on screen floating window using PsychImaging 
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, background_color,...
    [startXpix startYpix startXpix + dimX startYpix + dimY], [], [], [], [], [], kPsychGUIWindow);

else

    % Open an on screen window using PsychImaging
%     [window, windowRect] = PsychImaging('OpenWindow', screenNumber, background_color);

    [window, windowRect] = Screen('OpenWindow', screenNumber, grey);

end

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
% https://www.youtube.com/watch?v=7eFGY6JVTnc
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% set variable
exit_task = 0;

KbName('UnifyKeyNames');

%% setting up vpixx

 if no_dial == 0 %there is a dial
        LoadPsychHID 
        KbName('UnifyKeyNames');
        devices = PsychHID('Devices');

        devIdx = find([devices(:).usageValue] == 6);
        serialNum = {};
        keyboardId = {};
        for i = 1:length(devices)
            serialNum{i} = devices(i).serialNumber; %#ok
            if devices(i).usageValue == 6
                keyboardId{i} = devices(i).manufacturer;  %#ok
            end
        end
        key5 = [KbName('5%') KbName('5')];

        bbxIdx=find(strcmp(serialNum,'R727M'));
        bbx = intersect(bbxIdx, devIdx);
        dialIdx=find(strcmp(serialNum,'R1303'));
        dialID = intersect(dialIdx, devIdx);
        disp(num2str(dialID));
    else
        dialID = 0;
 end

% The avaliable keys to press
escapeKey = KbName('ESCAPE');
cwKey = KbName('t');
ccwKey = KbName('b');
ansKey = KbName('space');
%%% ListenChar(2); %to suppress output to Matlab command line
    
%% Datapixx
        Datapixx('Open')
        Datapixx('StopAllSchedules');
        Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache

%% Start Trigger
% scaHideCursor();

% if no_dial == 0%if there is a dial
%     if debug==0
%         Datapixx('Open')
%         Datapixx('StopAllSchedules');
%         Datapixx('RegWrRd');    % Synchronize DATAPixx registers to local register cache
%     end
% 
%     %manual trigger using the 5 key
%     key5down=0;
%     while ~key5down
%          % Draw text
%         Screen('TextSize', window, 60);
%         Screen('TextFont', window, 'Courier');
%         DrawFormattedText(window, 'WAITING FOR TRIGGER', 'center', 'center', white);
%     
%         % Flip to the screen
%         Screen('Flip', window);
%         [keyisdown, secs, keycode] = KbCheck(-1);
%         key5down = keycode(key5);               
%     end
%     disp('Triggered!')       
% else
% end
    
%%  Loop through trials
trialType=[1]; % [1,1,1,1,1,2,3];% 1-5 - button press, 6,7 - dial movement
color={'red'}; % ,'green','blue','yellow','white'};
button='none';
dialMove='none';


for idx=1:numel(trialType)
    
    disp(num2str(idx))
    %% Sequence of button presses

    %Shows sequence of instructions for button presses. Records the button that
    %was pressed as well
    if trialType(idx)==1
        
        text =['Press ' color{idx} ' button'];


        % Draw text
        Screen('TextSize', window, 60);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window, text, 'center', 'center', white);

        % Flip to the screen
        Screen('Flip', window);

        % set variable
        timeout = 0;    

        % while timeout keeps being equal to zero
        while ~timeout

            %check the buttonbox response
            Datapixx('RegWrRd');
            kbcheck = dec2bin(Datapixx('GetDinValues'));

                %Check red button presses
                if contains(color{idx},'red')
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
                % Green button press     
                elseif contains(color{idx},'green')
                    if kbcheck(end-2) == '1' || kbcheck(end-7)=='1'
                        if kbcheck(end-2) == '1'
                            button='left green';
                            % Draw text
                            Screen('TextSize', window, 60);
                            Screen('TextFont', window, 'Courier');
                            DrawFormattedText(window, [button ' pressed'], 'center', 'center', white);
                            % Flip to the screen
                            Screen('Flip', window);
                            WaitSecs(2);
                        else
                            button='right green';
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
                % Blue button press
                elseif contains(color{idx},'blue')
                    if kbcheck(end-3) == '1' || kbcheck(end-8)=='1'
                        if kbcheck(end-3) == '1'
                            button='left blue';
                            % Draw text
                            Screen('TextSize', window, 60);
                            Screen('TextFont', window, 'Courier');
                            DrawFormattedText(window, [button ' pressed'], 'center', 'center', white);
                            % Flip to the screen
                            Screen('Flip', window);
                            WaitSecs(2);
                        else
                            button='right blue';
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
                % Yellow button press
                elseif contains(color{idx},'yellow')
                    if kbcheck(end-1) == '1' || kbcheck(end-6)=='1'
                        if kbcheck(end-1) == '1'
                            button='left yellow';
                            % Draw text
                            Screen('TextSize', window, 60);
                            Screen('TextFont', window, 'Courier');
                            DrawFormattedText(window, [button ' pressed'], 'center', 'center', white);
                            % Flip to the screen
                            Screen('Flip', window);
                            WaitSecs(2);
                        else
                            button='right yellow';
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
                % White button press
                elseif contains(color{idx},'white')
                    if kbcheck(end-4) == '1' || kbcheck(end-9)=='1'
                        if kbcheck(end-4) == '1'
                            button='left white';
                            % Draw text
                            Screen('TextSize', window, 60);
                            Screen('TextFont', window, 'Courier');
                            DrawFormattedText(window, [button ' pressed'], 'center', 'center', white);
                            % Flip to the screen
                            Screen('Flip', window);
                            WaitSecs(2);
                        else
                            button='right white';
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
                end
        end
        
    elseif trialType(idx)==2 %right dial move
        
        %Set parameters for your stimuli on screen
        % Make circle outline for probe screen
        
        
        %set the diameter of larger grey circle
        rhoCirclePix = 500;
        outlinecircRect = [0 0 2*rhoCirclePix 2*rhoCirclePix];
        outlineCircCenteredRect = CenterRectOnPointd(outlinecircRect, xCenter, yCenter);
        confirm = 0; 
        est = 0;%round(rand * 360);
        est1=est;
        arcDist = 30;
        arcRect = [outlineCircCenteredRect(1:2)-arcDist, outlineCircCenteredRect(3:4)+arcDist];
        firstMove=0;
        respOnset=0;
        respStartScreen = GetSecs;
        increments=15;
        
        
        % set variables
        timeout = 0; % logical variable to control time
        time = 0; % seconds
        
        % while timeout keeps being equal to zero
        while ~timeout
            %Draw the grey outline circle
            Screen('FillArc', window, black, arcRect, est, 0.5);
            Screen('FillOval',window, grey, outlineCircCenteredRect);
            Screen('FrameOval',window, white, outlineCircCenteredRect);
            Screen('DrawingFinished', window);  % Tell PTB no more drawing commands will be issued until the next flip
            
            %Draw instriction on the screen
            Screen('TextSize', window, 40);
            Screen('TextFont', window, 'Courier');
            DrawFormattedText(window,'Move the dial 90 degrees to the right', 'center', 'center', white);
        
        
            % Flip to the screen
            Screen('Flip', window);
            
            [left,right,confirm,quit] = buttonCheck(escapeKey,cwKey,ccwKey,ansKey,no_dial,dialID);
       
            if right == 1
                est = wrapTo360(est + increments);
                dialMove='right';
                disp('moved right')
            elseif left == 1
                est = wrapTo360(est - increments);
                dialMove='left';
                disp('moved left')       
            end
            
            %if the dial moved 90 degrees to the right then this trial ends
            if est-est1==90
                dialMove='right';
                timeout=1;  
            end
        end
        
        %Draw instriction on the screen
        Screen('TextSize', window, 60);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window,'The dial was moved to the right', 'center', 'center', white);
            
        % Flip to the screen
        Screen('Flip', window);
        
        WaitSecs(2)
        
    else
        
        %Set parameters for your stimuli on screen
        
        %set the diameter of larger grey circle
        rhoCirclePix = 500;
        outlinecircRect = [0 0 2*rhoCirclePix 2*rhoCirclePix];
        outlineCircCenteredRect = CenterRectOnPointd(outlinecircRect, xCenter, yCenter);
        confirm = 0; 
        est = 0;%round(rand * 360);
        est1=est;
        arcDist = 35;
        arcRect = [outlineCircCenteredRect(1:2)-arcDist, outlineCircCenteredRect(3:4)+arcDist];
        increments=15;
        
        
        % set variables
        timeout = 0; % logical variable to control time
        time = 0; % seconds
        
        % while timeout keeps being equal to zero
        while ~timeout
    

            %Draw the grey outline circle
            Screen('FillArc', window, black, arcRect, est, 0.5);
            Screen('FillOval',window, grey, outlineCircCenteredRect);
            Screen('FrameOval',window, white, outlineCircCenteredRect);
            Screen('DrawingFinished', window);  % Tell PTB no more drawing commands will be issued until the next flip
        
            %Draw instriction on the screen
            Screen('TextSize', window, 40);
            Screen('TextFont', window, 'Courier');
            DrawFormattedText(window,'Move the dial 90 degrees to the left', 'center', 'center', white);
            
            
            % Flip to the screen
            Screen('Flip', window);
            
            [left,right,confirm,quit] = buttonCheck(escapeKey,cwKey,ccwKey,ansKey,no_dial,dialID);
       
            if right == 1
                est = wrapTo360(est + increments);
                disp('moved right');
            elseif left == 1
                est = wrapTo360(est - increments);  
                disp('moved left');   
            end
            
            %if the dial moved 90 degrees to the left then this trial ends
            if est-est1==270
                dialMove='left';  
                timeout=1; 
            end
            
        end
        
        %Draw instriction on the screen
        Screen('TextSize', window, 40);
        Screen('TextFont', window, 'Courier');
        DrawFormattedText(window,'The dial was moved to the left', 'center', 'center', white);
            
        % Flip to the screen
        Screen('Flip', window);
        
        WaitSecs(2)
        
    end
            
    %Append the results to a csv file
    toWrite = toString(num2str(subject),num2str(session),num2str(idx),button,dialMove);

    fprintf(fileIDd,toWrite);
    
    
end


if (debug == 0) || (no_dial == 0)%either it is the real exp or we are debuggin with a dial imp to close the datapixx at the end of the experiment
    %datapixx shutdown
    Datapixx('RegWrRd');
    Datapixx('StopAllSchedules');
    Datapixx('Close');
end

if exist('parameters.fileIDd','var')
    fclose(parameters.fileIDd);file_closed = 1;
end
% save responses at the end of the task
save([output_folder '/responses_task.mat'], 'responses');

% Clear the screen.
sca   


%% Dependecies
function  string = toString(varargin)
string = strcat(strjoin(varargin,','),'\n');
end

%creating a wrapTo360 function since it doesnt exist in stimulus computer
%for fMRI
function d = wrapTo360(d)
d = mod(d,360);
end


function [left,right,confirm,quit] = buttonCheck(escapeKey,cwKey,ccwKey,ansKey,no_dial,dialID)

% global quit;
% global left;
% global right;
% global confirm;
% global no_dial;
% global dialID;

left = 0; right = 0; confirm = 0; quit = 0;
if no_dial == 1 %if there is no dial
    [~,~, keyCode] = KbCheck();
else
    [~,~, keyCode] = KbCheck(dialID);
end
if keyCode(escapeKey)
    quit = 1;
end
if keyCode(cwKey) % change this to the dial
    right = 1;
end
if keyCode(ccwKey) % change this to the dial
    left = 1;
end
if keyCode(ansKey)
    confirm = 1;
end

end

  