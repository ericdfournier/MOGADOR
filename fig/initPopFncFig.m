%% Preliminaries

cd ~/Repositories/MOGADOR/prm/

%% Load Parameter Data 

run convexSmall.m

%% Parameters

gS = size(p.gridMask);

%% Generate Top Centroids

[topCentroidMask, ~] = topCentroidsMaskFnc(...
    p.objectiveVars,...
    p.objectiveFraction,...
    p.minimumClusterSize,...
    p.gridMask);

%% Generate Distance

sourceBW = zeros(gS);
sourceBW(p.sourceIndex(1,1),p.sourceIndex(1,2)) = 1;
sourceDist = bwdist(sourceBW);
sourceDist(p.sourceIndex(1,1),p.sourceIndex(1,2)) = 100;

%% Compute Cluster Distance Mask

sourceDistVect = reshape(sourceDist,gS(1,1)*gS(1,2),1);
rangeSDV = range(sourceDistVect);
bands = linspace(1,rangeSDV,4);

band1LOG = sourceDistVect <= bands(2);
band2LOG = sourceDistVect > bands(2) & sourceDistVect <= bands(3);
band3LOG = sourceDistVect > bands(3) & sourceDistVect <= bands(4);

clusterDistMask = p.gridMask;
clusterDistMask(band1LOG) = 15;
clusterDistMask(band2LOG) = 35;
clusterDistMask(band3LOG) = 55;
clusterDistMask(logical(topCentroidMask)) = 1;
clusterDistMask(p.sourceIndex(1,1),p.sourceIndex(1,2)) = 15;

%% Compute Centroid Distance Mask

centroidDistMask = zeros(gS);
centroidDistMask(band1LOG) = 25;
centroidDistMask(band2LOG) = 50;
centroidDistMask(band3LOG) = 90;

finalMask = p.gridMask;
centroidDistMaskFinal = centroidDistMask.*finalMask.*topCentroidMask;

%% Randomly Select Base Points

basePoints = zeros(5,2);

basePoints(1,:) = p.sourceIndex;
basePoints(2,:) = [38 31];
basePoints(3,:) = [62 48];
basePoints(4,:) = [74 72];
basePoints(5,:) = p.destinIndex;

randBasePoints = zeros(gS);
randBasePoints(basePoints(1,1),basePoints(1,2)) = 1;
randBasePoints(basePoints(2,1),basePoints(2,2)) = 2;
randBasePoints(basePoints(3,1),basePoints(3,2)) = 3;
randBasePoints(basePoints(4,1),basePoints(4,2)) = 4;
randBasePoints(basePoints(5,1),basePoints(5,2)) = 5;

%% Create Search Shadows

bp1ShadowMask = sourceShadowMaskFnc(basePoints(1,:),p.destinIndex,p.gridMask);
band1Mask = p.gridMask;
band1Mask(band1LOG) = 1;
bp1ShadowMask = bp1ShadowMask.*band1Mask;

bp2ShadowMask = sourceShadowMaskFnc(basePoints(2,:),p.destinIndex,p.gridMask);
band2Mask = p.gridMask;
band2Mask(band2LOG) = 1;
bp2ShadowMask = bp2ShadowMask.*band2Mask;
bp2ShadowMask(bp2ShadowMask == 1) = 2;

bp3ShadowMask = sourceShadowMaskFnc(basePoints(3,:),p.destinIndex,p.gridMask);
band3Mask = p.gridMask;
band3Mask(band3LOG) = 1;
bp3ShadowMask = bp3ShadowMask.*band3Mask;
bp3ShadowMask(bp3ShadowMask == 1) = 3;

bp4ShadowMask = sourceShadowMaskFnc(basePoints(4,:),p.destinIndex,p.gridMask);
band4Mask = p.gridMask;
bp4ShadowMask = bp4ShadowMask.*band4Mask;
bp4ShadowMask(bp4ShadowMask == 1) = 4;

basePointShadow = bp1ShadowMask+bp2ShadowMask+bp3ShadowMask+bp4ShadowMask;
basePointShadow(sub2ind(gS,basePoints(:,1),basePoints(:,2))) = 5;
basePointShadow(p.sourceIndex(1,1),p.sourceIndex(1,2)) = 7;
basePointShadow(p.destinIndex(1,1),p.destinIndex(1,2)) = 10;
basePointShadow = basePointShadow.*p.gridMask;

%% Generate Pathways

sections = basePoints2WalkFnc(basePoints,p.gridMask);

finalPath = zeros(gS);
finalPath(sections') = 2;
finalPath(p.sourceIndex(1,1),p.sourceIndex(1,2)) = 6;
finalPath(p.destinIndex(1,1),p.destinIndex(1,2)) = 9;
finalPath(sub2ind(gS,basePoints(:,1),basePoints(:,2))) = 5;

%% Generate Plots

figure();

subplot(3,3,1);
imagesc(sum(p.objectiveVars,3));
axis square

subplot(3,3,2);
imagesc(p.gridMask);
axis square

subplot(3,3,3);
imagesc(topCentroidMask);
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