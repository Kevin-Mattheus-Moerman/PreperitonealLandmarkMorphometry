function [Fs,Vs]=sliceCloud2Surf(V,numPointsResample,numPointsResampleSlice,interpMethod)

% function [Fs,Vs]=sliceCloud2Surf(V,interpMethod)
%-------------------------------------------------------------------------
%
%
% Kevin Mattheus Moerman, 2019/04/26 
% ------------------------------------------------------------------------
%%
% Get slice z-levels
sliceLevels=unique(V(:,3));
numSliceLevels=numel(sliceLevels); 
X=zeros(numSliceLevels,numPointsResample);
Y=zeros(numSliceLevels,numPointsResample);
Z=zeros(numSliceLevels,numPointsResample);
for q=1:1:numSliceLevels
   logicNow=V(:,3)==sliceLevels(q);   
   if nnz(logicNow)>1
       V_now=V(logicNow,:);
              
       if q==5
           V_now=flipud(V_now);
       end
       [R]=pointSetPrincipalDir(V_now);
              
       n=R(1,:); 
           
       V_now_p=(R*V_now')';
       [~,indSort]=sort(V_now_p(:,1));
    
       if dot(n,[1 0 0])<0
           indSort=flipud(indSort);
       end
       
       V_now=V_now(indSort,:);
       
%        quiverVec(V_now(1,:),n,10,'r');
       
       V_now_new=evenlySampleCurve(V_now,numPointsResample,interpMethod,0);
       X(q,:)=V_now_new(:,1);
       Y(q,:)=V_now_new(:,2);
       Z(q,:)=V_now_new(:,3);
   else
       X(q,:)=NaN;
       Y(q,:)=NaN;
       Z(q,:)=NaN;
   end
   

end
X=X(all(~isnan(X),2),:);
Y=Y(all(~isnan(Y),2),:);
Z=Z(all(~isnan(Z),2),:);

%%

Xn=zeros(numPointsResampleSlice,numPointsResample);
Yn=zeros(numPointsResampleSlice,numPointsResample);
Zn=zeros(numPointsResampleSlice,numPointsResample);

for q=1:1:numPointsResample
   V_now_new=evenlySampleCurve([X(:,q) Y(:,q) Z(:,q)],numPointsResampleSlice,interpMethod,0);
   Xn(:,q)=V_now_new(:,1);
   Yn(:,q)=V_now_new(:,2);
   Zn(:,q)=V_now_new(:,3);
end

[Fs,Vs]=surf2patch(Xn,Yn,Zn);
