function [ initialScores ] = initScoresFnc( inputPop, objectiveVars )

% initScoresFnc.m This function computes the objective scores for the
% initial population of individuals used to seed the genetic algorithm
% global optimization procedure. 
%
% DESCRIPTION:
%
%   Function to generate the initial multi-criteria objective function
%   scores for each individual in the seed population.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ initialScores ] = initScoresFnc( inputPop, objectiveVars )
%
% INPUTS:
%
%   inputPop =      [n x m] array with the genotype for each individual (n)
%                   in the seed population
%
%   objectiveVars = [r x s] array in which each column corresponds to a
%                   decision variable (s) and in which each row corresponds 
%                   to a spatially referenced grid cell value (covering the
%                   entire search domain)
%
% OUTPUTS:
%
%   initialScores = [n x r] array with the objective function scores
%                   describing the fitness of each individual in the 
%                   seed population where (r) corresponds to the total
%                   number of input variables against which fitness is to
%                   be evaluated
%
% EXAMPLES:
%
%   Example 1 =
%
%                   % Pass 'initialPop' from output arguments of
%                   'initPopFnc'
%
%                   var1 = randi(100,[1000,1]);
%                   var2 = randi(100,[1000,1]);
%                   var3 = randi(100,[1000,1]);
%                   objectiveVars = horzcat(var1,var2,var3);
%
%                   initialScores = initScoresFnc(inputPop,objectiveVars);
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
addRequired(p,'inputPop',@(x) isnumeric(x) && ismatrix(x) &&...
    ~isempty(x));
addRequired(p,'objectiveVars',@(x) isnumeric(x) && ismatrix(x) &&...
    ~isempty(x));

parse(p,nargin,inputPop,objectiveVars);

%% Generate Initial Scores

initialScores = fitnessFnc(inputPop, objectiveVars);

end