%% Preliminaries

cd('/Users/ericfournier/Google Drive/PhD/Dissertation/Project/Genetic Algorithms/');

%% Simulate Grid Mask

gridMask = zeros(200);
gridMask(:,1) = nan;
gridMask(1,:) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;
gSize = size(gridMask);

sourceIndex = [20 20];
destinIndex = [180 180];
genomeLength = 5000;

%% Simulate Objective Variables

%  (Only for gridMask of size[100 100] or Smaller)

% simObjCount = 3;
% simMean = 5;
% simRange = 10;
% 
% objectiveVars = simObjectivesFnc(simObjCount,simMean,simRange,gridMask);
% aggObjectiveVars = sum(objectiveVars,2);

%% Randomly Generate Objective Variables

objectiveVars = randi([0 10],40000,3);
aggObjectiveVars = sum(objectiveVars,2);

%% Mask Out Top 10 Percent of the Aggregated Objective Vars

fraction = 0.05*(gSize(1,1)*gSize(1,2));
minClusterSize = 5; % THIS SHOULD BE AN INPUT ARGUMENT

[sortObj, sortInd] = sort(aggObjectiveVars,'ascend');
topfraction = sortInd(1:fraction,1);
mask = gridMask;
mask(topfraction) = 1;
imagesc(mask);

%% Identify Clusters & Cluster Centroids and Sort Them by Area

bw = bwconncomp(mask);
rg = regionprops(bw,'centroid','area'); 
rgCell = struct2cell(rg)';
rgArea = cell2mat(rgCell(:,1));
rgCentroid = floor(cell2mat(rgCell(:,2)));
rgArea_Centroid = horzcat(rgArea,rgCentroid);
rgSort = flipud(sortrows(rgArea_Centroid,1));

%% Eliminate Clusters Smaller than User Specified Minimum Cluster Size

topCentroids = rgSort(rgSort(:,1) >= minClusterSize,2:3);
sizeTC = size(topCentroids);

%% Compute All Possible Pairwise Combinations of Selected Clusters

topPairComb = nchoosek(1:1:sizeTC(1,1),2);
sizeTPC = size(topPairComb);
bp1C = topCentroids(topPairComb(:,1),:);
bp2C = topCentroids(topPairComb(:,2),:);

%% Between-ness Check

s_d = -sign(repmat(sourceIndex,[sizeTPC(1,1),1])-repmat(destinIndex,...
    [sizeTPC(1,1),1]));
s_bp1C = -sign(repmat(sourceIndex,[sizeTPC(1,1),1] )-bp1C(:,:));
bp2C_bp2C = -sign(bp1C(:,:)-bp2C(:,:));
bp2C_d = -sign(bp2C(:,:)-repmat(destinIndex,[sizeTPC(1,1),1]));
validInd = s_d == s_bp1C == bp2C_bp2C == bp2C_d;
betweenCheck = any(validInd,2);

basePoint1 = bp1C(betweenCheck,:);
basePoint2 = bp2C(betweenCheck,:);

%%  NEED TO LOOP THROUGH ALL OF THE COMBINATIONS AND GENERATE WALK SECTIONS
%   THEN STRING THOSE LINKAGES TOGETHER INTO A SINGLE FINAL OUTPUT PATH

sizeBP = size(basePoint1,1);
finalPop = zeros(sizeBP,genomeLength);
plot = 0;

for i = 1:sizeBP
    
    s_bp1 = pseudoRandomWalkFnc_DEV(gridMask,genomeLength,sourceIndex,...
        basePoint1(i,:),plot);
    section1 = s_bp1(any(s_bp1,1));
    
    bp1_bp2 = pseudoRandomWalkFnc_DEV(gridMask,genomeLength,...
        basePoint1(i,:),basePoint2(i,:),plot);
    tmp2 = bp1_bp2(any(bp1_bp2,1));
    section2 = tmp2(1,2:end-1);
    
    bp2_d = pseudoRandomWalkFnc_DEV(gridMask,genomeLength,...
        basePoint2(i,:),destinIndex,plot);
    tmp3 = bp2_d(any(bp2_d,1));
    section3 = tmp3(1,2:end);
    
    sections = horzcat(section1,section2,section3);
    sizeSect = size(sections,2);
    finalPop(i,1:sizeSect) = sections; 
    
end