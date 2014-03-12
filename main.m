%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/MOGADOR'));
cd ~/Repositories/MOGADOR

%% Initialize Input Parameters

run ./prm/convexSmall.m

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

o{1,2} = popFitnessFnc(...
    o{1,1},...
    p.objectiveVars,...
    p.gridMask          );

o{1,3} = popAvgFitnessFnc(...
    o{1,1},...
    p.objectiveVars,...
    p.gridMask          );

%% Execute MOGADOR

i = 1; 
convergence = 0;

while convergence == 0
    
    currentPopulation = o{i,1};
    averageFitnessHistory = [o{1:i,3}];
        
    if i <= 2
        
        convergenceAbsolute = 0;
        convergenceRate = 0;
        convergence = 0;
        
    elseif i == p.maxGenerations
        
        break;
    
    else
        
        convergenceAbsolute = fix(diff(averageFitnessHistory,1));
        convergenceRate = fix(diff(averageFitnessHistory,2));
        convergence = ...
            convergenceAbsolute(i-1) <= 0.00001 ||...
            convergenceRate(i-2) <= 0.00001 ;
        
    end

    selection = popSelectionFnc(...
        currentPopulation,...
        p.selectionFraction,...
        p.selectionProbability,...
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
        p.objectiveVars,...
        p.gridMask);
    
    avgfitness = popAvgFitnessFnc(...
        mutation,...
        p.objectiveVars,...
        p.gridMask);
    
    o{i+1,1} = mutation;
    o{i+1,2} = fitness;
    o{i+1,3} = avgfitness;
    
    i = i+1;
        
end

%% Display Output Results

subplot(2,2,1);
popConvergencePlot(o,p);

subplot(2,2,2);
popParetoFrontierPlot(o,i,p);

subplot(2,2,3);
popSearchDomainPlot(o,1,p);

subplot(2,2,4);
popSearchDomainPlot(o,i,p);

%% Write Output Data

o = o(~isempty(o));
cd ~/Repositories/MOGADOR/rslt
save(['simResults_',datestr(now,30),'.mat'],'o');