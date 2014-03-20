function [ initialPop ] = initPopFnc(   popSize,...
                                        sourceIndex,...
                                        destinIndex,...
                                        objectiveVars,...
                                        objectiveFrac,...
                                        minClusterSize,...
                                        gridMask )
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
%   [ initialPop ] =    initPopFnc( popSize, sourceIndex,...
%                                   destinIndex,objectiveVars,...
%                                   objectiveFrac, minClusterSize,...
%                                   gridMask )
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
%   initialPop =        [j x k] double array containing the grid index 
%                       values of the individuals within the population 
%                       (Note: each individual corresponds to a connected 
%                       pathway from the source to the destination grid 
%                       cells within the study area)
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
%                       [initialPop] = initPopFnc(...
%                                       popSize,sourceIndex,destinIndex,...
%                                       objectiveVars,objectiveFrac,...
%                                       minClusterSize,gridMask);
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

gS = size(gridMask);
bandWidth = 142;

%% Progress Messages

switchMsg = {   '**Single Part Walk Detected**',...
                '**Multi-Part Walk Detected**',...
                '**Convex Search Domain Detected**',...
                '**Concave Search Domain Detected**'};

walkMsg =   {   '**Initiating Walks**',...
                '**Walks Completed**'};

%% Switch Parameters

euclPath = euclShortestWalkFnc(sourceIndex,destinIndex,gridMask);
isConcave = ~all(gridMask(euclPath));
basePointCount = floor(sqrt(gS(1,1)*gS(1,2))/bandWidth);
isMultiPart = basePointCount >= 1;

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

%% Switch Cases

disp(walkMsg{1});

switch caseVar
    
    case 1      % Single Part Walk & Convex Search Domain
        
        initialPop = singlePartConvexWalkFnc(...
            popSize,...
            sourceIndex,...
            destinIndex,...
            gridMask);
    
    case 2      % Single Part Walk & Concave Search Domain      
        
        initialPop = singlePartConcaveWalkFnc(...
            popSize,...
            sourceIndex,...
            destinIndex,...
            objectiveVars,...
            objectiveFrac,...
            minClusterSize,...
            gridMask);
        
    case 3      % Multi-Part Walk & Convex Search Domain
        
        initialPop = multiPartConvexWalkFnc(...
            popSize,...
            sourceIndex,...
            destinIndex,...
            objectiveVars,...
            objectiveFrac,...
            minClusterSize,...
            gridMask);
        
    case 4      % Multi-Part Walk & Concave Search Domain
        
        initialPop = multiPartConcaveWalkFnc(...
            popSize,...
            sourceIndex,...
            destinIndex,...
            objectiveVars,...
            objectiveFrac,...
            minClusterSize,...
            gridMask);

end

disp(walkMsg{2});
        
end