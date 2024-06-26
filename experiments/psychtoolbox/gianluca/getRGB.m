function col = getRGB(trig)

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Convert EEG trigger codes (1-255) to Viewpixx trigger codes 
% (RGB)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%

    % trigger codes
    triggerCodes = [ 4  0  0; ...  0 usually "Stimulus bit 0"
                16  0  0; ...  1
                64  0  0; ...  2
                 0  1  0; ...  3
                 0  4  0; ...  4
                 0 16  0; ...  5
                 0 64  0; ...  6
                 0  0  1; ...  7 usually "Stimulus bit 7"
                 ];

    bit_num = dec2bin(trig);
    n_bit_num = length(bit_num);
    
    indx = n_bit_num - find(bit_num(1:end) == '1') + 1;
    rgb_num = sum(triggerCodes(indx,:), 1);

    R = rgb_num(1); G = rgb_num(2); B = rgb_num(3);
    col = [R G B]/255;
end