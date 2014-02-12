function [ plotHandle ] = popSearchDomainPlot( inputPop, sourceIndex,...
                            destinIndex, gridMask )
% popSearchDomainPlot.m Function to provide a high level visual overview of
% the range of grid cells visited by the set of the individuals contained
% within a given population. 
%
% DESCRIPTION:
%
%   The number of times each grid cell is visited by all of the individuals
%   within the input population is counted, recorded, and ploted, as a
%   scaled color image in which forbidden cells are given the value of
%   zero, allowed but unvisited cells are given the value of one, and all
%   other allowed and visited cells are given a value commensurate with the
%   number of times they have been visited by the individuals within the
%   population. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] = popSearchDomainPlot( inputPop, sourceIndex,...
%                                           destinIndex, gridMask );
%
% INPUTS:
%
%   inputPop =      [p x r] array in which each row [p] corresponds to an
%                   individual within the population and each column [r] 
%                   corresponds to the sequential index numbers of the grid
%                   cells visited by each individual.
%
%   sourceIndex =   [1 x 2] array with the row and column subscript indices
%                   of the source grid cell for each individual in the
%                   input population.
%
%   destinIndex =   [1 x 2] array with the row and column subscript indices
%                   of the destination grid cell for each individual in the
%                   input population.
%
%   gridMask =      [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   with zeros as placeholders
%
% OUTPUTS:
%
%   plotHandle =    A plot handle object is generate for the output
%                   population search domain plot produced by the function. 
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
%%%               University of California Santa Barbara                 %%
%%%                            September 2013                            %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x) x == 4);
addRequired(p,'inputPop',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,inputPop,gridMask);

%% Iteration Parameters

gS = size(gridMask);
pS = size(inputPop,1);

%% Find Unique Points

visited = zeros(gS);

for i = 1:pS
    individual = inputPop(i,:);
    individual = individual(any(individual,1))';
    visits = visited(individual);
    visited(individual) = visits+1;
end

visited(sourceIndex(1,1),sourceIndex(1,2)) = 0;
visited(destinIndex(1,1),destinIndex(1,2)) = 0;

%% Generate Plot

plotHandle = imagesc(visited);

end