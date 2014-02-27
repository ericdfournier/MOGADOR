function [ outputPop ] = popCrossoverFnc(   inputSelection,...
                                            popSize,...
                                            sourceIndex,...
                                            destinIndex,...
                                            crossoverType,...
                                            gridMask )

% crossoverFnc Generates a child pathway from the single or double point 
% crossover of two previously selected parent pathways.
%
% DESCRIPTION:
%
%   Function to randomly selects valid crossover sites for the production
%   of a new child pathway from a set of two previously selected parent 
%   pathways.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputPop ] =  popCrossoverFnc( inputPop, sourceIndex,...
%                                       destinIndex, crossoverType )
%
% INPUTS:
%
%   inputPop =      [n x m] array where each row represents a set of index 
%                   values listing the connected grid cells forming a 
%                   pathway from a specified source to a specified target 
%                   destination given the constraints of a specified study 
%                   region
%
%   popSize =       [f] scalar value indicating the desired number of
%                   individuals in the output population
%
%   sourceIndex =   [i j] index value of the source node for each parent
%
%   destinIndex =   [p q] index value of the destination node for each
%                   parent
%   
%   crossoverType = [0|1] binary scalar in which specifies one of two
%                   possible cases:
%                       Case 0: Single Point Crossover
%                       Case 1: Double Point Crossover
%
%   gridMask =      [q x s] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   ouputPop =      [n x m] array containing the individuals produced as a
%                   result of the crossover operation performed for random
%                   (and possibly replicate) pairwise combinations of 
%                   individuals from the input population
%   
% EXAMPLES:
%   
%   Example 1 =
%
%                   gridMask = zeros(100);
%                   gridMask(1,:) = nan;
%                   gridMask(:,1) = nan;
%                   gridMask(end,:) = nan;
%                   gridMask(:,end) = nan;
%
%                   sourceIndex = [20 20];
%                   destinIndex = [80 80];
%                   plot = 0;
%                   [initialPop, genomeLength] = initializePopFnc(popSize,
%                                                   objectiveVars,...
%                                                   objectievFrac,...
%                                                   minClusterSize,...
%                                                   sourceIndex,...
%                                                   destinIndex, gridMask);
%
%                   crossoverType = 1;
%
%                   outputPop = popCrossoverFnc(inputPop,sourceIndex,...
%                                   destinIndex,crossoverType,gridMask);
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x)...
    x == 6);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'inputPop',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'popSize',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'sourceIndex',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'destinIndex',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'crossoverType',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,inputSelection,popSize,sourceIndex,destinIndex,...
    crossoverType,gridMask);

%% Function Parameters

pS = popSize;
sS = size(inputSelection,1);
gL = size(inputSelection,2);

%% Error Checking

if mod(sS,2) ~= 0
    tit='Number of Individuals in inputPop Must be Even';
    disp(tit);
    error('Number of Individuals in inputPop Must be Even');
end

%% Iteration Parameters

h = pS/2;
parent1Ind = reshape(datasample(1:1:sS,pS),[h 2]);
parent2Ind = reshape(datasample(1:1:sS,pS),[h 2]);
parentInd = vertcat(parent1Ind,parent2Ind);

%% Compute Crossover

outputPop = zeros(pS,gL);
popCount = 0;

while popCount < popSize
    
    popCount = popCount + 1;
    
    parent1 = inputSelection(parentInd(popCount,1),:);
    parent2 = inputSelection(parentInd(popCount,2),:);
    outputPop(popCount,:) = crossoverFnc(parent1,parent2,sourceIndex,...
        destinIndex,crossoverType,gridMask);
    
end

end