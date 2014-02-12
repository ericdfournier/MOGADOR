function [ outputPop ] = multiPartConvexWalkFnc(   popSize,...
                                                    sourceIndex,...
                                                    destinIndex,...
                                                    objectiveVars,...
                                                    objectiveFrac,...
                                                    minClusterSize,...
                                                    gridMask )
%
% multiPartConvexWalk.m 
%
% DESCRIPTION:
%
%   Function to...
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputPop ] =     initPopFnc(     popSize, sourceIndex,...
%                                       destinIndex,objectiveVars,...
%                                       objectiveFrac, minClusterSize,...
%                                       gridMask )
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
%
%   gridMask =          [n x m] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zeros
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

p = inputParser;

addRequired(p,'nargin',@(x)...
    x == 7);
addRequired(p,'nargout',@(x)...
    x == 1);
addRequired(p,'popSize',@(x)...
    isnumeric(x) &&...
    isscalar(x)...
    && rem(x,1) == 0 &&...
    x > 0 &&...
    ~isempty(x));
addRequired(p,'sourceIndex',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x) &&...
    rem(x(1,1),1) == 0 &&...
    rem(x(1,2),1) == 0);
addRequired(p,'destinIndex',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x)...
    && rem(x(1,1),1) == 0 &&...
    rem(x(1,2),1) == 0);
addRequired(p,'objectiveVars',@(x)...
    isnumeric(x) &&...
    numel(size(x)) >= 2 &&...
    ~isempty(x));
addRequired(p,'objectiveFrac',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    rem(x,1) ~= 0 &&...
    x <= 1 && x >= 0 &&...
    ~isempty(x));
addRequired(p,'minClusterSize',@(x)...
    isnumeric(x) &&...
    isscalar(x)...
    && rem(x,1) == 0 &&...
    x > 0 &&...
    ~isempty(x));
addRequired(p,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(p,nargin,nargout,popSize,sourceIndex,destinIndex,objectiveVars,...
    objectiveFrac,minClusterSize,gridMask);

%% Function Parameters

pS = popSize;
gS = size(gridMask);
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);
outputPop = zeros(pS,gL);
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
sourceDistMask = bwdist(sourceMask);

%% Generate Walks from Base Points Selected Using Distance Band Masks

basePointLimit = floor(sqrt(gS(1,1)*gS(1,2)));
w = waitbar(0,'Generating Walks');

for i = 1:pS
    
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
            
            disp(['Restarting Walk: No Elligible Cluster Centroids',...
                ' Found from Current Base Point']);
            
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
    
    individual = basePoints2WalkFnc(basePoints,gridMask);
    sizeIndiv = size(individual,2);
    outputPop(i,1:sizeIndiv) = individual;
    
    % Display Function Progress

    perc = i/pS;
    waitbar(perc,w,[num2str(perc*100),'% Completed...']);

end

close(w);

end
