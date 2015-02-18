%% Preliminaries

cd ~/Repositories/MOGADOR
p = struct();

%% Load Grid Mask

load ./data/gridMaskConvexLarge.mat
p.gridMask = gridMask;

%% Problem Initialization Parameters

p.objectiveCount = 3;
p.objectiveFraction = 0.2;
p.objectiveMax = 10;
p.objectiveNames = {'Var1','Var2','Var3'};
p.walkType = 2;

%% Population Initialization Parameters

p.populationSize = 100;
p.minimumClusterSize = 5;
p.sourceIndex = [20 20];
p.destinIndex = [280 280];

%% Selection Parameters

p.selectionFraction = 0.5;
p.selectionProbability = 1; 

%% Mutation Parameters

p.mutationFraction = 1;
p.mutationCount = 1;

%% Crossover Parameters

p.crossoverType = 0;

%% Genetic Algorithm Parameters

p.maxGenerations = 100;

%% Randomly Generate Objective Variables

p.objectiveVariables = randi(p.objectiveMax,[size(gridMask) p.objectiveCount]);

%% Plot Parameters

p.modelFit = 1;
p.objectiveIndices = [1 2 3];

%% Problem Concavity

p.concave = 0;

%% Execution Type

p.executionType = 0;

%% Randomness Level

p.randomness = 2;

%% Clear Variables

clearvars -except p