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
    averageFitnessHistory = [o{1:i,3}];
        
    if i <= 2
        
        convergenceCriteria = 0;
        convergence = 0;
        
    elseif i == p.maxGenerations
        
        break;
    
    else
        
        convergenceCriteria = fix(diff(averageFitnessHistory,2));
        convergence = convergenceCriteria(i-2) <= 0.0001 ;
        
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

%% Epigenetic Smoothing



%% Display MOGADOR Results

subplot(2,3,1);
popConvergencePlot(o,p);

subplot(2,3,2);
popParetoFrontierPlot(o,i,p);

subplot(2,3,2);


subplot(2,3,4);
pop

subplot(2,3,5);
popSearchDomainPlot(o,1,p);

subplot(2,3,6);
popSearchDomainPlot(o,i,p);

%% Write Output Data

o = o(~isempty(o));
cd ~/Repositories/MOGADOR/rslt
save(['simResults_',datestr(now,30),'.mat'],'o');