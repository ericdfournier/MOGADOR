function [ popAvgFitness ] = popAvgFitnessFnc(      inputPop,...
                                                    objectiveVars,...
                                                    gridMask)
%
% popAvgFitnessFnc.m Function computes the different components 
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
%   popAvgFitness = scalar value indicating the average fitness for the
%                   entire population across all individuals and all 
%                   objective variables
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

%% Compute Average Fitness Across Individuals and Objectives

popAvgFitness = mean(mean(inputPop,2),1);

end