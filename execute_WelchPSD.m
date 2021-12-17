clc;clear all;
low = load('low_data.mat');
low_data = low.low_data;
t_seg = low.t_seg;
fs = 16.03e3;
[Px,freq]=WelchPSD(low_data,t_seg,fs);