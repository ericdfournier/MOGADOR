%% Preliminaries

cd ~/Repositories/MOGADOR
p = struct();

%% Load Grid Mask

load ./data/gridMask.mat
p.gridMask = gridMask;

%% Problem Initialization Parameters

p.objectiveCount = 3;
p.objectiveFraction = 0.2;
p.objectiveSimulationMean = 5;
p.objectiveSimulationRange = 100;

%% Population Initialization Parameters

p.populationSize = 1;
p.minimumClusterSize = 5;
p.sourceIndex = [40 20];
p.destinIndex = [110 100];

%% Selection Parameters

p.tournamentSize = 10;
p.selectionType = 0;
p.selectionProbability = 1; 

%% Mutation Parameters

p.mutationFraction = 1;
p.mutationCount = 1;

%% Crossover Parameters

p.crossoverType = 0;

%% Clear Variables

clearvars -except p