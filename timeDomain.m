function [pks,locs,RMS,zcr,autocorr] = timeDomain(low_data,t_seg)
% This function will show the time domain features like Peak values, 
%RMS, ZRC values of the input data
%   Detailed explanation goes here
% low_data = downsampled data
% t_seg = time segment of the data
% pks = local peak values
% locs = location of local peak values
% RMS = rms value of the signal
%% Finding local peaks
indices = 1:length(low_data);     % creating index matrix
[pks, locs] = findpeaks(low_data);% finding local peaks and locations
low_dt = linspace(min(t_seg),max(t_seg),length(low_data)); % creating time matrix
pks_locs = [];                    % assigning locations of the peaks matrix
% creating locations of the peaks matrix
for i = 1: length(locs)
    loc = locs(i);
    pks_loc = low_dt(loc);          % getting the location
    pks_locs = [pks_locs pks_loc ]; % storing in pks_locs matrix
end
% showing plot with peaks
figure()
plot(pks_locs,pks,'or','LineWidth',1.4);        % peaks plot
hold on;
plt8 = plot(low_dt,low_data,'LineWidth',1.4);   % low_data plot
xlim([min(low_dt) max(low_dt)]);
plt88 = get(plt8,'parent');
set(plt88,'linewidth',1.4);
xlabel('Time (Seconds)');
ylabel('Amplitude');
title('Downsampling signal with peaks');
% displaying the result
disp('Times of local peaks');
disp(pks_locs);
disp('Values of local peaks');
disp(pks);

%% Finding RMS of the signal
RMS = rms(low_data); % rms value
X = sprintf('RMS value %0.4f',RMS); % taking upto 4 point float
disp(X);

%% ZCR (zero crossing rate)
%zcr = mean(abs(diff(sign(Signal)));
zero_crossing = sum(abs(diff(low_data>0)));
T = max(t_seg)-min(t_seg);
zcr = zero_crossing/T;
Y = sprintf('Zero crossing rate %0.4f',zcr);
disp(Y);

%% Autocorrelation Calculation
[row,col] =size(low_data);  % getting no of row & col from low_data matrix
if ( row>col)
    x = transpose(low_data);% converting into row matrix
else
    x = low_data;
end

h = fliplr(x);      % creating 2nd matrix for autocorrelation
n1 = 0:length(x)-1; % generating indices for x data
n2 = -fliplr(n1);   % generating indices for h data
z=[]; % assigning 
for i=1:length(x)
    g=h.*x(i);      % multiplication with each h component
    z=[z;g];        % storing data
end

[r, c]=size(z);     %getting no of row & col from z matrix
k = r+c;
t = 2; 
autocorr = [];
cd = 0;
% diagonal additon 
while(t<=k) 
    for i=1:r
        for j=1:c
            if((i+j)==t)     % getting diagonal elements
               cd=cd+z(i,j); % diagonal addition
            end
        end
    end
    t=t+1;
    autocorr=[autocorr cd];  % storing autocorrelation data in each step
    cd=0;                    % return to zero
end

nl=min(n1)+min(n2);          % low point on autocorrelation indices
nh=max(n1)+max(n2);          % high point on autocorrelation indices
idx=nl:1:nh;                 % generating indices
%plotting
figure('color','w'); 
p = stem(idx,autocorr,'filled', ...
'MarkerEdgeColor','white','MarkerFaceColor',[0.3 0.4 0.7]);
g = get(p,'Parent');
set(g,'LineWidth',1.4,'FontSize',14);
ylim([min(autocorr)-1e-3 12e-3]);
xlabel('Indices');
ylabel('Amplitude');
title('Autocorrelation');

end

