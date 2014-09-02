function [ outputPopCell ] = mogadorFnc(    inputPopCell, ...
                                            sourceIndex, ...
                                            destinIndex, ...
                                            populationSize, ...
                                            maximumGenerations, ...
                                            selectionFraction, ...
                                            selectionProbability, ...
                                            crossoverType, ...
                                            mutationFraction, ...
                                            mutationCount, ...
                                            randomness, ...
                                            objectiveVariables, ...
                                            gridMask )
% mogadorFnc.m Function Function to initiate the sequential evolutionary
% operators which engage the search for a set of optimal corridors through
% a given search domain (gridMask) with respect to some other given set of
% continuously defined objective variables.
%
%
% DESCRIPTION:
%
%   Function to return a non-inferior set of connected corridors through a
%   given search domain subject to a continuous set of one or more
%   objective variables. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ ouputPopCell ] =  mogadorFnc(    inputPopCell, ...
%                                      sourceIndex, ...
%                                      destinIndex, ...
%                                      populationSize, ...
%                                      maximumGenerations, ...
%                                      selectionFraction, ...
%                                      selectionProbability, ...
%                                      crossoverType, ...
%                                      mutationFraction, ...
%                                      mutationCount, ...
%                                      randomness, ...
%                                      objectiveVariables, ...
%                                      gridMask )
%
% INPUTS:
%
%   inputPop =          [b x 3] array where each row represents a set of
%                       index values listing the connected grid cells 
%                       forming a pathway from a specified source to a 
%                       specified target destination given the constraints
%                       of a specified study region
%
%   sourceIndex =       [1 x 2] array with the subscript indices of the
%                       source location within the study area for which the 
%                       paths are to be evaluated
%
%   destinIndex =       [1 x 2] array with the subscript indices of the
%                       destination location within the study area for 
%                       which the paths are to be evaluated
%
%   populationSize =    [p] scalar with the desired number of individuals
%                       contained within the seed population. If the input
%                       argument popSize is empty ([]) then the default
%                       population size will be computed as 10 times the
%                       genome length (which is itself based upon the
%                       dimensions of the gridMask)
%
%   maximumGenerations = [b] scalar value indicating the maximum number of
%                       generations for the output pop cell structure array 
%                       (note: must match the maximum number of generations
%                       for the input pop structure array).
%
%   objectiveFraction = [s] scalar value indicating the fraction of the
%                       aggregated objective score values for which 
%                       clusters will be evaluated
%
%   selectionFraction = [v] scalar value ranging from 0 to 1, indicating
%                       the fraction of the total number of individuals 
%                       within the population that will be selected to 
%                       participate in crossover and the production of
%                       the next generation of individuals
%
%   selectionProbability = [t] scalar value ranging from 0 to 1, indicating 
%                       the probability that an individual will be selected
%                       if it is determined to be more fit than its 
%                       tournament opponent during each phase of the 
%                       tournament
%
%   crossoverType =     [ 0 | 1 ] binary scalar in which specifies one of 
%                       two possible cases:
%                           Case 0: Single Point Crossover
%                           Case 1: Double Point Crossover
%   mutationFraction =  [a] scalar indicating the fraction (ranging from 0 
%                       to 1) of the input that will be subject to the 
%                       mutation process 
%   
%   mutationCount =     [z] scalar indicating the number of multi-point
%                       mutations to be processed for each individual within 
%                       the input population
%
%   randomness =        [k] a value > 0 indicating the degree of randomness
%                       to be applied in the process of generating the 
%                       walk. Specifically, this value corresponds to  the
%                       degree of the root that is used to compute the 
%                       covariance from the minimum basis distance at each
%                       movement iteration along the path. Higher numbers 
%                       equate to less random paths.
%
%   objectiveVarsiables = [m x n x g] array in which the first two dimensions
%                       [n x m] correspond to the two spatial dimensions of
%                       the gridMask and in which the third dimension [g]
%                       corresponds to the index number of the objective
%                       variable
%
%   gridMask =          [n x m] binary array where grid cells with a value
%                       of 1 correspond to locations that are within the
%                       search domain and grid cells with values of 0
%                       correpsond to locations that are excluded from the
%                       search domain
% OUTPUTS:
%   
%   outputPopCell =     {q x 3} cell array containing all of the population
%                       arrays and their respective fitness and average
%                       fitness values
%                       
%
% EXAMPLES:
%   
%   Example 1 =
%
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
%% Function Parameters

i = 1;

%% Execute MOGADOR

convergence = 0;
% convergenceRate = 0;

disp('**Initiating Evolutionary Process**'); 

while convergence == 0
    
    currentPopulation = inputPopCell{i,1};
    averageFitnessHistory = [inputPopCell{1:i,3}];
        
    if i <= 2
        
%         convergenceRate = 0;
        convergence = 0;
        
    elseif i == maximumGenerations
        
        break;
    
    else
        
%         convergenceAbsolute = fix(diff(averageFitnessHistory,1));
        convergenceRate = fix(diff(averageFitnessHistory,2));
        convergence = convergenceRate(i-2) <= 1E-10 ;
        
    end

    selection = popSelectionFnc(...
        currentPopulation,...
        selectionFraction,...
        selectionProbability,...
        objectiveVariables,...
        gridMask          );
    
    disp(size(selection));
    disp(populationSize);
    disp(sourceIndex);
    disp(destinIndex);
    disp(crossoverType);
    disp(size(gridMask));
    
    crossover = popCrossoverFnc(...
        selection,...
        populationSize,...
        sourceIndex,...
        destinIndex,...
        crossoverType,...
        gridMask          );

    mutation = popMutationFnc(...
        crossover,...
        mutationFraction,...
        mutationCount,...
        randomness,...
        gridMask          );
    
    fitness = popFitnessFnc(...
        mutation,...
        objectiveVariables,...
        gridMask          );
    
    avgfitness = popAvgFitnessFnc(...
        mutation,...
        objectiveVariables,...
        gridMask          );
    
    inputPopCell{i+1,1} = mutation;
    inputPopCell{i+1,2} = fitness;
    inputPopCell{i+1,3} = avgfitness;
    
    disp(['*Generation: ',num2str(i),'*']);
   
    i = i+1;
        
end

disp('**Evolutionary Process Completed**');

%% Write Outputs

outputPopCell = inputPopCell;

end