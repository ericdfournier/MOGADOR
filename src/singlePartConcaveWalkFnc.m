function [ outputWalk ] = singlePartConcaveWalkFnc( sourceIndex,...
                                                    destinIndex,...
                                                    objectiveVars,...
                                                    objectiveFrac,...
                                                    minClusterSize,...
                                                    walkType,...
                                                    sourceConvexMask,...
                                                    randomness,...
                                                    gridMask )
%
% singlePartConcaveWalkFnc.m Creates a population of walks for a search
% domain that is sufficiently small that only a single part is neccessary
% but for which the relationship between the source index and the
% destination index causes the problem to be concave
%
% DESCRIPTION:
%
%   Function that creates a population of walks within a small search
%   domain that is concave with respect to the relative position of the
%   source and the destination locations.
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputWalk ] =     singlePartConcaveWalkFnc(  sourceIndex,...
%                                                   destinIndex,...
%                                                   objectiveVars,...
%                                                   objectiveFrac,...
%                                                   minClusterSize,...
%                                                   walkType,...
%                                                   sourceConvexMask,...
%                                                   randomness,...
%                                                   gridMask );
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
%   sourceIndex =       [1 x 2] array with the subscript indices of the
%                       source location within the study area for which the 
%                       paths are to be evaluated
%
%   destinIndex =       [1 x 2] array with the subscript indices of the
%                       destination location within the study area for 
%                       which the paths are to be evaluated
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
%   sourceConvexMask =  [n x m] binary array indicating the grid cells that
%                       are convex to the initial source index location
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
%   outputWalk =        [j x k] double array containing the grid index 
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
    x == 9);
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
    ~isempty(x)...
    && rem(x(1,1),1) == 0 &&...
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
    isscalar(x)...
    && rem(x,1) == 0 &&...
    x > 0 &&...
    ~isempty(x));
addRequired(P,'walkType',@(x)...
    isnumeric(x) &&...
    isscalar(x)...
    && ~isempty(x));
addRequired(P,'sourceConvexMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'randomness',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,sourceIndex,destinIndex,objectiveVars,...
    objectiveFrac,minClusterSize,walkType,sourceConvexMask,randomness,...
    gridMask);

%% Function Parameters

gS = size(gridMask);
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);
outputWalk = zeros(1,gL);

%% Generate Top Centroids Mask

[topCentroidsMask, topCentroidsCount] = topCentroidsMaskFnc(...
    objectiveVars,...
    objectiveFrac,...
    minClusterSize,...
    gridMask);

% Throw warning based on top centroid count

if topCentroidsCount <= 0.01*numel(gridMask == 1)
    
    warning(['Top centroid count less than 1% of total search domain ',...
        'for input objectiveVars, consider increasing ',...
        'objectiveFraction or decreasing the minClusterSize']);

elseif topCentroidsCount >= 0.5*numel(gridMask == 1)
    
    warning(['Top centroid count greater than 50% of total search ',...
        'domain for input objectiveVars, consider decreasing ',...
        'objectiveFraction or increasing the minClusterSize']);
    
end

%% Generate Walks from Base Points Selected Using Convex Area Masks

basePointLimit = floor(sqrt(gS(1,1)*gS(1,2))); 
basePointCount = 0;
basePointCheck = 0;
basePoints = zeros(basePointLimit,2);
basePoints(1,:) = sourceIndex;
visitedAreaMask = ones(gS);

while basePointCheck == 0
    
    % Check that the current number of base points is below the maximum
    
    basePointCount = basePointCount+1;
    
    if basePointCount == basePointLimit
        
        error(['Process Terminated: Unable to Reach Target',...
            ' Destination due to Extreme Concavity of the',...
            ' Search Domain']);
        
    end
    
    currentBasePoint = basePoints(basePointCount,:);
    
    if basePointCount == 1
        
        convexAreaMask = sourceConvexMask;
        
    else
        
        convexAreaMask = convexAreaMaskFnc(currentBasePoint,gridMask);
        
    end
    
    currentAreaRaw = convexAreaMask .* visitedAreaMask;
    
    % Clean Current Area
    
    currentAreaConn = bwconncomp(currentAreaRaw);
    currentAreaProps = regionprops(currentAreaConn);
    [~, Ind] = sort([currentAreaProps.Area],'descend');
    
    if isempty(Ind) == 1
        
        basePointCount = 1;
        visitedAreaMask = ones(gS);
        
        continue
        
    end
    
    currentAreaMask = zeros(gS);
    currentAreaMask(currentAreaConn.PixelIdxList{1,Ind(1,1)}) = 1;
    
    % Stop Base Point Search if Destination is within Current Area
    
    containsDestin = ...
        currentAreaMask(destinIndex(1,1),destinIndex(1,2)) == 1;
    
    if containsDestin == 1
        
        break;
        
    end
    
    % Sort Elligible Top Centroids by Distance from Current Source
    
    sourceMask = zeros(gS);
    sourceMask(currentBasePoint(1,1),currentBasePoint(1,2)) = 1;
    sourceDistMask = bwdist(sourceMask);
    
    % Locate elligible centroids within current area mask
    
    eCentroidDistMask = sourceDistMask .* gridMask .*...
        topCentroidsMask .* currentAreaMask;
    [eCentroidRows, eCentroidCols, eCentroidVals] =...
        find(eCentroidDistMask);
    seCentroids = ...
        flipud(...
        sortrows([eCentroidRows eCentroidCols eCentroidVals],3));
    eCentroidCount = size(eCentroidRows,1);
    
    if eCentroidCount == 0
        
        basePointCount = 1;
        visitedAreaMask = ones(gS);
        
        continue
        
    elseif eCentroidCount == 1
        
        selection = 1;
        
    elseif eCentroidCount > 1
        
        sC = size(seCentroids,1);
        selection = datasample(1:sC,1);
        
    end
    
    nextBasePoint = seCentroids(selection,1:2);
    basePoints(basePointCount+1,:) = nextBasePoint;
    visitedAreaMask(logical(currentAreaMask)) = 0;
    
end

basePoints(basePointCount+1,:) = destinIndex;
basePoints = basePoints(any(basePoints,2),:);

% Generate and Concatenate Path Sections Between Base Points

individual = basePoints2WalkFnc(basePoints,walkType,randomness,gridMask);
sizeIndiv = size(individual,2);
outputWalk(1,1:sizeIndiv) = individual;

end