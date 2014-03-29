function [ output ] = MOGADOR( runType, params, varargin )
% MOGADOR.m Initializes a multi-objective genetic algorithm for the
% solution of the corridor location problem. The user is required to supply
% an input parameter object (structure object) which specifies the source
% of the input data for the for the corridor location problem as well as a
% number of parameter values that are used to control the operation of the
% algorithm.
%
% DESCRIPTION:
%
%   Function to execute a multi-objective genetic search algorithm for use
%   in solving the corridor location problem within a discrete 2-D search
%   domain. The input parameter structure object contains information about
%   the search domain location and extent as well as information about the
%   objective variables and various algorithmic processes. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ output ] = MOGADOR( runType, params, optionalArgs );
%
% INPUTS:
%
%   Required Input Arguments: 
%
%   runType =   'demo' | 'single' | 'batch'
%               Input string to determine the type of input data used to
%               parameterize the algorithm 
%
%               'demo' - Specifies that a demo parameter file and dataset 
%               named in the second required input parameter 'params' is to 
%               be used to execute the algorithm
%
%               'single' - Specifies that a parameter file named
%               in the second required input parameter 'params' is to
%               be used to execute the algorithm
%
%               'batch' - Specifies that a parameter folder 
%
% OUTPUTS:
%
%   output =    [j x k] double array containing the grid index values of 
%               the individuals within the population (Note: each 
%               individual corresponds to a connected 
%               pathway from the source to the destination grid cells 
%               within the study area)
%
% EXAMPLES:
%   
%   Example 1:
%
%   [ output ] = MOGADOR('demo','parameterFile');
%
%   % Executes the function on a previously specified demo problem with
%   % data layers and pre-tuned parameter values
%   
%   Example 2:
%       
%   [ output ] = MOGADOR('single','parameterFile');
%
%   % Executes the function on a user specified input parameter file stored
%   % in the 'prm' parameter sub directory of the MOGADOR toolbox file 
%   % system
%   
%   Example 3:
%   
%   [ output ] = MOGADOR('batch','parameterFolder');
%
%   % Sequentially xecutes the function on all of the input parameter files
%   % contained within a the 'parameterFolder' sub directory contained
%   % within the 'prm' parameter sub directory of the MOGADOR toolbox file
%   % system
%
%   Example 4: 
%   
%   [ ] = MOGADOR('single','parameterFile');
%   
%   % Supresses the return of the algorithm output to the active workspace.
%   % All alorithm outputs are written to the output results 'rslt' folder.
%
%   Example 5:
%   
%   [ output ] = MOGADOR('batch','parameterFolderName','output','true');
%
%   % 'Output' - Controls the writing of output data files for the MOGADOR 
%   % model run. This can be useful for testing parameter values before 
%   % running the algorithm in a full real world problem context. 
%
%   Example 6: 
%
%   [ output ] = MOGADOR('single','parameterFile','figures','true');
%
%   % 'Figures' - Controls the generation of output figures for the MOGADOR
%   % model run. This can be useful for testing parameter values before
%   % running the algorithm in a full real world problem context or
%   % generating figures on the model performance for further analysis.
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%                 University of California Santa Barbara               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x)...
    x >= 2);
addRequired(P,'nargout',@(x)...
    x <= 1);
addRequired(P,'runType',@(x)...
    ischar(x) == 1 &&...
    strcmp(x,'demo') == 1 ||...
    strcmp(x,'single') == 1 ||...
    strcmp(x,'batch') == 1);
addRequired(P,'parameters',@(x)...
    ischar(x) == 1);
addOptional(P,'figures','false');
addOptional(P,'figuresBool',@(x)...
    ischar(x) == 1 &&...
    strcmp(x,'true') == 1 ||...
    strcmp(x,'false') == 1);
addOptional(P,'output','true');
addOptional(P,'outputBool',@(x)...
    ischar(x) == 1 &&...
    strcmp(x,'true') == 1 ||...
    strcmp(x,'false') == 1);

parse(P,nargin,nargout,runType,params,figures,figuresBool);
    
%% Function Parameters

% Generate Run Type Switch Cases

if strcmp(runType,'demo') == 1
    runTypeSwitch = 1;
elseif strcmp(runType,'single') == 1
    runTypeSwitch = 2;
elseif strcmp(runType,'batch') == 1
    runTypeSwitch = 3;
else 
    error('runType string input not recognized'); 
end

% Generate Figures Switch Cases

if exist(figures,'var') == 1 && strcmp(figures,'true') == 1
    figuresSwitch = 1;
elseif exist(figures) == 1&& strcmp(figures,'false') == 1
    figuresSwitch = 2;
else 
    error('figures string input not recognized');
end

% Generate Output Switch Cases

if exist(output,'var') == 1 && strcmp(output,'true') == 1
    outputSwitch = 1;
elseif exist(output) == 1 && strcmp(output,'false') == 1
    outputSwitch = 2;
else
    error('output string input not recognized');
end

%% Switch on the Basis of Run Type

i = 1;

switch runTypeSwitch
    
    case 1
        
        run(['./prm/',params,'.m']);
        load(['./data/',params,'.mat']);
        parameters = p;
        runs = cell(1,1);
        runs{1,1} = o;
        
    case 2
        
        run(['./prm/',params,'.m']);
        parameters = p;
        output = cell(parameters.maxGenerations,3);
        runs = cell{1,1};
        
        output{i,1} = initPopFnc(...
            parameters.populationSize,...
            parameters.sourceIndex,...
            parameters.destinIndex,...
            parameters.objectiveVars,...
            parameters.objectiveFraction,...
            parameters.minimumClusterSize,...
            parameters.walkType,...
            parameters.gridMask          );
        
        output{i,2} = popFitnessFnc(...
            output{1,1},...
            parameters.objectiveVars,...
            parameters.gridMask          );
        
        output{i,3} = popAvgFitnessFnc(...
            output{1,1},...
            parameters.objectiveVars,...
            parameters.gridMask          );
        
        runs{1,1} = output;
        
    case 3
        
        dirContents = what(['./prm/',params]);
        paramsCount = size(dirContents.m,1);
        parameters = cell(1,paramsCount);
        runs = cell(1,paramsCount);
        
        for j = 1:paramsCount
            
            run(['./prm/',dirContents{j}]);
            parameters{1,j} = p;
            output = cell(parameters{1,k}.maxGenerations,3);
            
            output{i,1} = initPopFnc(...
                parameters.populationSize,...
                parameters.sourceIndex,...
                parameters.destinIndex,...
                parameters.objectiveVars,...
                parameters.objectiveFraction,...
                parameters.minimumClusterSize,...
                parameters.walkType,...
                parameters.gridMask          );
            
            output{i,2} = popFitnessFnc(...
                output{1,1},...
                parameters.objectiveVars,...
                parameters.gridMask          );
            
            output{i,3} = popAvgFitnessFnc(...
                output{1,1},...
                parameters.objectiveVars,...
                parameters.gridMask          );
            
            runs{1,j} = output;
            
        end
        
end

%% Execute MOGADOR



convergence = 0;

while convergence == 0
    
    currentPopulation = output{i,1};
    averageFitnessHistory = [output{1:i,3}];
        
    if i <= 2
        
        convergenceRate = 0;
        convergence = 0;
        
    elseif i == parameters.maxGenerations
        
        break;
    
    else
        
        convergenceAbsolute = fix(diff(averageFitnessHistory,1));
        convergenceRate = fix(diff(averageFitnessHistory,2));
        convergence = convergenceRate(i-2) <= 1E-10 ;
    end

    selection = popSelectionFnc(...
        currentPopulation,...
        parameters.selectionFraction,...
        parameters.selectionProbability,...
        parameters.objectiveVars,...
        parameters.gridMask          );
    
    crossover = popCrossoverFnc(...
        selection,...
        parameters.populationSize,...
        parameters.sourceIndex,...
        parameters.destinIndex,...
        parameters.crossoverType,...
        parameters.gridMask          );

    mutation = popMutationFnc(...
        crossover,...
        parameters.gridMask,...
        parameters.mutationFraction,...
        parameters.mutationCount     );
    
    fitness = popFitnessFnc(...
        mutation,...
        parameters.objectiveVars,...
        parameters.gridMask);
    
    avgfitness = popAvgFitnessFnc(...
        mutation,...
        parameters.objectiveVars,...
        parameters.gridMask);
    
    output{i+1,1} = mutation;
    output{i+1,2} = fitness;
    output{i+1,3} = avgfitness;
    
    disp(['Generation: ',num2str(i),' Completed']);
    
    i = i+1;
        
end

%% Execute Epigenetic Smoothing

i = i+1;

output{i,1} = popEpigeneticSmoothingFnc(output,i-1,parameters);

output{i,2} = popFitnessFnc(...
    output{i,1},...
    parameters.objectiveVars,...
    parameters.gridMask          );

output{i,3} = popAvgFitnessFnc(...
    output{i,1},...
    parameters.objectiveVars,...
    parameters.gridMask          );

%% Display Output Results

subplot(2,3,1);
popConvergencePlot(output,parameters);

subplot(2,3,2);
popSearchDomainPlot(output,1,parameters);

subplot(2,3,3);
fitnessTradeoffPlot(output{i,1}(1,:),parameters);

subplot(2,3,4);
popParetoFrontierPlot(output,i,parameters);

subplot(2,3,5);
popSearchDomainPlot(output,i,parameters);

[topVal, topRank] = sort(sum(output{4,2},2),'ascend');

subplot(2,3,6);
individualPlot(output{i,1}(topRank(7),:),parameters.gridMask);

%% Write Output Data

output = output(~isempty(output));
cd ~/Repositories/MOGADOR/rslt
save(['simResults_',datestr(now,30),'.mat'],'o');

end

