clearvars
%Screen('Preference', 'SkipSyncTests', 0);
AssertOpenGL;  

% KEYBOARD SETUP
    responseKeys = {'2', '3', 'y', 'n'};
    KbName('UnifyKeyNames');  
    KbCheckList = [KbName('space'),KbName('ESCAPE'), KbName('leftarrow'), KbName('rightarrow')];
    for i = 1:length(responseKeys)
        KbCheckList = [KbName(responseKeys{i}),KbCheckList];
    end

    % SCREEN SETUP
    screens = Screen('Screens');
    
    s = 1;

    [w, rect] = Screen('Openwindow',s,[0 0 0])
    
    Priority(MaxPriority(w));
    
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);    
    pixelSizes=Screen('PixelSizes', s);
    fps=Screen('FrameRate',w);
    ifi=Screen('GetFlipInterval', w);
    
    [wx, wy] = RectCenter(rect);
    Screen('Flip', w)
    
    
    % %VIEW PIXX SETUP
    % Datapixx('Open');
    % Datapixx('EnablePixelMode');  % to use topleft pixel to code trigger information, see https://vpixx.com/vocal/pixelmode/
    % Datapixx('RegWr');


    % TRIGGERS SETUP
    trigRect = [0 0 1 1]; % Top left pixel that controls triggers in PixelMode
    trig.closed = [16  0  0]; % RGB color for top left pixel to trigger a channel on MEG
    % [16 0 0]  in binary is [10000 0 0] ==> Means pin number 4 on digital
    % output of Vpixx will be triggered
    % Ref: https://docs.vpixx.com/vocal/defining-triggers-using-pixel-mode
    
    trig.open = [64  0  0];
    % [64 0 0] in binary is [1000000 0 0] means pin number 7 will be triggered 

    % STIMULI SETUP
    
    fixRadius = 30;
    fixRect = CenterRectOnPoint([0, 0, fixRadius*2, fixRadius*2], wx, wy);
    fixColor = [150 150 150];
    
    time2rest = 5;
    
    % START EXPERIMENT
    
    Screen('DrawText', w, 'PRESS SPACE AND START CLOSED EYES REST',  wx-250, wy, [255,255,255]);
    Screen('Flip', w);
    KbWait([],2)
    

    Screen('FillRect', w, trig.closed, trigRect);
    Screen('Flip', w);
    WaitSecs(time2rest)

    Screen('DrawText', w, 'PRESS SPACE AND START OPEN EYES REST',  wx-250, wy, [255,255,255]);
    Screen('Flip', w); 
    KbWait([],2)


    Screen('FillRect', w, trig.open, trigRect);
    Screen('FillOval', w, fixColor, fixRect);
    Screen('Flip', w);
    WaitSecs(time2rest)


    Screen('CloseAll');