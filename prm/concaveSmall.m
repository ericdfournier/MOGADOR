%% Preliminaries

cd ~/Repositories/MOGADOR
p = struct();

%% Load Grid Mask

load ./data/gridMaskConcaveSmall.mat
p.gridMask = gridMask;

%% Problem Initialization Parameters

p.objectiveCount = 3;
p.objectiveFraction = 0.8;
p.objectiveSimulationMean = 5;
p.objectiveSimulationRange = 100;
p.objectiveMax = 10;
p.objectiveNames = {'Var1','Var2','Var3'};
p.walkType = 2;

%% Population Initialization Parameters

p.populationSize = 100;
p.minimumClusterSize = 2;
p.sourceIndex = [40 20];
p.destinIndex = [110 100];

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

p.objectiveVars = randi(p.objectiveMax,[size(gridMask) p.objectiveCount]);

% p.objectiveVars = simObjectivesFnc(...
%     p.objectiveCount,...
%     p.objectiveSimulationMean,...
% 	p.objectiveSimulationRange,...
% 	p.gridMask          );

%% Plotting Function Optional Arguments

p.modelFit = 1;
p.objectiveIndices = [1 2 3];

%% Problem Concavity

p.concave = 1;

%% Clear Variables

clearvars -except p