function [ fitness ] = fitnessFnc( individual, objectiveVars, gridMask )

% fitnessFnc.m This function computes the different components of the
% multi-objective function used to evaluate different proposed pathways
% between the source and destination locations
%
% DESCRIPTION:
%
%   Function to generate the fitness scores for each objective at each grid
%   cell contained within an individual
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   fitness =  fitnessFnc( individual, objectiveVars )
%
% INPUTS:
%
%   individual =    [1 x k] logical array indicating the locations of the
%                   grid cells positioned along each of the 
%                   individually proposed candidate pathways
%
%   objectiveVars = [n x m x g] array in which the first two spatial
%                   dimensions correspond to the dimensions of the grid 
%                   mask and the third dimension corresponds to the various
%                   objective variables
%
% OUTPUTS:
%
%   fitness =       [r x g] array in which each row corresponds to the
%                   individual fitness scores computed for each of the 
%                   index locations referenced in the input pathway
%
% EXAMPLES:
%   
%   Example 1:
%
%                   
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                            February 2014                             %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x) x == 3);
addRequired(p,'individual',@(x) isnumeric(x) && ismatrix(x) && ...
    ~isempty(x));
addRequired(p,'objectiveVars',@(x) isnumeric(x) && numel(size(x)) >= 2 ...
    && ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ...
    ~isempty(x));

parse(p,nargin,individual,objectiveVars,gridMask);

%% Iteration Parameters

gS = size(gridMask);
oC = size(objectiveVars,3);
fitness = zeros(1,oC);

%% Compute Scores

indivMask = zeros(gS);
indivMask(individual(any(individual,1))) = 1;

for i = 1:oC
    
    fitness(:,i) = sum(sum(indivMask.*objectiveVars(:,:,i)));

end

end