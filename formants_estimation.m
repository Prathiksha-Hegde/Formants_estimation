function [formant_1,formant_2] = formants_estimation( y,fs,frame_dur)
%function to extract formant 1 and formant 2 for voiced part of an audio file (sa1.wav) file and plot the formant trajectory  
% input: 1. x- sampled audio signal
% input: 2. fs- sampling rate of the audio signal
% input: 3. frame_dur- duration of each frame 
% output: 1. formant_1- array of formant 1(F1) of the signal of length= number of frames formed with the given frame duration
% output: 2. formant_2- array of formant 2(F2) of the signal of length= number of frames formed with the given frame duration
   
    frame_len = frame_dur *fs; % number of samples in each frame of the audio signal
    samples_signal = length(y); % number of samples in the sampled audio signal
    no_frames = floor(samples_signal/frame_len); % number of frames formed with the given duration of the frame
    new_sig =zeros(samples_signal,1); % array t store the voiced part of the speech
    count =0; % variable to track the amplitude changes above a threshold in the audio signal

    % extracting the voiced part of the audio signal
    for i=1:no_frames  % creating frames of the audio signal
        frame = y( (i -1) *frame_len +1 : frame_len *i); % extracting frames of audio signal
        amplitude = max(frame); % finding the maximum amplitude in each frame of audio signal
        if (amplitude > 0.011)  % set threshold to extract voiced frames
            count =count+1;
            new_sig((count -1)* frame_len +1 : frame_len * count) = frame;  % store the voiced frames into an array
        end

    end

    voiced_signal= new_sig(1:27296,:);% remove the last zeros of the voiced frames

    % creating frames for extracted voiced signal
    dur = length(voiced_signal)/fs; % duration of the voiced signal
    samples_signal= length(voiced_signal); % finding the total number of samples in the voiced signal
    no_samples_one_frame= floor((frame_dur* samples_signal)/ dur); % number of samples in one frame of the voiced signal
    no_of_frames = floor(dur/ frame_dur); % total number of frames that can be formed from voiced signal
    frame_ns =zeros(no_of_frames,no_samples_one_frame); % initializing a matrix to store the frames of the voiced signal
    strt_index=1; % initial index to extract voiced signal
    end_index=no_samples_one_frame; % index to indicate the end of each during frame extraction of voiced signal
    
    
    for j=1:no_of_frames
        frame_ns(j,:) = y(strt_index:end_index);
        strt_index=end_index+1;
        end_index=end_index+no_samples_one_frame;
    end

    % initializing the formant 1 and formant 2 vectors
    [rows, col]= size(frame_ns);
    formant_1 = zeros(rows,1);
    formant_2 = zeros(rows,1);
    
    % extracting formant frequencies using Linear Predicitive Coding(LPC)
    for i=1:rows    
        seg1=frame_ns(i,:).'; % considering each frame of the 
        x=seg1.*hamming(length(seg1)); % extracted frame of voiced signal is windowed through hamming window
        preemph=[1 0.63];
        x=filter(1,preemph,x); % passing the extracted frame through pre-emphasis filter
        X=fft(x);
        [a,e]=lpc(x,22); % expecting 10 formants in each frame so , oder of the lpc=(2*number of formants expected)+2
        Xlpc=freqz(1,a);
        formant=20*log10(abs(Xlpc));
        rr=roots(a); % calculating roots of the prediction polynomial obtained from lpc
        norm_freq=angle(rr); % calculating angle of the roots obtained
        freq_Hz=(norm_freq*fs)/(2*pi); % converting the frequency in radians to HZ scale
        freq_hz=sort(abs(freq_Hz)); % sorting the frequency in HZ scale 
        v=length(freq_Hz);% finding the number of frequencies in Hz scale
        
        nn = 1;
        for kk = 1:2:length(freq_Hz)
            formants(nn) = freq_hz(kk); % storing the frequencies in Hz scale into formants array
            nn = nn+1;
        end

        % finding the first two formant frequencies by discarding the other formants  
        formant_1(i) = formants(1);
        if formants(1) >0 && formants(2) >0
            formant_1(i)= formants(1);
            formant_2(i) = formants(2);
        elseif formants (1) > 0 && formants(2) == 0
            formant_1(i)= formants(1);
            formant_2(i)= formants(3);
        elseif formants(1)== 0 && formants(2)> 0   
            formant_1(i) = formants(2);
            formant_2(i) = formants(3);
        else
            formant_1(i)= formants(3);
            formant_2(i)= formants(4);
        end
    end

    % plotting the formant 1 vs formant 2  
    figure(1);
    sz = 25;
    scatter (formant_1, formant_2)
    xlabel('Formant 1');
    ylabel('Formant 2');
    title('Formant 1 Vs Formant 2 for sa1.wav file');

    % plotting the formant trajectory of first two formant frequencies
    figure(2);
    for i =1: no_of_frames
        scatter(i,formant_1(i),'r');
        hold on;
        scatter(i,formant_2(i),'g');
        legend('Formant 1(F1)','Formant 2(F2)');
        xlabel('Frame number');
        ylabel('Formant 1 and Formant 2');
        title('Formant trajectory for sa1.wav file');
    end
end


