%% Develop Example Candidate Pathways

n = 500;
gridMask = zeros(n);
gridMask(1,:) = nan;
gridMask(:,1) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;
sourceIndex = [20 20];
destinIndex = [480 480];
popSize = 2;
minClusterSize = 3;
objectiveVars = randi([0 10],n^2,3);
objectiveFrac = 0.1;

[inputPop, popParams] = initPopFnc(popSize,objectiveVars,...
objectiveFrac,minClusterSize,sourceIndex,destinIndex,gridMask);

parent1 = inputPop(1,:);
parent2 = inputPop(2,:);

crossoverType = 0;

%% Test crossoverFmc

[child, crossoverParams] = crossoverFnc(parent1,parent2,sourceIndex,destinIndex,...
    crossoverType,gridMask);

%% Crossover Plot

crossoverPlot(parent1,parent2,child,sourceIndex,destinIndex,gridMask);