function [ fitnessSum, fitnessRaw ] = fitnessFnc( individual,...
                                        objectiveVars )

% fitnessFnc.m This function computes the different components of the
% multi-objective function used to evaluate different proposed pathways
% between the source and destination locations
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
%   [ fitnessSum, fitnessRaw ] =  fitnessFnc( individual, objectiveVars )
%
% INPUTS:
%
%   individual =    [1 x m] logical array indicating the locations of the
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
%   fitnessSum =    [r x 1] array in which each row value corresponds to
%                   the sum total fitness score computed for each of the 
%                   objectives upon which fitness is being evaluated
%
%   fitnessRaw =    [r x m] array in which each row corresponds to the
%                   individual fitness scores computed for each of the 
%                   index locations referenced in the 'individual' input 
%                   pathway
%
% EXAMPLES:
%   
%   Example 1:
%                   % Build Example Dataset
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
%                   individual = pseudoRandomWalkFnc(gridMask,iterations,...
%                                   sigma,sourceIndex,destinIndex,plot);
%                   objective1 = randi([0 10],10000,1);
%                   objective2 = randi([0 10],10000,1);
%                   objective3 = randi([0 10],10000,1);
%                   objectiveVars = horzcat(objective1, objective2,...
%                                       objective3);
%                   
%                   % Execute 'individualFitnessFnc'
%
%                   [fitnessSum, fitnessRaw] = fitnessFnc(individual,...
%                                                   objectiveVars);
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

addRequired(p,'nargin',@(x) x == 2);
addRequired(p,'individual',@(x) isnumeric(x) && ismatrix(x) && ...
    ~isempty(x));
addRequired(p,'objectiveVars',@(x) isnumeric(x) && ismatrix(x) && ...
    ~isempty(x));

parse(p,nargin,individual,objectiveVars);

%% Iteration Parameters

gL = size(individual,2);
oC = size(objectiveVars,2);
fitnessSum = zeros(oC,1);
fitnessRaw = zeros(oC,gL);

%% Compute Scores

indiv = individual(any(individual,1));
indivObj = objectiveVars(indiv,:)';
sizeIO = size(indivObj,2);
fitnessRaw(:,1:sizeIO) = indivObj;
fitnessSum(:,1) = sum(objectiveVars(indiv,:));

end