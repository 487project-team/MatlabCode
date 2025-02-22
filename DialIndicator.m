function  [outputlarge,outputsmall] = DialIndicator()
%uses Webcam Support Package
format compact; close all;

%use the next line to load an image
    I = imread('FakeGage2.png'); %%Opens Image File
%use the next two lines to load webcam photo
    %cam = webcam('Logitech HD Webcam C310'); % 480x640 pixel image
    %I = snapshot(cam);
    %imwrite(I,'FakeGage3.png');
[Size, ~] = size(I); %tailors big circle size to 
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
outputsmall = PlotLines(linesS,BWC);
% an angle of 400 represents an error, such as small hand being covered up.
% the program will prompt user input of the angle.
    if outputsmall == 400
       smallnumber = 11;
       while (smallnumber < 0 || smallnumber >= 10)
          smallnumber = str2double(inputdlg('Enter the number the small hand has is nearest.',...
           'Indeterminate Small Hand Angle',[1 30]));
       end
       outputsmall = 400 + smallnumber;
    end
hold off;

%hough lines for the large gage
[H,theta,rho] = hough(BW1);
PL = houghpeaks(H,5);
linesL = houghlines(BW1,theta,rho,PL,'MinLength',120,'Fillgap',20);
subplot(2,2,4), imshow(BW1), hold on;
outputlarge = PlotLines(linesL,BW1);
hold off;
% 
    if outputlarge == 400
       msgbox('Unable to determine the angle of the large hand. Reattempt reading.','Indeterminate Large Hand Angle')
    end
end