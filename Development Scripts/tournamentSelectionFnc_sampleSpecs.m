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

[inputPop] = initializePopFnc(10,gridMask,iterations,sigma,sourceIndex,destinIndex);

objective1 = randi([0 10],10000,1);
objective2 = randi([0 10],10000,1);
objective3 = randi([0 10],10000,1);

objectiveVars = horzcat(objective1, objective2, objective3);

tournamentSize = 5;
selectionType = 0;
selectionProb = 1; % A value of 1 here indicates deterministic selection

popFitnessSum = populationFitnessFnc(inputPop,objectiveVars);

[test1, test2] = tournamentSelectionFnc(inputPop,tournamentSize,...
    selectionProb,selectionType,objectiveVars);