gridMask = zeros(100);
gridMask(1,:) = nan;
gridMask(:,1) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;
sourceIndex = [20 20];
destinIndex = [80 80];
iterations = 1000;
sigma = [10 0; 0 10];
plot = 0;

individual = pseudoRandomWalkFnc(gridMask,iterations,sigma,...
    sourceIndex,destinIndex,plot);

objective1 = randi([0 10],10000,1);
objective2 = randi([0 10],10000,1);
objective3 = randi([0 10],10000,1);

objectiveVars = horzcat(objective1, objective2, objective3);