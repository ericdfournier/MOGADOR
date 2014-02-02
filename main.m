%% Preliminaries

cd(['/Users/ericfournier/Google Drive/PhD/Dissertation/Project/',...
    'Genetic Algorithms/']);
load gridMask.mat
scaleFactor = 1;
gridMask = imresize(gridMask,scaleFactor,'nearest');

%% Randomly Generate Objective Variables
 
objectiveVars = randi([0 10],size(gridMask,1)*size(gridMask,2),3);

%% Simulate Objective Variables 

%Only do this for gridMasks of size [100 100] or less...

%objectiveVars = simObjectivesFnc(3,5,100,gridMask);

%% Population Initialization Parameters

objectiveFrac = 0.2;
popSize = 5;
minClusterSize = 5.*scaleFactor;
sourceIndex = scaleFactor.*[40 20];
destinIndex = scaleFactor.*[110 100];

%% Initiate Population

tic
[initialPop, ~] = initPopFncDEV(popSize,objectiveVars,...
    objectiveFrac,minClusterSize,sourceIndex,destinIndex,gridMask);
toc

%% View Population Search Domain

popSearchDomainPlot(initialPop,sourceIndex,destinIndex,gridMask);

%% Initiate Scores

initialScores = initScoresFnc(initialPop,objectiveVars);

%% Initiate Ranges

initialRanges = initRangesFnc(popParams.genomeLength,gridMask);

%% Population Selection Parameters

tournamentSize = 10;
selectionType = 0;
selectionProb = 1; 

%% Perform Initial Population Selection

outputPop = tournamentSelectionFnc(initialPop,tournamentSize,...
    selectionProb,selectionType,objectiveVars);

%% View Population Selection

popSearchDomainPlot(outputPop,sourceIndex,destinIndex,gridMask);

%% Crossover Parameters

crossoverType = 0;

%% Perform Crossover

gen1Pop = popCrossoverFnc(outputPop,sourceIndex,destinIndex,...
    crossoverType,gridMask);

%% View Crossover Results

popSearchDomainPlot(gen1Pop,sourceIndex,destinIndex,gridMask);

%% Mutation Parameters

fraction = 1;
mutations = 1;

%% Perform Mutation

gen1PopMut = popMutationFnc(gen1Pop,gridMask,fraction,mutations);

%% View First Generation Population

popSearchDomainPlot(gen1PopMut,gridMask);
