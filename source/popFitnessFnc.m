function [ popFitnessSum, popFitnessVar, popFitnessRaw ] = ...
                                                popFitnessFnc(...
                                                inputPop, objectiveVars )
                                            
% popFitnessFnc.m This function computes the different components 
% of the multi-objective function used to evaluate different proposed 
% pathways between the source and destination locations
%
% DESCRIPTION:
%
%   Function to generate a seed population of individuals for a given
%   set of source and destination locations within a study domain for
%   use in a genetic algorithm based global optimization procedure. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ popFitnessSum, popFitnessRaw ] =  popFitnessFnc( inputPop, 
%                                           objectiveVars )
%
% INPUTS:
%
%   inputPop =      [n x m] logical array indicating the locations of the
%                   grid cells (m) positioned along each of the 
%                   individually proposed candidate pathways (n)
%
%   objectiveVars = [r x s] array in which each column corresponds to a
%                   decision variable (s) and in which each row corresponds 
%                   to a spatially referenced grid cell value (covering the
%                   entire search domain)
%
% OUTPUTS:
%
%   popFitnessSum = [n x 1] array in which each row contains the summed
%                   fitness values for the individual accross all of the 
%                   objectives upon which fitness is being evaluated
%
%   popFitnessVar = [n x 1] cell array in which each cell contains an 
%                   [r x 1] array where each row value corresponds to
%                   the sum total fitness score computed for each of the 
%                   objectives upon which fitness is being evaluated
%
%   popFitnessRaw = [n x 1] cell array in which each cell contains an 
%                   [1 x m] array where each row corresponds to the
%                   individual fitness scores computed for each of the 
%                   index locations referenced in the 'individual' input 
%                   pathway
%
% EXAMPLES:
%   
%   Example 1:
%   
%                   gridMask = zeros(100);
%                   gridMask(1,:) = nan;
%                   gridMask(:,1) = nan;
%                   gridMask(end,:) = nan;
%                   gridMask(:,end) = nan;
%                   sourceIndex = [20 20];
%                   destinIndex = [80 80];
%                   iterations = 1000;
%                   sigma = [10 0; 0 10];
%                   plot = 0;
%                   [initialPop, genomeLength] = initializePopFnc(popSize,
%                                                   gridMask,iterations,...
%                                                   sigma,sourceIndex,...
%                                                   destinIndex);
%                   
%                   objective1 = randi([0 10],10000,1);
%                   objective2 = randi([0 10],10000,1);
%                   objective3 = randi([0 10],10000,1);
%                   objectiveVars = horzcat(objective1, objective2,...
%                                       objective3);
%                   
%                   [popFitnessSum, popFitnessVar, popFitnessRaw] = ...
%                           popFitnessFnc(inputPop, objectiveVars);
%                   
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                            September 2013                            %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin', @(x) x == 2);
addRequired(p,'inputPop',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));
addRequired(p,'objectiveVars',@(x) isnumeric(x) && ismatrix(x) &&...
    ~isempty(x));

parse(p,nargin,inputPop,objectiveVars);

%% Iteration Parameters

n = size(inputPop);
popFitnessSum = zeros(n(1,1),1);
popFitnessVar = cell(n(1,1),1);
popFitnessRaw = cell(n(1,1),1);

%% Compute Fitness

for i = 1:n(1,1);
    individual = inputPop(i,:);
    [fitnessSum, fitnessRaw] = fitnessFnc(individual,...
        objectiveVars);
    popFitnessSum(i,1) = sum(fitnessSum);
    popFitnessVar{i,1} = fitnessSum;
    popFitnessRaw{i,1} = fitnessRaw;
end

end