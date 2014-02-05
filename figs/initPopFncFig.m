%% Preliminaries

cd('/Users/ericfournier/Google Drive/PhD/Dissertation/Project/Genetic Algorithms/');

%% Simulate Grid Mask

n = 100;
gridMask = zeros(n);
gridMask(:,1) = nan;
gridMask(1,:) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;

%% Generate Objective Variables

objectiveVars = simObjectivesFnc(3,5,10,gridMask);

%% Generate Plot Data

aggObjRaw = sum(objectiveVars,2);
aggObj = reshape(aggObjRaw(:,1),100,100);

%% Select Objective Fraction

sizeObj = size(aggObjRaw,1);
frac = 0.1;
fracCount = frac*sizeObj;

[~,objSort] = sort(aggObjRaw,'ascend');
objInd = objSort(1:fracCount,1);

mask = gridMask;
mask(objInd) = 1;

%% Generate Top Centroids

minClusterSize = 10;
bw = bwconncomp(mask,4);
rg = regionprops(bw,'pixelidxlist','centroid','area');
sizeRG = size(rg,1);
centroidProps = zeros(sizeRG,3);

for i = 1:sizeRG
    centroidProps(i,1) = rg(i,1).Centroid(1,1);
    centroidProps(i,2) = rg(i,1).Centroid(1,2);
    centroidProps(i,3) = rg(i,1).Area;
end

centPropsSort = flipud(sortrows(centroidProps,3));
clusterInd = centPropsSort(:,3) >= 10;
validCentroids = floor(centPropsSort(clusterInd,1:2));
validCentroidsInd = sub2ind([100 100],validCentroids(:,2),validCentroids(:,1));
sizeVC = size(validCentroids,1);

rgCell = struct2cell(rg)';
rgCellSort = flipud(sortrows(rgCell,1));
topClusterInd = cell2mat(rgCellSort(2:sizeVC,3));

centroidMask = gridMask;
centroidMask(topClusterInd) = 2;
centroidMask(validCentroidsInd(2:end)) = 4;

%% Generate Distance

gridMaskClean = zeros(n);
sourceIndex = [20 20];
destinIndex = [80 80];
sourceBW = gridMaskClean;
sourceInd = sub2ind([100 100],sourceIndex(1,1),sourceIndex(1,2));
destinInd = sub2ind([100 100],destinIndex(1,1),destinIndex(1,2));
sourceBW(sourceInd) = 1;

sourceDist = bwdist(sourceBW);
sourceDist(sourceInd) = 100;
sourceDist(:,1) = nan;
sourceDist(1,:) = nan;
sourceDist(end,:) = nan;
sourceDist(:,end) = nan;

%% Compute Cluster Distance Mask

sourceDistVect = reshape(sourceDist,10000,1);
rangeSDV = range(sourceDistVect);
bands = linspace(1,rangeSDV,4);

band1LOG = find(sourceDistVect <= bands(2));
band2LOG = find(sourceDistVect > bands(2) & sourceDistVect <= bands(3));
band3LOG = find(sourceDistVect > bands(3) & sourceDistVect <= bands(4));

clusterDistMask = gridMask;
clusterDistMask(band1LOG) = 15;
clusterDistMask(band2LOG) = 35;
clusterDistMask(band3LOG) = 55;
clusterDistMask(topClusterInd) = 1;
clusterDistMask(sourceInd) = 15;

%% Compute Centroid Distance Mask

centroidDistMask = gridMask;
centroidDistMask(band1LOG) = 25;
centroidDistMask(band2LOG) = 50;
centroidDistMask(band3LOG) = 90;

finalMask = gridMask;
finalMask(validCentroidsInd(2:end)) = 1;

centroidDistMaskFinal = centroidDistMask.*finalMask;

%% Randomly Select Base Points

% centMask = gridMask;
% centMask(validCentroidsInd(2:end)) = 1;
% band1FinalMask = band1Mask.*centMask;
% band1 = find(band1FinalMask == 1);
% 
% band2Mask = gridMask;
% band2Mask(band2LOG) = 1;
% centMask = gridMask;
% centMask(validCentroidsInd(2:end)) = 1;
% band2FinalMask = band2Mask.*centMask;
% band2 = find(band2FinalMask == 1);
% 
% band3Mask = gridMask;
% band3Mask(band3LOG) = 1;
% centMask = gridMask;
% centMask(validCentroidsInd(2:end)) = 1;
% band3FinalMask = band3Mask.*centMask;
% band3 = find(band3FinalMask == 1);
% 
% basePoints(1,1) = band1(randi([1 size(band1,1)],1));
% basePoints(2,1) = band2(randi([1 size(band2,1)],1));
% basePoints(3,1) = band3(randi([1 size(band3,1)],1));

basePoints(1,1) = sub2ind([100 100],38,31);
basePoints(2,1) = sub2ind([100 100],62,48);
basePoints(3,1) = sub2ind([100 100],74,72);

randBasePoints = gridMask;
randBasePoints(basePoints) = 1;
randBasePoints(sourceInd) = 2;
randBasePoints(destinInd) = 3;

%% Create Search Shadows

[bpRow, bpCol] = ind2sub([100 100],basePoints);
bpRow = vertcat(sourceIndex(1,1),bpRow);
bpCol = vertcat(sourceIndex(1,2),bpCol);

bp1Shadow = gridMask;
bp1Shadow(bpRow(1,1):end-1,bpCol(1,1):end-1) = 1;
band1Mask = gridMask;
band1Mask(band1LOG) = 1;
bp1Shadow = bp1Shadow.*band1Mask;

bp2Shadow = gridMask;
bp2Shadow(bpRow(2,1):end-1,bpCol(2,1):end-1) = 1;
band2Mask = gridMask;
band2Mask(band2LOG) = 1;
bp2Shadow = bp2Shadow.*band2Mask;
bp2Shadow(bp2Shadow == 1) = 2;

bp3Shadow = gridMask;
bp3Shadow(bpRow(3,1):end-1,bpCol(3,1):end-1) = 1;
band3Mask = gridMask;
band3Mask(band3LOG) = 1;
bp3Shadow = bp3Shadow.*band3Mask;
bp3Shadow(bp3Shadow == 1) = 3;

basePointShadow = bp1Shadow+bp2Shadow+bp3Shadow;
basePointShadow(basePoints) = 5;
basePointShadow(sourceInd) = 7;
basePointShadow(destinInd) = 10;

%% Generate Pathway 

section1 = pseudoRandomWalkFnc(gridMask,sourceIndex,[38 31],0);
section2 = pseudoRandomWalkFnc(gridMask,[38 31],[62 48],0);
section3 = pseudoRandomWalkFnc(gridMask,[62 48],[74 72],0);
section4 = pseudoRandomWalkFnc(gridMask,[74 72],destinIndex,0);

finalPath = gridMask;

sect1 = section1(any(section1,1))';
sect2 = section2(any(section2,1))';
sect3 = section3(any(section3,1))';
sect4 = section4(any(section4,1))';

sections = vertcat(sect1,sect2(2:end),sect3(2:end),sect4(2:end));

finalPath(sections) = 1;
finalPath(sourceInd) = 6;
finalPath(destinInd) = 9;
finalPath(basePoints) = 5;

%% Generate Plots

figure();

subplot(3,3,1);
imagesc(aggObj);
axis square

subplot(3,3,2);
imagesc(mask);
axis square

subplot(3,3,3);
imagesc(centroidMask);
axis square

subplot(3,3,4);
imagesc(sourceDist);
axis square

subplot(3,3,5);
image(clusterDistMask);
axis square

subplot(3,3,6);
imagesc(centroidDistMaskFinal);
axis square

subplot(3,3,7);
imagesc(randBasePoints);
axis square

subplot(3,3,8);
imagesc(basePointShadow);
axis square

subplot(3,3,9);
imagesc(finalPath);
axis square