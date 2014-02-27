%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/MOGADOR'));
cd ~/Repositories/MOGADOR

%% Initialize Input Parameters

run ./prm/convexLarge.m

%% Initialize Ouput Parameters

o = cell(p.maxGenerations,3);

%% Initialize Population

o{1,1} = initPopFnc(...
    p.populationSize,...
    p.sourceIndex,...
	p.destinIndex,...
	p.objectiveVars,...
    p.objectiveFraction,...
	p.minimumClusterSize,...
	p.gridMask          );

%% Evaluate Initial Population Individual Fitness

o{1,2} = popFitnessFnc(...
    o{1,1},...
    p.objectiveVars,...
    p.gridMask          );

%% Evaluate Initial Population Average Fitness

o{1,3} = popAvgFitnessFnc(...
    o{1,1},...
    p.objectiveVars,...
    p.gridMask          );

%% Execute MOGADOR

i = 1; 
convergence = 0;

while convergence == 0
    
    currentPopulation = o{i,1};
    averageFitnessHistory = o{1:i,3};
    
    if i == p.maxGenerations
        
        break;
        
    end
        
    if i <= 2
        
        convergenceCriteria = [];
        convergence = 0;
    
    else
        
        convergenceCriteria = fix(diff(averageFitnessHistory,2));
        convergence = convergenceCriteria(i-2) == 0 ;
        
    end

    selection = popTournamentSelectionFnc(...
        currentPopulation,...
        p.tournamentSize,...
        p.selectionProbability,...
        p.selectionType,...
        p.objectiveVars,...
        p.gridMask          );
    
    crossover = popCrossoverFnc(...
        selection,...
        p.populationSize,...
        p.sourceIndex,...
        p.destinIndex,...
        p.crossoverType,...
        p.gridMask          );

    mutation = popMutationFnc(...
        crossover,...
        p.gridMask,...
        p.mutationFraction,...
        p.mutationCount     );
    
    fitness = popFitnessFnc(...
        mutation,...
        p.objetiveVars      );
    
    o{i+1,1} = mutation;
    o{i+1,2} = fitness;
    
    i = i+1;
        
end

%% Write Output Data

o = o(~isempty(o));
cd ~/Repositories/MOGADOR/rslt
save(['simResults_',datestr(now,30),'.mat'],'o');

%% Generate Output Figures

% Put sample figure here
