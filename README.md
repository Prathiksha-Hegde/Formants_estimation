Function to extract first two formant frequencies of the voiced part of the audio signal using Linear Predictive Coding. Here the audio signal used is sa1.wav file. <br />
input: 1. x- sampled audio signal <br />
input: 2. fs- sampling rate of the audio signal<br />
input: 3. frame_dur- duration of each frame <br />
output: 1. formant_1- array of formant 1(F1) of the signal of length= number of frames formed with the given frame duration<br />
output: 2. formant_2- array of formant 2(F2) of the signal of length= number of frames formed with the given frame duration<br />
Plot 1: Plot for Formant 1 vs Formant 2 of the voiced part of the audio signal<br />
Plot 2: Plot for formant trajectory<br />

Here, the threshold to extract voiced part of the signal is selected by selecting the signal only above a certain amplitude.
  
