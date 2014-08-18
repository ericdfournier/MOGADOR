function [ outputWalk ] = multiPartConvexWalkFnc(   sourceIndex,...
                                                    destinIndex,...
                                                    objectiveVars,...
                                                    objectiveFrac,...
                                                    minClusterSize,...
                                                    walkType,...
                                                    randomness,...
                                                    gridMask )
% multiPartConvexWalkFnc.m Generates a multi-part walk for an input search
% domain that is convex with respect to the relative positions of the
% source location and the destination location.  
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
%   [ outputWalk ] =     multiPartConvexWalkFnc(    sourceIndex,...
%                                                   destinIndex,...
%                                                   objectiveVars,...
%                                                   objectiveFrac,...
%                                                   minClusterSize,...
%                                                   walkType,...
%                                                   randomness,...
%                                                   gridMask )
%
% INPUTS:
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
%   walkType =          [0 | 1 | 2] decision variable indicating whether or not
%                       the path sections are to be constructed of
%                       pseudoRandomWalks, euclideanShortestWalks, or a
%                       random mixture of the two.
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
%   gridMask =          [n x m] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zeros
%
% OUTPUTS:
%
%   outputWalk =        [1 x k] double array containing the grid index 
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
    x == 8);
addRequired(P,'nargout',@(x)...
    x == 1);
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
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,sourceIndex,destinIndex,objectiveVars,...
    objectiveFrac,minClusterSize,walkType,randomness,gridMask);

%% Function Parameters

gS = size(gridMask);
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);
outputWalk = zeros(1,gL);
bandWidth = 142;

%% Generate Top Centroids Mask

[topCentroidsMask, topCentroidsCount] = topCentroidsMaskFnc(...
    objectiveVars,...
    objectiveFrac,...
    minClusterSize,...
    gridMask);

% Throw warning based on top centroid count

if topCentroidsCount <= 0.01*numel(gridMask == 1)
    
    warning(['Top centroid count less than 1% of total search domain ',...
        'for input objectiveVars, consider reducing minimumClusterSize']);

elseif topCentroidsCount >= 0.5*numel(gridMask == 1)
    
    warning(['Top centroid count greater than 50% of total search ',...
        'domain for input objectiveVars, consider increasing ',...
        'minimumClusterSize']);
    
end

%% Generate Source Distance Mask

sourceMask = zeros(gS);
sourceMask(sourceIndex(1,1),sourceIndex(1,2)) = 1;

%% Generate Walks from Base Points Selected Using Distance Band Masks

basePointLimit = floor(sqrt(gS(1,1)*gS(1,2)));    
basePointCount = 0;
basePointCheck = 0;
basePoints = zeros(basePointLimit,2);
basePoints(1,:) = sourceIndex;

while basePointCheck == 0
    
    % Check that the current number of base points is below the maximum
    
    basePointCount = basePointCount+1;
    
    if basePointCount == basePointLimit
        
        error(['Process Terminated: Unable to Reach Target',...
            ' Destination due to Extreme Concavity of the',...
            ' Search Domain']);
        
    end
    
    % Check if final destination is contained in convex area mask
    
    currentBasePoint = basePoints(basePointCount,:);
    currentBasePointDist = sourceDistMask(currentBasePoint(1,1),...
        currentBasePoint(1,2));
    maxSourceDist = max(max(sourceDistMask));
    testDistLimMax = currentBasePointDist + bandWidth;
    
    if testDistLimMax > maxSourceDist
        
        currentDistBandLim = [currentBasePointDist maxSourceDist];
        
    else
        
        currentDistBandLim = [currentBasePointDist testDistLimMax];
        
    end
    
    currentDistBandMask = ...
        sourceDistMask > currentDistBandLim(1,1) &...
        sourceDistMask <= currentDistBandLim(1,2);
    sourceShadowMask = sourceShadowMaskFnc(...
        currentBasePoint,...
        destinIndex,...
        gridMask);
    currentAreaMask = currentDistBandMask .* sourceShadowMask;
    containsDestin = ...
        currentAreaMask(destinIndex(1,1),destinIndex(1,2)) == 1;
    
    if containsDestin == 1
        
        break;
        
    end
    
    % Sort Elligible Top Centroids by Distance from Source
    
    eCentroidDistMask = topCentroidsMask .* currentAreaMask ...
        .* gridMask;
    [eCentroidRows, eCentroidCols, eCentroidVals] =...
        find(eCentroidDistMask);
    seCentroids = ...
        flipud(...
        sortrows([eCentroidRows eCentroidCols eCentroidVals],3));
    eCentroidCount = size(eCentroidRows,1);
    
    if isempty(seCentroids) == 1
        
        break
        
    elseif eCentroidCount == 1
        
        selection = 1;
        
    elseif eCentroidCount > 1
        
        selection = randi(eCentroidCount,1);
        
    end
    
    nextBasePoint = seCentroids(selection,1:2);
    basePoints(basePointCount+1,:) = nextBasePoint;
    
end

basePoints(basePointCount+1,:) = destinIndex;
basePoints = basePoints(any(basePoints,2),:);

% Generate and Concatenate Path Sections Between Base Points

individual = basePoints2WalkFnc(basePoints,walkType,randomness,gridMask);
sizeIndiv = size(individual,2);
outputWalk(1,1:sizeIndiv) = individual;

end