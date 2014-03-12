function [ output ] = epigeneticSmoothingFnc(   individual,...
                                                objectiveVars,...
                                                gridMask )
% epigeneticSmoothingFnc performs epigenetic smoothing to an input
% individual from a final stage population. This smoothing procedure
% involves an iterative neighborhood search procedure which operates along
% the length of the input individual. 
%
% DESCRIPTION:
%
%   Function to randomly selects valid crossover sites for the production
%   of a new child pathway from a set of two previously selected parent 
%   pathways.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ output ] =  epigeneticSmoothingFnc( individual, gridMask,...
%                                           objectiveVars )
%
% INPUTS:
%
%   individual =    [1 x m] array of grid cell indices corresponding to a
%                   connected pathway linking some source to some
%                   destination within the search domain specified in the
%                   binary input gridMask
%
%   gridMask =      [q x s] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
%   objectiveVars = [q x s x k] three dimensional array in which the first
%                   two dimensions correspond to the spatial dimensions 
%                   depicted in the gridMask search domain input and the
%                   values in the third dimension correspond to the scores
%                   for one or more objective variables used in the
%                   analysis
%
% OUTPUTS:
%
%   individual =    [1 x m] array containing the index values of the 
%                   childPathways produced as a result of the signle point 
%                   epigenetic smoothing procedure
%   
% EXAMPLES:
%   
%   Example 1 =
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
    x == 3);
addRequired(P,'individual',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'objectiveVars',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    numel(size(x)) == 3 &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,individual,objectiveVars,gridMask);

%% Function Parameters

gL = size(individual,2);
output = zeros(1,gL);

indiv = individual(any(individual,1));
pL = numel(indiv);
nC = 100;

if pL <= nC
    
    error('Inputs Individuals must be at least 100 nodes in length');

end

nodes = floor(linspace(1,pL,nC));

%% Initiate Smoothing Process

end

