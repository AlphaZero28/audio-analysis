function [ft2,xfft2] = fftSpectrum(low_data,t_seg,fs)
% This function will show the direct FFT spectrum 
%   Detailed explanation goes here
%% FFT Implementation
L_seg = length(low_data);   % length of the input data
nfft = 2.^nextpow2(L_seg);  % converting to 2th power
down_fs = fs;               % sampling freq
ft = fft(low_data, nfft);   % nfft point fft 
ft2 = ft(1:nfft/2)/nfft;    % converting to one-sided fft

%% Frequency Matrix calculation
dt = linspace(min(t_seg),max(t_seg),nfft/2); % creating time matrix
xfft = down_fs*1./dt;       % converting to frequency matrix
xfft2 = transpose(xfft);    % transposing the matrix

%% FFT spectrum plot
figure('color','w'); % white figure background
plt = plot(xfft2,abs(ft2)/max(abs(ft2)),'LineWidth',1.4); % normalize plot
plt2 = get(plt,'parent');
set(plt2,'linewidth',1.4,'fontsize',14);
ylim([-0.2 1.2]);
title('FFT Spectrum');
ylabel('Amplitude');
xlabel('Frequency (Hz)');

end

