function [ outputPop ] = popCrossoverFnc( inputPop, sourceIndex,...
                                            destinIndex, crossoverType,...
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
%%%                            August 2013                               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Fixed Parameters

popSize = size(inputPop,1);
gL = size(inputPop,2);

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x) x == 5);
addRequired(p,'inputPop',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));
addRequired(p,'sourceIndex',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'destinIndex',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'crossoverType',@(x) isnumeric(x) && isscalar(x) &&...
    ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,inputPop,sourceIndex,destinIndex,crossoverType,gridMask);

%% Error Checking

if mod(popSize,2) ~= 0
    tit='Number of Individuals in inputPop Must be Even';
    disp(tit);
    error('Number of Individuals in inputPop Must be Even');
end

%% Iteration Parameters

h = popSize/2;
parent1Ind = reshape(randomsample(1:1:popSize,popSize),[h 2]);
parent2Ind = reshape(randomsample(1:1:popSize,popSize),[h 2]);
parentInd = vertcat(parent1Ind,parent2Ind);
outputPop = zeros(popSize,gL);

%% Compute Crossover

for i = 1:popSize
    parent1 = inputPop(parentInd(i,1),:);
    parent2 = inputPop(parentInd(i,2),:);
    outputPop(i,:) = crossoverFnc(parent1,parent2,sourceIndex,...
        destinIndex,crossoverType,gridMask);
end

end