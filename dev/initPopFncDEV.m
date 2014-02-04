function [ initialPop, popParams ] = initPopFncDEV( popSize,...
                                        objectiveVars, objectiveFrac,...
                                        minClusterSize, sourceIndex,...
                                        destinIndex, gridMask )
%
% initPopFunc.m Initializes sequences of two or more base points (each 
% of which represents the centroid of low aggregate objective score 
% clusters) to be used for the decomposition of a pseudoRandomWalk into 
% three or more smaller sub sections
%
% DESCRIPTION:
%
%   Function that initializes sequences of two or more base points which 
%   are used to construct multipart pseudorandom walks. These sequences of
%   base points are constrained to be ordered in such a way as to prevent
%   backtracking within the path sections.
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ initialPop, popParams ] =  initPopFnc( popSize, objectiveVars,...
%                                   objectiveFrac, minClusterSize,...
%                                   sourceIndex,destinIndex, gridMask )
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
%   minClusterSize =    [r] scalar value indicating the minimum number of
%                       connected cells (assuming queen's connectivity) 
%                       that are required to consititute a viable cluster
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
%   initialPop =        [j x k] double array containing the grid index 
%                       values of the individuals within the population 
%                       (Note: each individual corresponds to a connected 
%                       pathway from the source to the destination grid 
%                       cells within the study area)
%
%   popParams =         [Object] population parameters object containing 
%                       information related to the generation parameters of
%                       the initial population
%
% EXAMPLES:
%   
%   Example 1 =
%
%                       gridMask = zeros(100);
%                       gridMask(:,1) = nan;
%                       gridMask(1,:) = nan;
%                       gridMask(end,:) = nan;
%                       gridMask(:,end) = nan;
%
%                       sourceIndex = [20 20];
%                       destinIndex = [80 80];
%                       objectiveVars = randi([0 10],10000,3);
%                       objectiveFrac = 0.10;
%                       minClusterSize = 5;
%                       popSize = 50;
%
%                       [initialPop, popParams] = initPopFnc(...
%                                       popSize,objectiveVars,...
%                                       objectiveFrac,minClusterSize,...
%                                       sourceIndex,destinIndex,gridMask);
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                             January 2014                             %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x) x == 7);
addRequired(p,'nargout',@(x) x == 2);
addRequired(p,'popSize',@(x) isnumeric(x) && isscalar(x)...
    && rem(x,1) == 0 && x > 0 && ~isempty(x));
addRequired(p,'objectiveVars',@(x) isnumeric(x) && numel(size(x)) >= 2 ...
    && ~isempty(x));
addRequired(p,'objectiveFrac',@(x) isnumeric(x) && isscalar(x)...
    && rem(x,1) ~= 0 && x <= 1 && x >= 0 && ~isempty(x));
addRequired(p,'minClusterSize',@(x) isnumeric(x) && isscalar(x)...
    && rem(x,1) == 0 && x > 0 && ~isempty(x));
addRequired(p,'sourceIndex',@(x) isnumeric(x) && isrow(x) && ~isempty(x)...
    && rem(x(1,1),1) == 0 && rem(x(1,2),1) == 0);
addRequired(p,'destinIndex',@(x) isnumeric(x) && isrow(x) && ~isempty(x)...
    && rem(x(1,1),1) == 0 && rem(x(1,2),1) == 0);
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,nargout,popSize,objectiveVars,objectiveFrac,...
    minClusterSize,sourceIndex,destinIndex,gridMask);

%% Function Parameters

pS = popSize;
gS = size(gridMask);
bandWidth = 142;

%% Input Warnings

if pS < 10*gL
    
    warning(['Population Size Must be At Least Ten Times the Genome ',...
        'Length']);
    
else
    
end

%% Progress Messages

switchMsg = {   '**Single Part Walk Detected**',...
                '**Multi-Part Walk Detected**',...
                '**Convex Search Domain Detected**',...
                '**Concave Search Domain Detected**'};

walkMsg =   {   '**Initiating Walks**',...
                '**Walks Completed**'...
                };

%% Switch Parameters

euclPath = euclShortestWalkFnc(gridMask,sourceIndex,destinIndex);
isConcave = any(gridMask(euclPath));
basePointCount = floor(sqrt(gS(1,1)*gS(1,2))/bandWidth);
isMultiPart = basePointCount > 1;

if isMultiPart == 0 && isConcave == 0
    
    caseVar = 1;
    disp(switchMsg{1});
    disp(switchMsg{3});
    
elseif isMultiPart == 0 && isConcave == 1
    
    caseVar = 2;
    disp(switchMsg{1});
    disp(switchMsg{4});
    
elseif isMultiPart == 1 && isConcave == 0
    
    caseVar = 3;
    disp(switchMsg{2});
    disp(switchMsg{3});
    
elseif isMultiPart == 1 && isConcave == 1
    
    caseVar = 4;
    disp(switchMsg{2});
    disp(switchMsg{4});
    
end

%% Switch Case 1: Single Part Walk With Convex Search Domain

switch caseVar
    
    case 1    % Single Part Walk & Convex Search Domain

        disp(walkMsg{1});
        
        initialPop = singlePartConvexWalkFnc(...
            popSize,...
            sourceIndex,...
            destinIndex,...
            gridMask    );
        
        disp(walkMsg{2});
    
    case 2     % Single Part Walk & Concave Search Domain
        
        disp(walkMsg{1});
        
        % Generate Top Centroids Mask
        
        [topCentroidsMask, ~] = topCentroidsMaskFnc(...
            objectiveVars,...
            objectiveFrac,...
            minClusterSize,...
            gridMask    );
        
        % Iteratively Generate Base Points Using Convex Area Masks
        
        basePointLimit = floor(sqrt(gS(1,1)*gS(1,2)));
        
        for i = 1:pS
            
            disp(['Walk ', num2str(i), ' of ', num2str(popSize),...
                ' Initiated']); 
            
            basePointCount = 0;
            basePointCheck = 0;
            basePoints = zeros(basePointLimit,2);
            basePoints(1,:) = sourceIndex;
            visitedAreaMask = ones(gS);
            
            while basePointCheck == 0
                
                % Check that the Current Number of Base Points is Below the
                % Maximum
                
                basePointCount = basePointCount+1;
                
                if basePointCount == basePointLimit
                    
                    error(['Process Terminated: Unable to Reach Target',...
                        ' Destination due to Extreme Concavity of the',...
                        ' Search Domain']);
                    
                else
                    
                end
                
                % Check to determine if Final Destination is Contained 
                % Within Current Convex Area Mask
                
                currentBasePoint = basePoints(basePointCount,:);
                convexAreaMask = convexAreaMaskFnc(currentBasePoint,...
                    gridMask);
                currentAreaMask = convexAreaMask.*visitedAreaMask;
                containsDestin = currentAreaMask(destinIndex(1,1),...
                    destinIndex(1,2)) == 1;
                
                if containsDestin == 1
                    
                    break;
                    
                else
                    
                end
                
                % Sort Elligible Top Centroids by Distance from Current 
                % Source
                
                sourceMask = zeros(gS);
                sourceMask(currentBasePoint(1,1),...
                    currentBasePoint(1,2)) = 1;
                sourceDistMask = bwdist(sourceMask);
                
                % Check to determine if there are any Elligible Centroids
                % within the Current Area Mask
                
                eCentroidDistMask = topCentroidsMask.*currentAreaMask.*...
                    gridMask.*sourceDistMask;
                [eCentroidRows, eCentroidCols,eCentroidVals] =...
                    find(eCentroidDistMask);
                seCentroids = flipud(sortrows(...
                    [eCentroidRows eCentroidCols eCentroidVals],3));
                eCentroidCount = size(eCentroidRows,1);
                
                if isempty(seCentroids) == 1
                                        
                    disp(['Restarting Walk: No Elligible Cluster ',...
                        'Centroids Found from Current Base Point']);
                    
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
            initialPop(i,1:sizeIndiv) = individual;
            
            disp(['Walk ', num2str(i), ' of ', num2str(popSize),...
                ' Complete']);
            
        end
        
        % Document Output Parameters
        
        domainMorphology = 'Concave';
        basePointsVisited = basePointCount;
        
        disp(walkMsg{2});

end

%% Write Output Population Parameters

popParams = struct('popSize',popSize,'genomeLength',gL,...
    'objectiveFraction',objectiveFrac,'minClusterSize',...
    minClusterSize,'basePointCount',basePointCount,'basePointsVisited',...
    basePointsVisited,'domainMorphology',domainMorphology,...
    'gridMaskSize',gS);
        
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     case 3    % Multi-Part Walk & Convex Search Domain
%         
%         disp(walkMsg{1});
%         disp(walkMsg{3});
%         
%         % Generate Top Centroids Mask
%         
%         [topCentroidsMask, ~] = topCentroidsFnc(...
%             popSize,objectiveVars,objectiveFrac,minClusterSize,gridMask);
%         
%         % Generate Distance Band Masks
%         
%         sdBW = zeros(gS);
%         sdBW(sourceIndex(1,1),sourceIndex(1,2)) = 1;
%         sourceDist = reshape(bwdist(sdBW),gS(1,1)*gS(1,2),1);
%         maxDist = range(sourceDist);
%         distBandInt = linspace(1,maxDist,basePointCount+1);
%         distBandMask = cell(1,basePointCount);
%         
%         for k = 1:basePointCount
%             distBand = gridMask;
%             
%             if k == 1 
%                 distBandInd = ...
%                     sourceDist < distBandInt(k+1);
%             elseif k > 1 && k < basePointCount
%                 distBandInd = ...
%                     sourceDist >= distBandInt(k) &...
%                     sourceDist < distBandInt(k+1);
%             elseif k == basePointCount
%                 distBandInd = ...
%                     sourceDist >= distBandInt(k);
%             end
%             
%             distBand(distBandInd) = 1;
%             distBand = distBand+gridMask;
%             distBandMask{1,k} = distBand;
%         end
%         
%         % Specify Iteration Paramters
%         
%         basePoints = cell(popSize,basePointCount);
%         sections = cell(popSize,(basePointCount+1));
%         sectionsFinal = cell(popSize,(basePointCount+1));
%         randomsVisited = 0;
%         basePointsVisited = 0;
%         
%         % Open Nested For-Loop
%         
%         for i = 1:popSize
%             
%             s_d = -sign(sourceIndex-destinIndex); % THIS NEEDS TO BE MODIFIED
%             destinShadowMask = gridMask;
%             
%             for j = 1:basePointCount
%                 
%                 currentBandMask = distBandMask{1,j};
%                 currentBasePointMask = gridMask;
%                 
% % THIS IF/THEN SWITCH MUST BE MODIFIED SO THAT THE BASE POINT MASK IS
% % EVALUATED ON THE BASIS OF THE CURRENT START CELL TO THE CURRENT BASE
% % POINT
%                 
%                 basePointCand = currentBandMask.*...
%                     currentBasePointMask.*destinShadowMask.*...
%                     topCentroidsMask;
%                 basePointCandInd = find(basePointCand == 1);
%                 
%                 if isempty(basePointCandInd)
%                     basePointCandInd = datasample(reshape(...
%                         (currentBandMask.*currentBasePointMask.*...
%                         destinShadowMask),...
%                         (gS(1,1)*gS(1,2)),1),1);
%                     [bpRow, bpCol] = ind2sub(gS,basePointCandInd);
%                     randomsVisited = randomsVisited + 1;
%                 else
%                     [bpRow, bpCol] = ind2sub(gS,...
%                         datasample(basePointCandInd,1));
%                     basePointsVisited = basePointsVisited + 1;
%                 end
%                 
%                 basePoints{i,j} = [bpRow bpCol];
%                 
%             end
%             
%         end
%             
%     case 4    % Multi-Part Walk & Concave Search Domain        
%         
% end
% 
% %% Write Population Parameters
%       
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%
% 
% switch caseVar
%         
%         
%         % Generate Destination Shadow Mask
%         
%         s_d = -sign(sourceIndex-destinIndex);
%         destinShadowMask = gridMask;
%         
%         switch s_d(1,1)
%             
%             case -1
%                 
%                 switch s_d(1,2)
%                     
%                     case -1
%                         
%                         destinShadowMask...
%                             (destinIndex(1,1):end,...
%                             destinIndex(1,2):end) = 1;
%                         
%                     case 0
%                         
%                         destinShadowMask...
%                             (destinIndex(1,1):end,:) = 1;
%                         
%                     case 1
%                         
%                         destinShadowMask...
%                             (destinIndex(1,1):end,...
%                             1:destinIndex(1,2)) = 1;
%                         
%                 end
%                 
%             case 0
%                 
%                 switch s_d(1,2)
%                     
%                     case -1
%                         
%                         destinShadowMask...
%                             (destinIndex(1,2):end) = 1;
%                         
%                     case 1
%                         
%                         destinShadowMask...
%                             (1:destinIndex(1,2):end) = 1;
%                         
%                 end
%                 
%             case 1
%                 
%                 switch s_d(1,2)
%                     
%                     case -1
%                         
%                         destinShadowMask...
%                             (1:destinIndex(1,1),...
%                             destinIndex(1,2):end) = 1;
%                         
%                     case 0
%                         
%                         destinShadowMask...
%                             (1:destinIndex(1,1),:) = 1;
%                         
%                     case 1
%                         
%                         destinShadowMask...
%                             (1:destinIndex(1,1),...
%                             1:destinIndex(1,2)) = 1;
%                         
%                 end
%                 
%         end
%                 
%         % Generate Pairwise Combinations and Test Sequence Validity
%         
%         disp('**Generating Multi-Part Walks**');
%         
%         basePoints = cell(popSize,basePointCount);
%         sections = cell(popSize,(basePointCount+1));
%         sectionsFinal = cell(popSize,(basePointCount+1));
%         randomsVisited = 0;
%         basePointsVisited = 0;
%         
%         for i = 1:popSize
%                 
%             % Select Point Indices from Successive Distance Bands
%             
%             for j = 1:basePointCount
%                 
%                 currentBandMask = distBandMask{1,j};
%                 currentBasePointMask = gridMask;
%                 
%                 if j == 1
%                     
%                     switch s_d(1,1)
%                         
%                         case -1
%                             
%                             switch s_d(1,2)
%                                 
%                                 case -1
%                                     
%                                     currentBasePointMask...
%                                         (1:sourceIndex(1,1),...
%                                         1:sourceIndex(1,2)) = 1;
%                                     
%                                 case 0
%                                     
%                                     currentBasePointMask...
%                                         (1:sourceIndex(1,1),:) = 1;
%                                     
%                                 case 1
%                                     
%                                     currentBasePointMask...
%                                         (1:sourceIndex(1,1),...
%                                         sourceIndex(1,2):end) = 1;
%                                     
%                             end
%                             
%                         case 0
%                             
%                             switch s_d(1,2)
%                                 
%                                 case -1
%                                     
%                                     currentBasePointMask...
%                                         (:,1:sourceIndex(1,2)) = 1;
%                                     
%                                 case 1
%                                     
%                                     currentBasePointMask...
%                                         (:,sourceIndex(1,2):end) = 1;
%                                     
%                             end
%                             
%                         case 1
%                             
%                             switch s_d(1,2)
%                                 
%                                 case -1
%                                     
%                                     currentBasePointMask...
%                                         (sourceIndex(1,1):end,...
%                                         1:sourceIndex(1,2)) = 1;
%                                     
%                                 case 0
%                                     
%                                     currentBasePointMask...
%                                         (sourceIndex(1,1):end,:) = 1;
%                                     
%                                 case 1
%                                     
%                                     currentBasePointMask...
%                                         (sourceIndex(1,1):end,...
%                                         sourceIndex(1,2):end) = 1;
%                                     
%                             end
%                             
%                     end
%                     
%                 elseif j > 1
%                     
%                     switch s_d(1,1)
%                         
%                         case -1
%                             
%                             switch s_d(1,2)
%                                 
%                                 case -1
%                                     
%                                     currentBasePointMask...
%                                         (1:basePoints{1,j-1}(1,1),...
%                                         1:basePoints...
%                                         {1,j-1}(1,2)) = 1;
%                                     
%                                 case 0
%                                     
%                                     currentBasePointMask...
%                                         (1:basePoints...
%                                         {1,j-1}(1,1),:) = 1;
%                                     
%                                 case 1
%                                     
%                                     currentBasePointMask...
%                                         (1:basePoints{1,j-1}(1,1),...
%                                         basePoints...
%                                         {1,j-1}(1,2):end) = 1;
%                                     
%                             end
%                             
%                         case 0
%                             
%                             switch s_d(1,2)
%                                 
%                                 case -1
%                                     
%                                     currentBasePointMask...
%                                         (:,1:basePoints...
%                                         {1,j-1}(1,2)) = 1;
%                                     
%                                 case 1
%                                     
%                                     currentBasePointMask...
%                                         (:,basePoints...
%                                         {1,j-1}(1,2):end) = 1;
%                                     
%                             end
%                             
%                         case 1
%                             
%                             switch s_d(1,2)
%                                 
%                                 case -1
%                                     
%                                     currentBasePointMask...
%                                         (basePoints{1,j-1}(1,1):end,...
%                                         1:basePoints...
%                                         {1,j-1}(1,2)) = 1;
%                                     
%                                 case 0
%                                     
%                                     currentBasePointMask...
%                                         (basePoints...
%                                         {1,j-1}(1,1):end,:) = 1;
%                                     
%                                 case 1
%                                     
%                                     currentBasePointMask...
%                                         (basePoints{1,j-1}(1,1):end,...
%                                         basePoints...
%                                         {1,j-1}(1,2):end) = 1;
%                                     
%                             end
%                             
%                     end
%                     
%                 end
%                 
%                 basePointCand = currentBandMask.*...
%                     currentBasePointMask.*destinShadowMask.*...
%                     topCentroidMask;
%                 
%                 basePointCandInd = find(basePointCand == 1);
%                 
%                 if isempty(basePointCandInd)
%                     
%                     basePointCandInd = datasample(reshape(...
%                         (currentBandMask.*currentBasePointMask.*...
%                         destinShadowMask),...
%                         (gS(1,1)*gS(1,2)),1),1);
%                     [bpRow, bpCol] = ind2sub(gS,basePointCandInd);
%                     randomsVisited = randomsVisited + 1;
%                     
%                 else
%                     
%                     [bpRow, bpCol] = ind2sub(gS,...
%                         datasample(basePointCandInd,1));
%                     basePointsVisited = basePointsVisited + 1;
%                     
%                 end
%                 
%                 basePoints{i,j} = [bpRow bpCol];
%                 
%             end
%             
%             % Generate and Concatenate Path Sections
%             
%             gridMaskTmp = gridMask;
%             
%             for k = 1:(basePointCount+1)
%             
%                 if k == 1
%                     
%                     sections{i,k} = pseudoRandomWalkFnc(gridMaskTmp,...
%                         sourceIndex,basePoints{i,k},plot);
%                     tmp1 = sections{i,k};
%                     tmp2 = tmp1(any(tmp1,1));
%                     tmp3 = tmp2(1,1:end-1);
%                     sectionsFinal{i,k} = tmp3;
%                     
%                 elseif k > 1 && k < (basePointCount+1)
%                     
%                     sections{i,k} = pseudoRandomWalkFnc(gridMaskTmp,...
%                         basePoints{i,k-1},basePoints{i,k},plot);
%                     tmp1 = sections{i,k};
%                     tmp2 = tmp1(any(tmp1,1));
%                     tmp3 = tmp2(1,1:end-1);
%                     sectionsFinal{i,k} = tmp3;
%                     
%                 elseif k == (basePointCount+1)
%                     
%                     sections{i,k} = pseudoRandomWalkFnc(gridMaskTmp,...
%                         basePoints{i,k-1},destinIndex,plot);
%                     tmp1 = sections{i,k};
%                     tmp2 = tmp1(any(tmp1,1));
%                     sectionsFinal{i,k} = tmp2;
%                     
%                 end
%                 
%                 gridMaskTmp(sectionsFinal{i,k}) = nan;
% 
%             end
%             
%             individual = horzcat(sectionsFinal{i,:});
%             sizeIndiv = size(individual,2);
%             initialPop(i,1:sizeIndiv) = individual;
%             
%             % Display Successful Completion Message 
%             
%             disp(['Walk ', num2str(i), ' of ', num2str(popSize),...
%                 ' Completed']);
%             
%         end
%         
%         disp('**Multi-Part Walks Completed**');
%         
% end