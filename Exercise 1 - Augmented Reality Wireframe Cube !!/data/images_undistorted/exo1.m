clc
clear all

img = imread('img_0001.jpg');
img =rgb2gray(img);

[M,N]=size(img);

imshow(img,[]);

hold on
C = detectHarrisFeatures(img)

imshow(C,[]);
[X,Y]=meshgrid(1:N, 1:M);
