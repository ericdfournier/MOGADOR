gridMask = zeros(100);
gridMask(1,:) = nan;
gridMask(:,1) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;
sourceIndex = [20 20];
destinIndex = [80 80];
plot = 1;

[individual, indivParams] = pseudoRandomWalkFnc(...
    gridMask,sourceIndex,...
    destinIndex,plot);

%% Animate Path

pathVals = individual(any(individual,1));
pathLen = size(pathVals,2);

for i = 1:pathLen
    tmp = gridMask;
    tmp(pathVals(1,1:i)') = 3;
    tmp(sub2ind(size(gridMask),sourceIndex(1,1),sourceIndex(1,2))) = 7;
    tmp(sub2ind(size(gridMask),destinIndex(1,1),destinIndex(1,2))) = 10;
    imagesc(tmp);
    axis square;
    M(i) = getframe;
end

%% Play Movie

axis square
movie(M,1,48);

%% Export Movie as GIF Animated Image

cd('/Users/ericfournier/Desktop/');
movie2gif(M,'test.gif','DelayTime',0);