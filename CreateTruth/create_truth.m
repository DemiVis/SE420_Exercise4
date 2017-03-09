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
inputImgFilename = 'saturn_medium.jpg'

% Sobel
useAutoThreshold = true;
sobelThreshold = 0.001; 

%Hough
houghThreshold = ceil(0.3*max(H(:)));
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
if useAutoThreshold
    [sobelImg, thresh] = edge(grayImg, 'sobel');
else
    [sobelImg, thresh] = edge(grayImg, 'sobel', sobelThreshold);
end

figure
imshow(sobelImg);
titleStr = sprintf('Sobel Transformed Image, Thresh:%1.3f', thresh);
title(titleStr);

%% Hough
[rhoThetaImg,theta,rho] = hough(sobelImg);
peaks = houghpeaks(rhoThetaImg, houghNumLines, 'threshold',houghThreshold);
lines = houghlines(sobelImg, theta, rho, peaks, 'FillGap',5,'MinLength',7);

figure
subplot(1,2,1)
imshow(imadjust(mat2gray(rhoThetaImg)),[],'XData',theta,'YData',rho);
titleStr = sprintf('Hough Lines Rho Theta', thresh);
title(titleStr);
subplot(1,2,2)
imshow(colorImg)
title('Hough Lines on Image')
hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
end

%% Pyramidal Up