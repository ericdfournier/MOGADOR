function [ outputPop ] = singlePartConvexWalkFnc(   popSize,...
                                                    sourceIndex,...
                                                    destinIndex,...
                                                    gridMask )                                                 
%
% singlePartConvexWalkFnc.m Initializes the creation of a population where
% the search domain is sufficiently small that each walk has only a single
% part and also, the relationship between the source and the destination
% within the search domain indicates that a euclidean shortest path 
% basis solution is convex
%
% DESCRIPTION:
%
%   Function that initializes a set of walk pathways of desired size for a
%   solution space that is both small and convex with respect to the
%   orientation between the source index and the destination index
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputPop ] =  singlePartConvexWalkFnc( popSize, sourceIndex,...
%                       destinIndex, gridMask );
%
% INPUTS:
%
%   popSize =           [q] scalar with the desired number of individuals
%                       contained within the seed population. If the input
%                       argument popSize is empty ([]) then the default
%                       population size will be computed as 10 times the
%                       genome length (which is itself based upon the
%                       dimensions of the gridMask)
%
%   sourceIndex =       [1 x 2] array with the subscript indices of the
%                       source location within the study area for which the 
%                       paths are to be evaluated
%
%   destinIndex =       [1 x 2] array with the subscript indices of the
%                       destination location within the study area for 
%                       which the paths are to be evaluated
%
%   gridMask =          [n x m] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zeros
%
% OUTPUTS:
%
%   outputPop =        [j x k] double array containing the grid index 
%                       values of the individuals within the population 
%                       (Note: each individual corresponds to a connected 
%                       pathway from the source to the destination grid 
%                       cells within the study area)
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
    x == 4);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'popSize',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    rem(x,1) == 0 &&...
    x > 0 &&...
    ~isempty(x));
addRequired(P,'sourceIndex',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x) &&...
    rem(x(1,1),1) == 0 &&...
    rem(x(1,2),1) == 0);
addRequired(P,'destinIndex',@(x)...
    isnumeric(x) &&...
    isrow(x) && ~isempty(x)...
    && rem(x(1,1),1) == 0 &&...
    rem(x(1,2),1) == 0);
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,popSize,sourceIndex,destinIndex,gridMask);

%% Function Parameters

pS = popSize;
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);
outputPop = zeros(pS,gL);

%% Generate Output

parfor i = 1:pS
    
    outputPop(i,:) = pseudoRandomWalkFnc(sourceIndex,destinIndex,...
        gridMask);
    
end

end