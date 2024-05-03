% function [resp, time] = getButton()

Datapixx('Open');

while true
    Datapixx('RegWrRd');
    kbcheck = dec2bin(Datapixx('GetDinValues'));

%     if kbcheck(end) == '1' || kbcheck(end-3) == '1' || kbcheck(end-2) == '1' || kbcheck(end-1) == '1'
%     
    if kbcheck == '111111111111110000000010'
        response = 'left yellow';
    end
    

% button states = 111111111111110000000010 = left yellow
% button states = 111111111111110000000100 = left green
% button states = 111111111111110000000001 = left red
% button states = 111111111111110000001000 = left blue
% button states = 111111111111110100000000 = right blue
% button states = 111111111111110010000000 = right green
% button states = 111111111111110001000000 = right yellow
% button states = 111111111111110000100000 = right red


%     switch kbcheck
%         case 111111111111110000000010
%             disp('left yellow')
%         case 111111111111110000000100
%             disp('left green')
%         case 111111111111110000000001
%             disp('left red')
%         case 111111111111110000001000
%             disp('left blue')
%         otherwise
%             disp('Unknown value')
%     end
    time = GetSecs;
end
% if kbcheck(end) == '1' || kbcheck(end-2) == '1' || kbcheck(end-1) == '1' || kbcheck(end-3) == '1' || kbcheck(end-4) == '1' || kbcheck(end-5) == '1' || kbcheck(end-6) == '1' || kbcheck(end-7) == '1' || kbcheck(end-8) == '1' || kbcheck(end-9) == '1' 
%         for i_but = 1:9
             buttonBox(i_but) = str2num(kbcheck(end-9+i_but));
%         end
%         
%         resp = find(buttonBox);
%         time = GetSecs;
%         if length(resp) == 1
%             break;
%         end
%     end
% end


Datapixx('Close');


