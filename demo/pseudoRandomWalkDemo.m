function [ individual ] = pseudoRandomWalkDemo( sourceIndex,...
                                                destinIndex,...
                                                gridMask )

% pseudoRandomWalkDemo.m Generates pathway index values for one or more  
% pseudo random walks between a given source and destination on a 2D grid. 
% In this version the covariance matrix [sigma] is determined upon the
% distance from the nearest point on the basis solution (the euclidean 
% shortest path) at each iteration. 
%
% DESCRIPTION:
%
%   Function to iteratively compute a random walking path on a grid from a
%   source target gridcell to a source destination gridcell. Paths are
%   recorded as a sequence of grid cell index values.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ individual ] =  pseudoRandomWalkDemo( sourceIndex, destinIndex,...
%                       gridMask )
%
% INPUTS:
%
%   sourceIndex =   [i j] index value of the source node for the
%                   start of the pseudo random walk
%
%   destinIndex =   [p q] index value of the destination node for
%                   the termination of the pseudo random walk
%
%   gridMask =      [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   individual =    [v x j] array with the index values of the pathway
%                   from the source to the desintation node computed from
%                   the random walk process. Each row (v) is a viable
%                   pathway of length (j) generated by the function [v <= r
%                   & j <= s] 
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

%% Development Notes

% THIS STILL NEEDS WORK...JUST STARTED THE PROCESS OF INITIALIZING THE
% FIGURE SET...NEED TO IMPLEMENT THE 'refreshdata' COMMAND WITHIN THE WHILE
% LOOP...

% LAST LINE COMMIT: 162

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x) x == 3);
addRequired(P,'nargout',@(x) x >= 0);
addRequired(P,'sourceIndex',@(x) ...
    isnumeric(x) && ...
    isrow(x) && ...
    ~isempty(x));
addRequired(P,'destinIndex',@(x) ...
    isnumeric(x) && ...
    isrow(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,sourceIndex,destinIndex,gridMask);

%% Iteration Parameters

gS = size(gridMask);
sF = nthroot((gS(1,1)*gS(1,2)),10);      % This controls the randomness          
sI = sourceIndex;
dI = destinIndex;
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(10*sD);                      
individual = zeros(1,gL);
destinInd = sub2ind(gS,destinIndex(1,1),destinIndex(1,2));

%% Compute Basis and Basis Distances

basisInd = euclShortestWalkFnc(sourceIndex,destinIndex,gridMask);
basisInd = basisInd(any(basisInd,1))';
bw = gridMask;
bw(basisInd) = 1;
basisDist = bwdist(bw);

%% Generate Pathways

iter = 0;
walkCheck = 0;
neighborhoodBoundaryError = 0;
gridMaskBoundaryError = 0;
culDeSacError = 0;
noValidNeighborError = 0;
success = 0;
failure = 0;

while walkCheck == 0
    
    iter = iter+1;
    visitedGrid = zeros(gS);
    visitedGrid(sI(1,1),sI(1,2)) = 1;
    visitedList = zeros(gL,2);
    visitedList(1,1) = sourceIndex(1,1);
    visitedList(1,2) = sourceIndex(1,2);
    
    for i = 1:gL+1
        
        % Initialize Parameters
        
        mu = -sign(visitedList(i,:)-dI);
        current = visitedList(i,:);
        neighborhoodSub = zeros(9,2);
        minBasisDist = basisDist(current(1,1),current(1,2));
        
        if minBasisDist == 0
            
            cov = sF*sqrt(1/(1/sF));
            
        else
            
            cov = sF*sqrt(1/minBasisDist);
            
        end
        
        sigma = [cov 0; 0 cov];
        
        % Construct Current Neighborhood
        
        j = current(1,1);
        k = current(1,2);
        neighborhoodSub(1,:) = [j-1,k-1];
        neighborhoodSub(2,:) = [j-1,k];
        neighborhoodSub(3,:) = [j-1,k+1];
        neighborhoodSub(4,:) = [j,k-1];
        neighborhoodSub(5,:) = [j,k];
        neighborhoodSub(6,:) = [j,k+1];
        neighborhoodSub(7,:) = [j+1,k-1];
        neighborhoodSub(8,:) = [j+1,k];
        neighborhoodSub(9,:) = [j+1,k+1];
        
        % Check Validity of Current Neighborhood
        
        if all(neighborhoodSub(:,1)) == 0 || all(neighborhoodSub(:,2)) == 0

            neighborhoodBoundaryError = neighborhoodBoundaryError + 1;
            walkCheck = 0;
            
            break
            
        else
            
        end
            
        neighborhoodInd = sub2ind(gS,neighborhoodSub(:,1),...
            neighborhoodSub(:,2));
        
        % Check Current Neighborhood Against the Grid Mask
        
        rawNeighbors = gridMask(neighborhoodInd);
        openNeighborCheck = rawNeighbors == 1;
        openNeighbors = neighborhoodInd(openNeighborCheck);
        
        if sum(openNeighborCheck) == 0
            
            gridMaskBoundaryError = gridMaskBoundaryError + 1;
            walkCheck = 0;
            
            break
            
        else
            
        end
        
        % Check Current Neighborhood for Previously Visited Neighbors
        
        visitedCur = logical(visitedGrid(neighborhoodInd));
        visitedInd = neighborhoodInd(visitedCur);        
        [visitedNeighbors, ~] = intersect(...
            neighborhoodInd,visitedInd);
        newNeighbors = setdiff(neighborhoodInd,visitedNeighbors);
        numNewNeighbors = size(newNeighbors,1);
        
        if numNewNeighbors == 0
            
            culDeSacError = culDeSacError + 1;
            walkCheck = 0;
            
            break
            
        else
            
        end
        
        % Find Valid New Neighbors
        
        validNewNeighborsInd = intersect(openNeighbors,newNeighbors);
        
        if isempty(validNewNeighborsInd) == 1
            
            noValidNeighborError = noValidNeighborError + 1;
            walkCheck = 0;
            
            break
            
        else
            
        end
        
        % Initiate New Move Search
        
        validCheck = 0;
        
        while validCheck == 0
            
            newDirection = sign(round(mvnrnd(mu,sigma,1)));
            newSub = current + newDirection;
            newInd = sub2ind(gS,newSub(1,1),newSub(1,2));
            validCheck = ~isempty(intersect(newInd,validNewNeighborsInd));
            
        end
        
        % Evaluate Stopping Conditions
        
        if newInd == destinInd
            
            visitedList(i+1,:) = newSub;
            success = success + 1;
            walkCheck = 1;
            
            break
            
        elseif i < gL && newInd ~= destinInd
            
            visitedList(i+1,:) = newSub;
            visitedGrid(newInd) = 1;
            walkCheck = 0;
            
        elseif i == gL && newInd ~= destinInd
            
            visitedList(i+1,:) = newSub;
            walkCheck = 0;
            
            break
            
        end
                
    end
    
    if iter == 200 % DETERMINISTIC STOPPING CONDITION
        
        failure = failure + 1;
        walkCheck = 1;
        
    else
        
    end
    
end

anyVisited = visitedList(any(visitedList,2),:);
sizeAnyVisited = size(anyVisited,1);
individual(1,1:sizeAnyVisited) = sub2ind(gS,anyVisited(:,1),...
    anyVisited(:,2))';

end