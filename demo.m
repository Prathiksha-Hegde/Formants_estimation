% read the sa1.wav file
[x,fs] = audioread('sa1.wav'); % reading the sa1.wav file

% calling the function to calculate formants for the audio file by creating frames of 20ms
[formant_1,formant_2 ]= formants_estimation(x,fs,0.02);