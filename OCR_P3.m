%uses Webcam Support and Package
% https://www.mathworks.com/help/vision/ug/automatically-detect-and-recognize-text-in-natural-images.html
% https://www.youtube.com/watch?v=BL9eP8qniwg
clc;
format compact;
close all;
I = imread('P3_3.jpg');
SI = imsharpen(I);
GI = imbinarize(SI,'adaptive','Sensitivity',0.65);
imshowpair(SI,GI,'montage');

Ires = ocr(GI);
Itext = Ires.Text
