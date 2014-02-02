%% Develop Example Candidate Pathways

n = 500;
gridMask = zeros(n);
gridMask(1,:) = nan;
gridMask(:,1) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;
sourceIndex = [20 20];
destinIndex = [480 480];
popSize = 1;
minClusterSize = 3;
objectiveVars = randi([0 10],n^2,3);
objectiveFrac = 0.1;

[individual, popParams] = initPopFnc(popSize,objectiveVars,...
objectiveFrac,minClusterSize,sourceIndex,destinIndex,gridMask);

%% Simplify Pathway

tolerance = 2;

simpIndividual = simplifyWalkFnc_DEV(individual,tolerance,gridMask);

%% Comparison Plot

figure();

subplot(1,2,1);
individualPlot(individual,gridMask);

subplot(1,2,2);
individualPlot(simpIndividual,gridMask);