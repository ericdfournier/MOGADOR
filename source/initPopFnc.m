function [ initialPop, popParams ] = initPopFnc( popSize,...
                                        objectiveVars, objectiveFrac,...
                                        minClusterSize, sourceIndex,...
                                        destinIndex, gridMask )

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
%                               objectiveFrac, minClusterSize,...
%                               sourceIndex,destinIndex, gridMask )
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
%   objectiveVars =     [g x h] array in which each column corresponds to a
%                       decision variable (s) and in which each row 
%                       corresponds to a spatially referenced grid cell 
%                       value (covering the entire search domain)
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
%                       labeled as NaN placeholders
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
%%%                            September 2013                            %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x) x == 7);
addRequired(p,'nargout',@(x) x >= 2);
addRequired(p,'popSize',@(x) isnumeric(x) && isscalar(x)...
    && rem(x,1) == 0 && x > 0 && ~isempty(x));
addRequired(p,'objectiveVars',@(x) isnumeric(x) && ismatrix(x)...
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

%% Warnings

sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);

if popSize < 10*gL
    warning(['Population Size Must be At Least Ten Times the Genome ',...
        'Length']);
else
end

%% Iteration Parameters

gS = size(gridMask);
aggObjectiveVars = sum(objectiveVars,2);
fracCount = objectiveFrac*(gS(1,1)*gS(1,2));
[~, sortInd] = sort(aggObjectiveVars,'ascend');
topFraction = sortInd(1:fracCount,1);
topFracMask = gridMask;
topFracMask(topFraction) = 1;
initialPop = zeros(popSize,gL);

%% Determine Basepoint Count and Switching Case

basePointCount = floor(sqrt(gS(1,1)*gS(1,2))/100);

if basePointCount == 0
    caseVar = 0;
elseif basePointCount >= 1 
    caseVar = 1;
end

%% Switching Case: Single Part vs. Multi-part Walks

plot = 0;

switch caseVar
    
    % Case 0: Generate Single-Part Walks
    
    case 0
        
        disp('**Initiating Single-Part Walks**');
        
        pathType = 'Single';
        
        for i = 1:popSize
            
            initialPop(i,:) = pseudoRandomWalkFnc(gridMask,sourceIndex,...
                destinIndex,plot);
            
        end
        
        disp('**Single-Part Walks Completed**');
        
    % Case 1: Generate Multi-Part Walks

    case 1
        
        disp('**Initiating Multi-Part Walks**');
        
        pathType = 'Multi';
        
        % Identify Cluster Centroids
        
        bw = bwconncomp(topFracMask);
        rg = regionprops(bw,'centroid','area');
        rgCell = struct2cell(rg)';
        rgArea = cell2mat(rgCell(2:end,1));
        rgCentroid = fliplr(floor(cell2mat(rgCell(2:end,2))));
        rgAreaCentroid = horzcat(rgArea,rgCentroid);
        rgSort = flipud(sortrows(rgAreaCentroid,1));
        
        % Select Top Centroids
        
        topCentroids = rgSort(rgSort(:,1) >= minClusterSize,2:3);
        sizeTC = size(topCentroids,1);
        topCentroidMask = gridMask;
        topCentroidMask(...
            sub2ind(gS,topCentroids(:,1),topCentroids(:,2))) = 1;
        
        if sizeTC <= popSize
            warning(['Very few clusters generated:',...
                ' consider lowering minimum cluster size.']);
        else
        end
        
        % Generate Distance Band Masks
        
        sdBW = zeros(gS);
        sdBW(sourceIndex(1,1),sourceIndex(1,2)) = 1;
        sourceDist = reshape(bwdist(sdBW),gS(1,1)*gS(1,2),1);
        maxDist = range(sourceDist);
        distBandInt = linspace(1,maxDist,basePointCount+1);
        distBandMask = cell(1,basePointCount);
        
        for k = 1:basePointCount
            distBand = gridMask;
            
            if k == 1 
                distBandInd = ...
                    sourceDist < distBandInt(k+1);
            elseif k > 1 && k < basePointCount
                distBandInd = ...
                    sourceDist >= distBandInt(k) &...
                    sourceDist < distBandInt(k+1);
            elseif k == basePointCount
                distBandInd = ...
                    sourceDist >= distBandInt(k);
            end
            
            distBand(distBandInd) = 1;
            distBand = distBand+gridMask;
            distBandMask{1,k} = distBand;
        end
        
        % Generate Destination Shadow Mask
        
        s_d = -sign(sourceIndex-destinIndex);
        destinShadowMask = gridMask;
        
        switch s_d(1,1)
            
            case -1
                
                switch s_d(1,2)
                    
                    case -1
                        
                        destinShadowMask...
                            (destinIndex(1,1):end,...
                            destinIndex(1,2):end) = 1;
                        
                    case 0
                        
                        destinShadowMask...
                            (destinIndex(1,1):end,:) = 1;
                        
                    case 1
                        
                        destinShadowMask...
                            (destinIndex(1,1):end,...
                            1:destinIndex(1,2)) = 1;
                        
                end
                
            case 0
                
                switch s_d(1,2)
                    
                    case -1
                        
                        destinShadowMask...
                            (destinIndex(1,2):end) = 1;
                        
                    case 1
                        
                        destinShadowMask...
                            (1:destinIndex(1,2):end) = 1;
                        
                end
                
            case 1
                
                switch s_d(1,2)
                    
                    case -1
                        
                        destinShadowMask...
                            (1:destinIndex(1,1),...
                            destinIndex(1,2):end) = 1;
                        
                    case 0
                        
                        destinShadowMask...
                            (1:destinIndex(1,1),:) = 1;
                        
                    case 1
                        
                        destinShadowMask...
                            (1:destinIndex(1,1),...
                            1:destinIndex(1,2)) = 1;
                        
                end
                
        end
                
        % Generate Pairwise Combinations and Test Sequence Validity
        
        disp('**Generating Multi-Part Walks**');
        
        basePoints = cell(popSize,basePointCount);
        sections = cell(popSize,(basePointCount+1));
        sectionsFinal = cell(popSize,(basePointCount+1));
        randomsVisited = 0;
        basePointsVisited = 0;
        
        for i = 1:popSize
                
            % Select Point Indices from Successive Distance Bands
            
            for j = 1:basePointCount
                
                currentBandMask = distBandMask{1,j};
                currentBasePointMask = gridMask;
                
                if j == 1
                    
                    switch s_d(1,1)
                        
                        case -1
                            
                            switch s_d(1,2)
                                
                                case -1
                                    
                                    currentBasePointMask...
                                        (1:sourceIndex(1,1),...
                                        1:sourceIndex(1,2)) = 1;
                                    
                                case 0
                                    
                                    currentBasePointMask...
                                        (1:sourceIndex(1,1),:) = 1;
                                    
                                case 1
                                    
                                    currentBasePointMask...
                                        (1:sourceIndex(1,1),...
                                        sourceIndex(1,2):end) = 1;
                                    
                            end
                            
                        case 0
                            
                            switch s_d(1,2)
                                
                                case -1
                                    
                                    currentBasePointMask...
                                        (:,1:sourceIndex(1,2)) = 1;
                                    
                                case 1
                                    
                                    currentBasePointMask...
                                        (:,sourceIndex(1,2):end) = 1;
                                    
                            end
                            
                        case 1
                            
                            switch s_d(1,2)
                                
                                case -1
                                    
                                    currentBasePointMask...
                                        (sourceIndex(1,1):end,...
                                        1:sourceIndex(1,2)) = 1;
                                    
                                case 0
                                    
                                    currentBasePointMask...
                                        (sourceIndex(1,1):end,:) = 1;
                                    
                                case 1
                                    
                                    currentBasePointMask...
                                        (sourceIndex(1,1):end,...
                                        sourceIndex(1,2):end) = 1;
                                    
                            end
                            
                    end
                    
                elseif j > 1
                    
                    switch s_d(1,1)
                        
                        case -1
                            
                            switch s_d(1,2)
                                
                                case -1
                                    
                                    currentBasePointMask...
                                        (1:basePoints{1,j-1}(1,1),...
                                        1:basePoints...
                                        {1,j-1}(1,2)) = 1;
                                    
                                case 0
                                    
                                    currentBasePointMask...
                                        (1:basePoints...
                                        {1,j-1}(1,1),:) = 1;
                                    
                                case 1
                                    
                                    currentBasePointMask...
                                        (1:basePoints{1,j-1}(1,1),...
                                        basePoints...
                                        {1,j-1}(1,2):end) = 1;
                                    
                            end
                            
                        case 0
                            
                            switch s_d(1,2)
                                
                                case -1
                                    
                                    currentBasePointMask...
                                        (:,1:basePoints...
                                        {1,j-1}(1,2)) = 1;
                                    
                                case 1
                                    
                                    currentBasePointMask...
                                        (:,basePoints...
                                        {1,j-1}(1,2):end) = 1;
                                    
                            end
                            
                        case 1
                            
                            switch s_d(1,2)
                                
                                case -1
                                    
                                    currentBasePointMask...
                                        (basePoints{1,j-1}(1,1):end,...
                                        1:basePoints...
                                        {1,j-1}(1,2)) = 1;
                                    
                                case 0
                                    
                                    currentBasePointMask...
                                        (basePoints...
                                        {1,j-1}(1,1):end,:) = 1;
                                    
                                case 1
                                    
                                    currentBasePointMask...
                                        (basePoints{1,j-1}(1,1):end,...
                                        basePoints...
                                        {1,j-1}(1,2):end) = 1;
                                    
                            end
                            
                    end
                    
                end
                
                basePointCand = currentBandMask.*...
                    currentBasePointMask.*destinShadowMask.*...
                    topCentroidMask;
                
                basePointCandInd = find(basePointCand == 1);
                
                if isempty(basePointCandInd)
                    
                    basePointCandInd = datasample(reshape(...
                        (currentBandMask.*currentBasePointMask.*...
                        destinShadowMask),...
                        (gS(1,1)*gS(1,2)),1),1);
                    [bpRow, bpCol] = ind2sub(gS,basePointCandInd);
                    randomsVisited = randomsVisited + 1;
                    
                else
                    
                    [bpRow, bpCol] = ind2sub(gS,...
                        datasample(basePointCandInd,1));
                    basePointsVisited = basePointsVisited + 1;
                    
                end
                
                basePoints{i,j} = [bpRow bpCol];
                
            end
            
            % Generate and Concatenate Path Sections
            
            gridMaskTmp = gridMask;
            
            for k = 1:(basePointCount+1)
            
                if k == 1
                    
                    sections{i,k} = pseudoRandomWalkFnc(gridMaskTmp,...
                        sourceIndex,basePoints{i,k},plot);
                    tmp1 = sections{i,k};
                    tmp2 = tmp1(any(tmp1,1));
                    tmp3 = tmp2(1,1:end-1);
                    sectionsFinal{i,k} = tmp3;
                    
                elseif k > 1 && k < (basePointCount+1)
                    
                    sections{i,k} = pseudoRandomWalkFnc(gridMaskTmp,...
                        basePoints{i,k-1},basePoints{i,k},plot);
                    tmp1 = sections{i,k};
                    tmp2 = tmp1(any(tmp1,1));
                    tmp3 = tmp2(1,1:end-1);
                    sectionsFinal{i,k} = tmp3;
                    
                elseif k == (basePointCount+1)
                    
                    sections{i,k} = pseudoRandomWalkFnc(gridMaskTmp,...
                        basePoints{i,k-1},destinIndex,plot);
                    tmp1 = sections{i,k};
                    tmp2 = tmp1(any(tmp1,1));
                    sectionsFinal{i,k} = tmp2;
                    
                end
                
                gridMaskTmp(sectionsFinal{i,k}) = nan;

            end
            
            individual = horzcat(sectionsFinal{i,:});
            sizeIndiv = size(individual,2);
            initialPop(i,1:sizeIndiv) = individual;
            
            % Display Successful Completion Message 
            
            disp(['Walk ', num2str(i), ' of ', num2str(popSize),...
                ' Completed']);
            
        end
        
        disp('**Multi-Part Walks Completed**');
        
end

%% Write Output Population Parameter Object

popParams = struct('popSize',popSize,'genomeLength',gL,...
    'objectiveFraction',objectiveFrac,'objectiveFractionCount',...
    fracCount,'minClusterSize',minClusterSize,'clusterCount',sizeTC,...
    'basePointCount',basePointCount,'basePointsVisited',...
    basePointsVisited,'randomsVisited',randomsVisited,'pathType',...
    pathType,'gridMaskSize',gS);
    
end