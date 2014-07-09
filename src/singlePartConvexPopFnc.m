function [ outputPop ] = singlePartConvexPopFnc(    popSize,...
                                                    sourceIndex,...
                                                    destinIndex,...
                                                    randomness,...
                                                    executionType,...
                                                    gridMask )                                                 
%
% singlePartConvexPopFnc.m Initializes the creation of a population where
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
%   [ outputPop ] =  singlePartConvexWalkFnc(   popSize, ...
%                                               sourceIndex,...
%                                               destinIndex,...
%                                               executionType,...
%                                               randomness,...
%                                               gridMask );
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
%   randomness =        [h] a value > 0 indicating the degree of randomness
%                       to be applied in the process of generating the 
%                       walk. Specifically, this value corresponds to  the 
%                       degree of the root that is used to compute the 
%                       covariance from the minimum basis distance at each 
%                       movement iteration along the path. Higher numbers 
%                       equate to less random paths.
%
%   executionType =     [0 | 1] binary scalar value indicating whether the
%                       process should be run in serial or in parallel on 
%                       the host CPU. 
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
    x == 6);
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
addRequired(P,'randomness',@(x)...
    isnumeric(x) &&...
    ~isempty(x));
addRequired(P,'executionType',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,popSize,sourceIndex,destinIndex,randomness,...
    executionType,gridMask);

%% Function Parameters

pS = popSize;
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);
eT = executionType;
outputPop = zeros(pS,gL);

%% Switch Case

switch eT
    
    case 0  % Serial execution
        
        for i = 1:pS
        
            outputPop(i,:) = pseudoRandomWalkFnc(sourceIndex,...
                destinIndex,randomness,gridMask);
            
        end
    
    case 1

        parfor i = 1:pS
            
            outputPop(i,:) = pseudoRandomWalkFnc(sourceIndex,...
                destinIndex,randomness,gridMask);
            
        end

end

end