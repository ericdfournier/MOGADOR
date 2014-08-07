%% Add Directory Tree to MATLAB Path

addpath(genpath('~/Repositories/MOGADOR'));
cd ~/Repositories/MOGADOR

%% Initialize Input Parameters

run ./prm/concaveLarge.m

%% Initialize Population

i = 1;
o = cell(p.maxGenerations,3);

o{i,1} = initPopFnc(...
    p.populationSize,...
    p.sourceIndex,...
	p.destinIndex,...
	p.objectiveVars,...
    p.objectiveFraction,...
	p.minimumClusterSize,...
    p.walkType,...
    p.randomness,...
    p.executionType,...
	p.gridMask          );

o{i,2} = popFitnessFnc(...
    o{1,1},...
    p.objectiveVars,...
    p.gridMask          );

o{i,3} = popAvgFitnessFnc(...
    o{1,1},...
    p.objectiveVars,...
    p.gridMask          );

%% Execute MOGADOR

convergence = 0;

disp('**Initiating Evolutionary Process**'); 

while convergence == 0
    
    currentPopulation = o{i,1};
    averageFitnessHistory = [o{1:i,3}];
        
    if i <= 2
        
        convergenceRate = 0;
        convergence = 0;
        
    elseif i == p.maxGenerations
        
        break;
    
    else
        
        convergenceAbsolute = fix(diff(averageFitnessHistory,1));
        convergenceRate = fix(diff(averageFitnessHistory,2));
        convergence = convergenceRate(i-2) <= 1E-10 ;
        
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
        p.mutationFraction,...
        p.mutationCount,...
        p.randomness,...
        p.gridMask          );
    
    fitness = popFitnessFnc(...
        mutation,...
        p.objectiveVars,...
        p.gridMask          );
    
    avgfitness = popAvgFitnessFnc(...
        mutation,...
        p.objectiveVars,...
        p.gridMask          );
    
    o{i+1,1} = mutation;
    o{i+1,2} = fitness;
    o{i+1,3} = avgfitness;
    
    disp(['*Generation: ',num2str(i),'*']);
   
    i = i+1;
        
end

disp('**Evolutionary Process Completed**');

%% Display Output Results

subplot(2,3,1);
popConvergencePlot(o,p);

subplot(2,3,2);
popSearchDomainPlot(o,1,p);

subplot(2,3,3);
fitnessTradeoffPlot(o{i,1}(1,:),p);

subplot(2,3,4);
popParetoFrontierPlot(o,i,p);

subplot(2,3,5);
popSearchDomainPlot(o,i,p);

[topVal, topRank] = sort(sum(o{i,2},2),'ascend');

subplot(2,3,6);
individualPlot(o{i,1}(topRank(7),:),p.gridMask);

%% Write Output Data

o = o(1:i,:);
cd ~/Repositories/MOGADOR/rslt
save(['simResults_',datestr(now,30),'.mat'],'o');