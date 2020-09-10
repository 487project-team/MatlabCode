%uses Webcam Support Package
clc;
format compact;
close all;
%use the next line to load an image
    I = imread('FakeGage.png'); %%Opens Image File
%use the next two lines to load webcam photo
    %cam = webcam('Logitech HD Webcam C310'); % 480x640 pixel image
    %I = snapshot(cam);
    %imwrite(I,'FakeGage3.png');
[Size ~] = size(I); %tailors big circle size to 
tarsize(1) = round((Size-50)/2 - 70,-1); %may have to be adjusted for new webcam
tarsize(2) = round((Size-50)/2 + 30,-1); %target size (large face)
starsize = round(tarsize./4,-1); %small target size (small face)
subplot(2,2,1), imshow(I); %displays image
%converts image to an edged black&white image
I2 = rgb2gray(I); %% Converts RGB to greyscale
BW1 = edge(I2,'Canny',[0.0 0.08]); %%Finds all the edges in the photo

%crop image to just include the gage
[centersO, radiiO, ~] = imfindcircles(BW1,[tarsize],'Method','TwoStage','ObjectPolarity','bright','Sensitivity',0.96,'EdgeThreshold',0.20);
xminO = centersO(1) - radiiO - 10;
yminO = centersO(2) - radiiO - 10;
widthO = 2*(radiiO+10);
BW1 = imcrop(BW1,[xminO yminO widthO widthO]);
subplot(2,2,2), imshow(BW1);

%finds the big and small circles for each gage face
[centers, radii, ~] = imfindcircles(BW1,[starsize],'Method','TwoStage','ObjectPolarity','bright','Sensitivity',0.86,'EdgeThreshold',0.00);
[centers2, radii2, ~] = imfindcircles(BW1,[tarsize],'Method','TwoStage','ObjectPolarity','bright','Sensitivity',0.94,'EdgeThreshold',0.00);
centersAll = [centers; centers2];
radiiAll = [radii; radii2];
viscircles(centersAll, radiiAll,'EdgeColor','b'); %displays circles for verification

%find coordinates of the small gage (100 mil needle)
xmin = centers(1) - radii;
ymin = centers(2) - radii;
width = 2*radii;
%create small gage b&w image for analysis
BWC = imcrop(BW1,[xmin ymin width width]);
BWC = imresize(BWC,2);

%hough lines for the small gage
[H,theta,rho] = hough(BWC);
PS = houghpeaks(H,1);
linesS = houghlines(BWC,theta,rho,PS,'MinLength',10,'Fillgap',20);
subplot(2,2,3), imshow(BWC), hold on;
PlotLines(linesS,BWC);

%hough lines for the large gage
[H,theta,rho] = hough(BW1);
PL = houghpeaks(H,5);
linesL = houghlines(BW1,theta,rho,PL,'MinLength',120,'Fillgap',20);
subplot(2,2,4), imshow(BW1), hold on;
PlotLines(linesL,BW1);