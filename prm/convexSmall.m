%% Preliminaries

cd ~/Repositories/MOGADOR
p = struct();

%% Load Grid Mask

load ./data/gridMaskConvexSmall.mat
p.gridMask = gridMask;

%% Problem Initialization Parameters

p.objectiveCount = 3;
p.objectiveFraction = 0.2;
p.objectiveSimulationMean = 100;
p.objectiveSimulationRange = 100;
p.objectiveNames = {'Var1','Var2','Var3'};
p.walkType = 2;
p.executionType = 0;
p.randomness = 10;

%% Population Initialization Parameters

p.populationSize = 100;
p.minimumClusterSize = 3;
p.sourceIndex = [20 20];
p.destinIndex = [80 80];

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

%% Simulate Objective Variables

p.objectiveVars = simObjectivesFnc(...
    p.objectiveCount,...
    p.objectiveSimulationMean,...
	p.objectiveSimulationRange,...
	p.gridMask          );

%% Plotting Function Optional Arguments

p.modelFit = 1;
p.objectiveIndices = [1 2 3];

%% Problem Concavity

p.concave = 0;

%% Clear Variables

clearvars -except p