function [ popFitness ] =  popFitnessFnc( inputPop, objectiveVars,...
                                            gridMask )
                                            
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
%   popFitness =  popFitnessFnc( inputPop, objectiveVars, gridMask )
%
% INPUTS:
%
%   inputPop =      [j x k] logical array indicating the locations of the
%                   grid cells (m) positioned along each of the 
%                   individually proposed candidate pathways (n)
%
%   objectiveVars = [n x m x g] array in which each column corresponds to a
%                   decision variable (s) and in which each row corresponds 
%                   to a spatially referenced grid cell value (covering the
%                   entire search domain)
%
%   gridMask =      [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells 
%                   labeled as NaN placeholders
%
% OUTPUTS:
%
%   popFitness =    [j x g] array in which each row corresponds to the
%                   objective specific fitness score sums for each 
%                   individual in the population
%
% EXAMPLES:
%   
%   Example 1:
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

addRequired(p,'nargin', @(x) x == 3);
addRequired(p,'inputPop',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));
addRequired(p,'objectiveVars',@(x) isnumeric(x) && numel(size(x)) >= 2 ...
    && ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,inputPop,objectiveVars,gridMask);

%% Iteration Parameters

pS = size(inputPop);
oC=  size(objectiveVars,3);
popFitness = zeros(pS(1,1),oC);

%% Compute Fitness

for i = 1:pS(1,1);
    individual = inputPop(i,:);
    fitness = fitnessFnc(individual,objectiveVars,gridMask);
    popFitness(i,:) = fitness;
end

end