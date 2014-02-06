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

%% Population Initialization Parameters

p.populationSize = 50;
p.minimumClusterSize = 4;
p.sourceIndex = [80 40];
p.destinIndex = [220 200];

%% Selection Parameters

p.tournamentSize = 10;
p.selectionType = 0;
p.selectionProbability = 1; 

%% Mutation Parameters

p.mutationFraction = 1;
p.mutationCount = 1;

%% Crossover Parameters

p.crossoverType = 0;

%% Genetic Algorithm Parameters

p.maxGenerations = 100;

%% Randomly Generate Objective Variables

p.objectiveVars = randi(p.objectiveMax,[size(gridMask) p.objectiveCount]);

%% Clear Variables

clearvars -except p