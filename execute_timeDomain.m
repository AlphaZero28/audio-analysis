clc;clear all;
low = load('low_data.mat');
low_data = low.low_data;
t_seg = low.t_seg;
[pks,locs,RMS,zcr,autocorr]=timeDomain(low_data,t_seg);