function [ outputPop ] = singlePartConcaveWalkFnc(  popSize,...
                                                    sourceIndex,...
                                                    destinIndex,...
                                                    objectiveVars,...
                                                    objectiveFrac,...
                                                    minClusterSize,...
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
%   [ outputPop ] =     initPopFnc( popSize, sourceIndex, destinIndex,...
%                                       objectiveVars, objectiveFrac,...
%                                       minClusterSize, gridMask );
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

%% Generate Top Centroids Mask

[topCentroidsMask, topCentroidsCount] = topCentroidsMaskFnc(...
    objectiveVars,...
    objectiveFrac,...
    minClusterSize,...
    gridMask);

% Throw warning if insufficient candidate centroids found

if topCentroidsCount <= 10
    
    warning(['Fewer than 10 candidate base point centroids generated ',...
        'from input objectiveVars, consider reducing minimumClusterSize']);
    
end

%% Generate Walks from Base Points Selected Using Convex Area Masks

basePointLimit = floor(sqrt(gS(1,1)*gS(1,2)));

for i = 1:pS
    
    disp(['Walk ',num2str(i),' of ',num2str(pS),' Initiated']);
    
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
        
        % Check if final destination is contained in convex area mask
        
        currentBasePoint = basePoints(basePointCount,:);
        convexAreaMask = convexAreaMaskFnc(currentBasePoint,gridMask);
        currentAreaMask = convexAreaMask .* visitedAreaMask;
        containsDestin = ...
            currentAreaMask(destinIndex(1,1),destinIndex(1,2)) == 1;
        
        if containsDestin == 1
            
            break;
            
        end
        
        % Sort Elligible Top Centroids by Distance from Current Source
        
        sourceMask = zeros(gS);
        sourceMask(currentBasePoint(1,1),currentBasePoint(1,2)) = 1;
        sourceDistMask = bwdist(sourceMask);
        
        % Check to determine if there are any Elligible Centroids within
        % the Current Area Mask
        
        eCentroidDistMask = topCentroidsMask .* currentAreaMask .* ...
            gridMask .* sourceDistMask;
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
            
            sC = size(seCentroids,1);
            P = 0.1;    % This value controls the randomness...
            selection = 0;
            
            while selection == 0;
                
                selection = geornd(P);
                
                if selection >= sC
                    
                    selection = 0;
                    
                end
                
            end
            
        end
        
        nextBasePoint = seCentroids(selection,1:2);
        basePoints(basePointCount+1,:) = nextBasePoint;
        visitedAreaMask(logical(currentAreaMask)) = 0;
        
    end
    
    basePoints(basePointCount+1,:) = destinIndex;
    basePoints = basePoints(any(basePoints,2),:);
    
    % Generate and Concatenate Path Sections Between Base Points
    
    individual = basePoints2WalkFnc(basePoints,gridMask);
    sizeIndiv = size(individual,2);
    outputPop(i,1:sizeIndiv) = individual;
    
    disp(['Walk ', num2str(i), ' of ', num2str(pS),...
        ' Complete']);
    
end

end