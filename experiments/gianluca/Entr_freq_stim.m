function frame_value = Entr_freq_stim(refRate, freq_desired)
    ifi = 1/refRate;
    frames = [1:1:40];
    freqs =  refRate ./ frames;
    % Find the index where the frequency is closest to freq_desired
    [~, idx] = min(abs(freqs - freq_desired));
    frame_value = frames(idx); % Corresponding frame value
end

