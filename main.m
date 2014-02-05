%% Add Directory Tree to MATLAB Path

addpath(genpath('./MOGODOR'));
cd ./MOGODOR

%% Initialize Input Parameters

run ./prm/convexLarge.m

%% Initialize Ouput Parameters

o = cell(p.maxGenerations,2);

%% Initialize Population

o{1,1} = initPopFnc(...
    p.populationSize,...
    p.sourceIndex,...
	p.destinIndex,...
	p.objectiveVars,...
    p.objectiveFraction,...
	p.minimumClusterSize,...
	p.gridMask          );

%% Evaluate Initial Population Fitness

o{1,2} = popFitnessFnc(...
    o{1,1},...
    p.objectiveVars,...
    p.gridMask          );

%% Execute MOGADOR

i = 1; 
convergence = 0;

while convergence == 0
    
    if i == p.maxGenerations
        
        break;
        
    end
    
    currentPopulation = o{i,1};

    selection = tournamentSelectionFnc(...
        currentPopulation,...
        p.tournamentSize,...
        p.selectionProbability,...
        p.selectionType,...
        p.objectiveVars     );

    crossover = popCrossoverFnc(...
        selection,...
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
    
    averageFitness
    
    i = i+1;
    
    % Insert Convergence IF/THEN Stopping Condition Here
    
end

%% Write Output Data

o = o(~isempty(o));
cd ~/Repositories/MOGADOR/rslt
save(['simResults_',datestr(now,30),'.mat'],'o');

%% Generate Output Figures

% Put sample figure here
