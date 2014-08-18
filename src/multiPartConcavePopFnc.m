function [ outputPop ] = multiPartConcavePopFnc(    popSize,...
                                                    sourceIndex,...
                                                    destinIndex,...
                                                    objectiveVars,...
                                                    objectiveFrac,...
                                                    minClusterSize,...
                                                    walkType,...
                                                    randomness,...
                                                    executionType,...
                                                    gridMask )
% multiPartConcavePopFnc.m Generates a population of multi-part walk
% for an input search domain that is convex with respect to the relative 
% positions of the source location and the destination location.  
%
% DESCRIPTION:
%
%   Function iteratively divides the search domain into distance bands and 
%   then searches convex sub-regions to construct a path that is able to 
%   somewhat directly navigate around obstacles with the search area.
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputPop ] =     multiPartConcavePopFnc( popSize,...
%                                               sourceIndex,...
%                                               destinIndex,...
%                                               objectiveVars,...
%                                               objectiveFrac,...
%                                               minClusterSize,...
%                                               walkType,...
%                                               randomness,...
%                                               executionType,...
%                                               gridMask )
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
%   objectiveVars =     [m x n x g] array in which the first two dimensions
%                       [n x m] correspond to the two spatial dimensions of
%                       the gridMask and in which the third dimension [g]
%                       corresponds to the index number of the objective
%                       variable
%
%   objectiveFrac =     [s] scalar value indicating the fraction of the
%                       aggregated objective score values for which 
%                       clusters will be evaluated
%
%   minClusterSize =    [r] scalar value indicating the minimum number of
%                       connected cells (assuming queen's connectivity) 
%                       that are required to consititute a viable cluster
%
%   walkType =          [0 | 1 | 2] binary decision variable indicating 
%                       whether or not the path sections are to be 
%                       constructed of pseudoRandomWalks, 
%                       euclideanShortestWalks, or a random mixture of the 
%                       two.
%                           0 : All pseudoRandomWalk
%                           1 : All euclShortestWalk
%                           2 : Random mixture of pseudoRandomWalk &
%                               euclShortestWalk
%
%   randomness =        [h] a value > 0 indicating the degree of randomness
%                       to be applied in the process of generating the 
%                       walk. Specifically, this value corresponds to  the 
%                       degree of the root that is used to compute the 
%                       covariance from the minimum basis distance at each 
%                       movement iteration along the path. Higher numbers 
%                       equate to less random paths.
%
%   executionType =     [0 | 1 ] binary decision variable indicating
%                       whether or not the population generation procedure 
%                       should execute in series or in parallel. 
%                           0 : Series
%                           1 : Parallel
%
%   gridMask =          [n x m] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zeros
%
%
% OUTPUTS:
%
%   outputPop =         [j x k] double array containing the grid index 
%                       values of the individuals within the population 
%                       (Note: each individual corresponds to a connected 
%                       pathway from the source to the destination grid 
%                       cells within the study area)
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
%%%                 University of California Santa Barbara               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x)...
    x == 10);
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
    isrow(x) &&...
    ~isempty(x) &&...
    rem(x(1,1),1) == 0 &&...
    rem(x(1,2),1) == 0);
addRequired(P,'objectiveVars',@(x)...
    isnumeric(x) &&...
    numel(size(x)) >= 2 &&...
    ~isempty(x));
addRequired(P,'objectiveFrac',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    rem(x,1) ~= 0 &&...
    x <= 1 && x >= 0 &&...
    ~isempty(x));
addRequired(P,'minClusterSize',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    rem(x,1) == 0 &&...
    x > 0 &&...
    ~isempty(x));
addRequired(P,'walkType',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'randomness',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'executionType',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,popSize,sourceIndex,destinIndex,objectiveVars,...
    objectiveFrac,minClusterSize,walkType,randomness,executionType,...
    gridMask);

%% Function Parameters

pS = popSize;
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);
outputPop = zeros(pS,gL);
eT = executionType;

%% Generate Initial Source Convex Area Mask

sourceConvexMask = convexAreaMaskFnc(sourceIndex,gridMask);

%% Switch Case

switch eT
    
    case 0  % Serial execution

        for i = 1:pS
            
            outputPop(i,:) = multiPartConcaveWalkFnc(...
                sourceIndex,...
                destinIndex,...
                objectiveVars,...
                objectiveFrac,...
                minClusterSize,...
                walkType,...
                sourceConvexMask,...
                randomness,...
                gridMask);
            
            disp(i);
            
        end
        
    case 1  % Parallel execution
        
        parfor i = 1:pS
            
            outputPop(i,:) = multiPartConcaveWalkFnc(...
                sourceIndex,...
                destinIndex,...
                objectiveVars,...
                objectiveFrac,...
                minClusterSize,...
                walkType,...
                sourceConvexMask,...
                randomness,...
                gridMask);
                        
        end
        
end