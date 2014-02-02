%% Develop Example Candidate Pathways

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
popSize = 10;

[inputPop] = initializePopFnc(popSize,gridMask,iterations,sigma,sourceIndex,destinIndex);
parent1 = inputPop(1,:);
parent2 = inputPop(2,:);

crossoverType = 0;

%% Test crossoverFmc

[child] = crossoverFnc(parent1,parent2,crossoverType);

%% Test crossoverPlot

plotHandle = crossoverPlot(parent1,parent2,child,gridMask);