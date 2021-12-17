clc;clear all;
n1 = 72460; % start point of segment
n2 = 72620; % end point of segment
[low_data,new_fs]=resampling('speach.wav',n1,n2);