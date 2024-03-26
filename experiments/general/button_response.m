%% Experiment for testing/template for response buttons


clearvars
%Screen('Preference', 'SkipSyncTests', 0);
AssertOpenGL;  


vpix_use = 1; % 0 if vpixx is not conected

% https://docs.vpixx.com/matlab/recording-digital-input-from-a-responsepixx

% KEYBOARD SETUP
responseKeys = {'1', '2', '3', '4', '5'};
KbName('UnifyKeyNames');  
KbCheckList = [KbName('space'),KbName('ESCAPE'), KbName('leftarrow'), KbName('rightarrow')];
for i = 1:length(responseKeys)
    KbCheckList = [KbName(responseKeys{i}),KbCheckList];
end