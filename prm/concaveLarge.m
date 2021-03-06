%% Preliminaries

cd ~/Repositories/MOGADOR
p = struct();

%% Load Grid Mask

load ./data/gridMaskConcaveLarge.mat
p.gridMask = gridMask;

%% Problem Initialization Parameters

p.objectiveCount = 3;
p.objectiveFraction = 0.2;
p.objectiveMax = 10;
p.objectiveNames = {'Var1','Var2','Var3'};
p.walkType = 2;
p.executionType = 0;
p.randomness = 2;

%% Population Initialization Parameters

p.populationSize = 100;
p.minimumClusterSize = 4;
p.sourceIndex = [80 40];
p.destinIndex = [220 200];

%% Selection Parameters

p.selectionFraction = 0.41;
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

%% Plotting Function Optional Arguments

p.modelFit = 1;
p.objectiveIndices = [1 2 3];

%% Problem Concavity

p.concave = 1;

%% Clear Variables

clearvars -except p