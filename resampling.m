function [low_data,new_fs] = resampling(filename,n1,n2)
% This function will be used to convert the 44.1kHz sampled audio signal 
% to 16kHz.
% filename = path of audio file
% n1 = start point of segment
% n2 = end point of segment
% low_data = data after downsampling
% new_fs = downsampled sampling frequency

%% importing the speech audio
[data, fs] = audioread(filename);   % import the speech audio file
len = length(data);                 % length of the data
T = 1/fs;
t = (0:len-1)*T;                    % creating time matrix

%% plotting original speech signal
figure('Color','w')                     % making figure background color white
plt1 = plot(t, data/max(abs(data)));    % normalize data plot against time
plt11 = get(plt1,'parent');
set(plt11,'linewidth',1.4,'fontsize',14);%increasing axis linewidth
xlabel('Time (Second)');
ylabel('Amplitude');
title('Original Speech Signal');

%% Segmentation 
data_seg = data(n1:n2);     % cropping a segment from original data
len_seg = length(data_seg); % length of the segment
t_seg = t(n1:n2);           % croping same time segment for data
%t_seg = t(72400:70560); 

% normal plotting
figure('color', 'w'); 
plt2 = plot(t_seg, data_seg/max(abs(data_seg)),'LineWidth',1.4); % plot of the segment
plt22 = get(plt2,'parent');
set(plt22,'linewidth',1.4,'fontsize',14);
title('Segmented original signal');
xlim([min(t_seg) max(t_seg)]);  % setting x axis limit
ylim([-1.2 1.2])                % setting y axis limit
xlabel('Time (second)');
ylabel('Amplitude');

% stem plotting
figure('color','w');
plt3 = stem(data_seg/max(abs(data_seg)),'filled', ...
'MarkerEdgeColor','white','MarkerFaceColor',[0.3 0.4 0.7]); % normalize plot
plt33 = get(plt3,'parent');
set(plt33,'linewidth',1.4,'fontsize',14)
xlim([0 len_seg+10]);
ylim([ -1.2 1.2]);
title('Segmented original signal')
xlabel('Number of Samples');
ylabel('Amplitude');

%% Upsampling 
L = 4;
up_sam = resample(data_seg,L,1);  %  upsampling by L factor

figure('color','w');
plt4 = stem(up_sam/max(abs(up_sam)),'filled', ...
    'MarkerEdgeColor','white','MarkerFaceColor',[0.3 0.4 0.7]);
plt44 = get(plt4,'parent');
set(plt44,'linewidth',1.4,'fontsize',14)
xlim([ 1 length(up_sam)+10]);
ylim([-1.2 1.2]);               % setting y axis limit
title('Upsampled to 176.4 kHz');
xlabel('Number of Samples');
ylabel('Amplitude');

%% Downsampling with decimator
M = 11;
low_filt = lowFilt(up_sam,M,1,5);    % passing to a low pass filter
low_data = low_filt([1:M:length(low_filt)]); % downsampling by M factor
new_fs = fs*L/M;                     % new sampling frequency

figure('color','w');
plt5 = stem(low_data/max(abs(low_data)),'filled', ...
    'MarkerEdgeColor','white','MarkerFaceColor',[0.3 0.4 0.7]);
plt55 = get(plt5,'parent');
set(plt55,'linewidth',1.4,'fontsize',14)
title('Downsampled to 16.03 KHz ')
ylim([-1.2 1.2])
xlabel('Number of Samples');
ylabel('Amplitude');

%% Save as .mat file
save('low_data.mat','low_data','t_seg');

%% function for low pass filter
function [out] = lowFilt(input,factor,gain,order)
    h = designfilt('lowpassfir','FilterOrder',order,'CutoffFrequency',1/factor);
    out = gain*filter(h,input);
end
end

