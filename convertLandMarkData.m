clear; close all; clc; 

%% Control parameters

%File name to import (use uigetfile to browse instead)
fileName='/home/kevin/Downloads/Right rectus outline.fcsv'; 
% fileName=uigetfile;

numPointsResample=25; %Number of points allong slice curves
numPointsResampleSlice=100; %Number of points in slice direction
stlExportOption=0; %Export STL option 1=YES, 2=NO, exports to same folder as input file

%% Background on interpolation method. 
% 4 methods are available:
%
% 'pchip'   -> piece-wise cubic Hermite interpolation
% 'linear'  -> linear interpolation
% 'nearest' -> Cubic smoothing spline based interpolation
%  p        -> Cubic smoothing spline based interpolation, p should be a
%  smoothing parameter. p=1 results in cubic spline based interpolation
%  (fits all data points), if p<1 a smoothing interpolation is used (fit
%  may depart from data points to enforce smooth nature). Using p=0 results
%  in a straight line fit. 
%
% The methods 'pchip' and cubic smoothing are recommended. 

%%

%p-value for cubic smoothing spline based interpolation
interpMethod=0.001; 

% %Piece-wise cubic Hermite interpolation
% interpMethod='pchip'; 

%% Import data 

V=import_fcsv(fileName); %Cloud point coordinate array

%% Visualize marker cloud

cFigure; hold on; 
title('The landmark points')
plotV(V,'k.','MarkerSize',35);
axisGeom;
drawnow;

%% Fit surface 

[Fq,Vq]=sliceCloud2Surf(V,numPointsResample,numPointsResampleSlice,interpMethod);

%% Calculate surface area

A=patch_area(Fq,Vq);
A_total=sum(A(:));

%% Visualize fitted surface

cFigure; hold on; 
title(['Surface area: ',num2str(A_total),' mm^3'])
hp(1)=plotV(V,'k.','MarkerSize',35);
hp(2)=gpatch(Fq,Vq,'gw','g');
legend(hp,{'Landmarks','Surface reconstruction'});
axisGeom;
camlight headlight; lighting gouraud;
drawnow;

%% Export to STL

if stlExportOption==1
    [Ft,Vt]=quad2tri(Fq,Vq);
    [savePath,fileNameClean,~]=fileparts(fileName);
    fileNameSTL=fullfile(savePath,[fileNameClean,'.stl']);
    stlStruct.solidNames={'surface'};
    stlStruct.solidVertices={Vt};
    stlStruct.solidFaces={Ft};
    stlStruct.solidNormals={[]};    
    export_STL_txt(fileNameSTL,stlStruct);
end

