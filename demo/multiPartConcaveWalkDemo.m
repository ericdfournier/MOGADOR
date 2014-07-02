function [ outputWalk ] = multiPartConcaveWalkDemo( sourceIndex,...
                                                    destinIndex,...
                                                    objectiveVars,...
                                                    objectiveFrac,...
                                                    minClusterSize,...
                                                    walkType,...
                                                    sourceConvexMask,...
                                                    gridMask )
%
% multiPartConcaveWalkDemo.m Creates a single walk for a search
% domain that is sufficiently large that multiple pseudorandom walk
% sections are necessary and for which the relationship between the source
% index the destination index causes the problem to be concave
%
% DESCRIPTION:
%
%   Function that creates a population of walks within a large search
%   domain that is concave with respect to the relative position of the
%   source and the destination locations.
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputWalk ] =     multiPartConcaveWalkDemo(  sourceIndex,...
%                                                   destinIndex,...
%                                                   objectiveVars,...
%                                                   objectiveFrac,...
%                                                   minClusterSize,...
%                                                   walkType,...
%                                                   sourceConvexAreaMask,...
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
%   sourceConvexMask =  [n x m] binary array with the valid convex area
%                       relative to the source cell 
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
    x >= 0);
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
    isscalar(x) && ...
    rem(x,1) == 0 &&...
    x > 0 &&...
    ~isempty(x));
addRequired(P,'walkType',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'sourceConvexMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,sourceIndex,destinIndex,objectiveVars,...
    objectiveFrac,minClusterSize,walkType,sourceConvexMask,gridMask);

%% Function Parameters

gS = size(gridMask);
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);
outputWalk = zeros(1,gL);
bandWidth = fix(gL/10);

%% Generate Top Centroids Mask

[topCentroidsMask, topCentroidsCount] = topCentroidsMaskFnc(...
    objectiveVars,...
    objectiveFrac,...
    minClusterSize,...
    gridMask);

%% Throw warning based on top centroid count

if topCentroidsCount <= 0.01*numel(gridMask == 1)
    
    warning(['Top centroid count less than 1% of total search domain ',...
        'for input objectiveVars, consider reducing minimumClusterSize']);

elseif topCentroidsCount >= 0.5*numel(gridMask == 1)
    
    warning(['Top centroid count greater than 50% of total search ',...
        'domain for input objectiveVars, consider increasing ',...
        'minimumClusterSize']);
    
end

%% Generate Walks from Base Points Selected Using Distance Band Masks

basePointLimit = floor(sqrt(gS(1,1)*gS(1,2)));
basePointCount = 0;
basePointCheck = 0;
basePoints = zeros(basePointLimit,2);
basePoints(1,:) = sourceIndex;
visitedAreaMask = ones(gS);

%% Initiate While Loop

while basePointCheck == 0
    
    % Check that the current number of base points is below the maximum
    
    basePointCount = basePointCount+1;
    
    if basePointCount == basePointLimit
        
        error(['Process Terminated: Unable to Reach Target',...
            ' Destination due to Extreme Concavity of the',...
            ' Search Domain']);
        
    end
    
    currentBasePoint = basePoints(basePointCount,:);
    currentBasePointMask = zeros(gS);
    currentBasePointMask(currentBasePoint(1,1),...
        currentBasePoint(1,2)) = 1;
    currentBasePointDistMask = bwdist(currentBasePointMask);
    maxSourceDist = max(max(currentBasePointDistMask));
    testDistLimMax = bandWidth;
    
    if testDistLimMax > maxSourceDist
        
        currentDistBandLim = [0 maxSourceDist];
        
    else
        
        currentDistBandLim = [0 testDistLimMax];
        
    end
    
    currentDistBandMask = ...
        double(currentBasePointDistMask > currentDistBandLim(1,1) &...
        currentBasePointDistMask <= currentDistBandLim(1,2));
    
    % Compute Convex Area within Current Distance Band
    
    if basePointCount == 1
        
        convexAreaMask = sourceConvexMask;
        
    else
        
        convexAreaMask = convexAreaMaskFnc(currentBasePoint,...
            gridMask);
        
    end
    
    % Generate Current Area
    
    currentAreaRaw = currentDistBandMask .* gridMask .* ...
        convexAreaMask .* visitedAreaMask;
    
    % Clean Current Area
    
    currentAreaConn = bwconncomp(currentAreaRaw);
    currentAreaProps = regionprops(currentAreaConn);
    [~, Ind] = sort([currentAreaProps.Area],'descend');
    
    if isempty(Ind) == 1
        
        basePointCount = 0;
        basePoints = zeros(basePointLimit,2);
        basePoints(1,:) = sourceIndex;
        visitedAreaMask = ones(gS);
        
        continue
        
    end
    
    currentAreaMask = zeros(gS);
    currentAreaMask(currentAreaConn.PixelIdxList{1,Ind(1,1)}) = 1;
    
    % Stop Base Point Search if Destination is within Current Area
    
    containsDestin = ...
        currentAreaMask(destinIndex(1,1),destinIndex(1,2));
    
    if containsDestin == 1
        
        break
        
    end
    
    % Locate Elligible Centroids within current Area
    
    eCentroidDistMask = topCentroidsMask .* currentAreaMask .* ...
        currentBasePointDistMask;
    [eCentroidRows, eCentroidCols, eCentroidVals] =...
        find(eCentroidDistMask);
    seCentroids = ...
        flipud(...
        sortrows([eCentroidRows eCentroidCols eCentroidVals],3));
    eCentroidCount = size(eCentroidRows,1);
    
    % Perform distance weighted selection of elligible centroids
    
    if isempty(seCentroids) == 1
        
        basePointCount = 0;
        basePoints = zeros(basePointLimit,2);
        basePoints(1,:) = sourceIndex;
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
    
    % Generate stepwise visualization
   
    tmpMaskCA = currentAreaMask;
    tmpMaskVA = visitedAreaMask;
    
    tmpIndexBP = sub2ind(gS,basePoints(any(basePoints,2),1),...
        basePoints(any(basePoints,2),2));
    tmpMaskCA(tmpIndexBP) = 3;
        
    tmpMaskCA(sourceIndex(1,1),sourceIndex(1,2)) = 2;
    tmpMaskCA(destinIndex(1,1),destinIndex(1,2)) = 4;
    
    tmpIndividual = basePoints2WalkFnc(basePoints(any(basePoints,2),:),...
        1,gridMask);
    
    subplot(2,2,1);
    imagesc(gridMask);
    axis square;
    
    subplot(2,2,2);
    imagesc(tmpMaskCA);
    axis square;
    
    subplot(2,2,3);
    imagesc(tmpMaskVA);
    axis square;
    
    subplot(2,2,4);
    individualPlot(tmpIndividual,gridMask);
    axis square;
    
    waitforbuttonpress;
    
end

basePoints(basePointCount+1,:) = destinIndex;
basePoints = basePoints(any(basePoints,2),:);

% Generate and Concatenate Path Sections Between Base Points

individual = basePoints2WalkFnc(basePoints,walkType,gridMask);
sizeIndiv = size(individual,2);
outputWalk(1,1:sizeIndiv) = individual;

end