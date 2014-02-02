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

obj1 = reshape(objectiveVars(:,1),100,100);
obj2 = reshape(objectiveVars(:,2),100,100);
obj3 = reshape(objectiveVars(:,3),100,100);

%% Population Initialization Parameters

popSize1 = 1;
minClusterSize = 2;
sourceIndex = [20 20];
destinIndex = [80 80];
objectiveFrac = 0.10;

%% Initialize Population 1

[initialPop1, popParams1] = initPopFnc_DEV(popSize1,objectiveVars,...
    objectiveFrac,minClusterSize,sourceIndex,destinIndex,gridMask);

%% Change PopSize

popSize2 = 10;

%% Initialize Population 2

[initialPop2, popParams2] = initPopFnc_DEV(popSize2,objectiveVars,...
    objectiveFrac,minClusterSize,sourceIndex,destinIndex,gridMask);

%% Change PopSize 

popSize3 = 100;

%% Initialize Population 3

[initialPop3, popParams3] = initPopFnc_DEV(popSize3,objectiveVars,...
    objectiveFrac,minClusterSize,sourceIndex,destinIndex,gridMask);

%% Generate Plot

figure();

subplot(1,3,1);
popSearchDomainPlot(initialPop1,sourceIndex,destinIndex,gridMask);

subplot(1,3,2);
popSearchDomainPlot(initialPop2,sourceIndex,destinIndex,gridMask);

subplot(1,3,3);
popSearchDomainPlot(initialPop3,sourceIndex,destinIndex,gridMask);


