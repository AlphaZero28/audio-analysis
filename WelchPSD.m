function [Px,freq] = WelchPSD(low_data,t_seg,fs)
% This function will generete power spectrum density (PSD) using 
% Welch's method
% Px = power spectrum density
%freq = frequency matrix
% low_data = input data
% t_seg = time segment data
% fs = sampling frequency
%% Defining parameter 
L = length(low_data);   % length of the input data
overlap = 0.5;          % 50% overlap between windows
L_seq = 10;             % window length 
n1 = 1;                 % start point of the window
n2 = L_seq;             % end point of the window
n0 = (1-overlap)*L_seq; % increment in step
nsubseq = 1+floor((L-L_seq)/n0); % number of subsection window will run
Px = 0;                 % assigning PSD variable

%% Running a window over total input data 
for i = 1:nsubseq
   Px = Px + modified_periodogram(low_data,n1,n2)/nsubseq; % taking psd for each step
   n1 = n1+n0; % increasing start point
   n2 = n2+n0; % increasing end point
end

%% One-sided PSD calculation
len_Px = length(Px);
Px_one_sided = Px(1:len_Px/2);              %cropping the one side
%% Frequency matrix calculation
dt = linspace(min(t_seg),max(t_seg),len_Px);% creating time matrix
dt = transpose(dt);                         %transposing
freq = fs*1./dt;                            % converting to frequency matrix
freq = freq(1:len_Px/2);                    % compatable for one-sided fft

%% PSD plot
figure('color','w');
plt = plot(freq,Px_one_sided/max(Px_one_sided),'linewidth',1.4); %normalization
plt2 = get(plt,'parent');
set(plt2,'linewidth',1.4,'fontsize',14);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title("PSD using Welch's Method");
ylim([-0.2 1.2]);

%% PSD function
function Px = modified_periodogram(x,n1,n2)
N = n2-n1+1;        % length of the window
w = hanning(N);     % hanning window for tapering the input window data
U = norm(w)^2/N;    % normalization of hanning window
xw = x(n1:n2).*w;   % tapering with hanning window 
nfft = 2.^nextpow2(length(xw)); 
Px = abs(fft(xw,nfft)).^2/(N*U); % PSD calculation
Px(1) = Px(2);
end
end

