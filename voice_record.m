% this is record an audio signal of 44.1kHz sampling freq.

Fs = 44.1e3;
ch = 1;
datatype = 'unit8';
nbits = 16;
Nseconds = 10;

recorder = audiorecorder(Fs,nbits,ch);
disp('Start speaking');

recordblocking(recorder,Nseconds);
disp('End of recording');

x = getaudiodata(recorder);
audiowrite('speach.wav',x,Fs);
