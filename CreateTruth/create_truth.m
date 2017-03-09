%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To create the "truth" images for the output from each of the C transforms
% specified below:
%   - Sobel Edge Detection
%   - Hough Lines Detection
%   - Pyramidal Up Conversion
%   - Pyramidal Down Conversion
%
% Author: Matthew Demi Vis (Vis,iting Venusian)
%         vism@my.erau.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Input Parameters
inputImgFilename = 'saturn_medium.jpg';

% Sobel
useAutoThresholdSobel = true;
sobelThreshold = 0.001; 

%Hough
useAutoThresholdHough = true;
houghThreshold = 50;
houghNumLines = 5;


%% Setup for Image transformations
close all

colorImg = imread(inputImgFilename);
[height, width] = size(colorImg);
grayImg = rgb2gray(colorImg);

imshow(colorImg);
titleStr = sprintf('Input Image. %dx%d', width, height);
title(titleStr);

%% Sobel
if useAutoThresholdSobel
    [sobelImg, thresh] = edge(grayImg, 'sobel');
else
    [sobelImg, thresh] = edge(grayImg, 'sobel', sobelThreshold);
end

figure
imshow(sobelImg);
titleStr = sprintf('Sobel Transformed Image, Thresh:%1.3f', thresh);
title(titleStr);
imwrite(sobelImg, 'SobelOut.ppm', 'ppm');

%% Hough
[rhoThetaImg,theta,rho] = hough(sobelImg);
if useAutoThresholdHough
    peaks = houghpeaks(rhoThetaImg, houghNumLines);
else
    peaks = houghpeaks(rhoThetaImg, houghNumLines, 'threshold',houghThreshold);
end
lines = houghlines(sobelImg, theta, rho, peaks, 'FillGap',5,'MinLength',7);

figure
imshow(imadjust(mat2gray(rhoThetaImg)),[],'XData',theta,'YData',rho);
titleStr = sprintf('Hough Lines Rho Theta');
title(titleStr);
imwrite(imadjust(mat2gray(rhoThetaImg)), 'RhoThetaOut.ppm', 'ppm');

figure
imshow(colorImg)
title('Hough Lines on Image')
hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
end
imwrite(sobelImg, 'HoughOut.ppm', 'ppm');

%% Pyramidal Up