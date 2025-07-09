function [Fs,Vs]=sliceCloud2Surf(V,numPointsResample,numPointsResampleSlice,interpMethod)

% function [Fs,Vs]=sliceCloud2Surf(V,interpMethod)
%-------------------------------------------------------------------------
%
%
% Kevin Mattheus Moerman, 2019/04/26 
% ------------------------------------------------------------------------
%%

% Get slice z-levels
sliceLevels=unique(V(:,3)); %Get slice levels
numSliceLevels=numel(sliceLevels); %Number of slice levels

%% Resample within slice curves 

%Allocate coordinate matrices
X=zeros(numSliceLevels,numPointsResample);
Y=zeros(numSliceLevels,numPointsResample);
Z=zeros(numSliceLevels,numPointsResample);

%Loop over all levels and resample curves
for q=1:1:numSliceLevels
   logicNow=V(:,3)==sliceLevels(q);   
   if nnz(logicNow)>1
       V_now=V(logicNow,:); %Getting points in current slice             
       V_now_new=evenlySampleCurve(V_now,numPointsResample,interpMethod,0); %Resample
       X(q,:)=V_now_new(:,1); Y(q,:)=V_now_new(:,2); Z(q,:)=V_now_new(:,3); %Coordinates
   else
       %Use nan values if there is not more than 1 point
       X(q,:)=NaN; Y(q,:)=NaN; Z(q,:)=NaN;
   end
end

%Remove potential NaN entries
X=X(all(~isnan(X),2),:); Y=Y(all(~isnan(Y),2),:); Z=Z(all(~isnan(Z),2),:);

%% Resample across slice curves

%Allocate coordinate matrices
Xn=zeros(numPointsResampleSlice,numPointsResample);
Yn=zeros(numPointsResampleSlice,numPointsResample);
Zn=zeros(numPointsResampleSlice,numPointsResample);

%Loop over all curve points
for q=1:1:numPointsResample
   V_now_new=evenlySampleCurve([X(:,q) Y(:,q) Z(:,q)],numPointsResampleSlice,interpMethod,0);
   Xn(:,q)=V_now_new(:,1); Yn(:,q)=V_now_new(:,2); Zn(:,q)=V_now_new(:,3); %Coordinates
end

%% Compose patch data for output
[Fs,Vs]=surf2patch(Xn,Yn,Zn);

