function [ selection ] = popSelectionFnc(   inputPop,...
                                            selectionFrac,...
                                            selectionProb,...
                                            objectiveVars,...
                                            gridMask)

% popSelectionFnc.m Selects individuals from an input population 
% for transferral to the output population on the basis of a tournament
% selection process. First the top and the bottom ten percent of the 
% population (20% total), as measured in terms of fitness, are selected.
% Then, a tournament selection procedure is implemented wherein pairs of
% individuals are randomly selected from the population, their fitness
% compared, and the more individual is retained according to the 
% propability specified in the input variable selectionProb.
%
% DESCRIPTION:
%
%   Function to determine the set of individuals who are selected to 
%   survive each successive generation of the evolutionary process. 
%   Tournament selection is performed on the basis successive pairwise 
%   comparisons of pairs on individuals randomly selected from the input 
%   population until a target fraction of the input population has been 
%   carried over as the output population.     
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ ouputPop ] =  popSelectionFnc(    inputPop,...
%                                       selectionFrac,...
%                                       selectionProb,...
%                                       objectiveVars,...
%                                       gridMask )
%
% INPUTS:
%
%   inputPop =          [j x k] array where each row represents a set of
%                       index values listing the connected grid cells 
%                       forming a pathway from a specified source to a 
%                       specified target destination given the constraints
%                       of a specified study region
%
%   selectionFrac =     [g] scalar value ranging from 0 to 1, indicating
%                       the fraction of the total number of individuals 
%                       within the population that will be selected to 
%                       participate in crossover and the production of
%                       the next generation of individuals
%
%   selectionProb =     [r] scalar value ranging from 0 to 1, indicating 
%                       the probability that an individual will be selected
%                       if it is determined to be more fit than its 
%                       tournament opponent during each phase of the 
%                       tournament
%
%   objectiveVars =     [n x m x g] array in which the first two spatial
%                       dimensions correspond to the dimensions of the grid 
%                       mask and the third dimension corresponds to the 
%                       various objective variables
%
%   gridMask =          [n x m] binary array where grid cells with a value
%                       of 1 correspond to locations that are within the
%                       search domain and grid cells with values of 0
%                       correpsond to locations that are excluded from the
%                       search domain
%
% OUTPUTS:
%   
%   outputPop =         [r x h] array where each row represents a set of
%                       index values listing the connected grid cells 
%                       forming a pathway from a specified source to a 
%                       specified target destination given the constraints
%                       of a specified study region (r < n) to be carried
%                       over to participate in the crossover operation
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

P = inputParser;

addRequired(P,'nargin', @(x)...
    x == 5);
addRequired(P,'nargout', @(x)...
    x == 1); 
addRequired(P,'inputPop',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'selectionFrac',@(x)...
    isnumeric(x) &&...
    x >= 0 &&...
    x <= 1 &&...
    ~isempty(x));
addRequired(P,'selectionProb',@(x)...
    isnumeric(x) &&...
    x >= 0 &&...
    x <= 1 &&...
    ~isempty(x));
addRequired(P,'objectiveVars',@(x)...
    isnumeric(x) &&...
    numel(size(x)) >= 2 &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,inputPop,selectionFrac,selectionProb,...
    objectiveVars,gridMask);

%% Function Parameters 

pS = size(inputPop,1); % population size
gL = size(inputPop,2); % genome length
tS = floor(selectionFrac.*pS); % initial selection size

% Make selection size even if it is odd

if mod(tS,2) == 1
    tS = tS-1;
end

tF = floor(tS.*0.1);
bF = floor(tS.*0.1);
mF = tS - tF - bF;
selection = zeros(tS,gL);
individuals = zeros(2,gL);
fitness = zeros(2,1);

%% Sort Individuals by Fitness

popFitness = popFitnessFnc(inputPop,objectiveVars,gridMask);
[~, sortedPopInd] = sort(sum(popFitness,2),'descend');

%% Retain Top and Bottom Fractions

selection(1:tF,:) = inputPop(sortedPopInd <= tF,:);
selection((tF+1):(tF+bF),:) = inputPop(sortedPopInd > pS-bF,:);

%% Generate Pairs Via Selection with Removal

list = sortedPopInd(sortedPopInd > tF & sortedPopInd <= pS-bF);
pairs = reshape(datasample(list,mF.*2,'Replace',false),[mF,2]);

%% Perform Tournament Selection

for i = tF+1:tS-bF
    
    individuals(1,:) = inputPop(pairs(i-bF,1),:);
    individuals(2,:) = inputPop(pairs(i-bF,2),:);
    fitness(1,1) = sum(fitnessFnc(individuals(1,:),...
        objectiveVars,...
        gridMask));
    fitness(2,1) = sum(fitnessFnc(individuals(2,:),...
        objectiveVars,...
        gridMask));
    [~, index] = sort(fitness,1,'ascend');
    val = rand(1);
    
    if val <= selectionProb
        
        selection(i,:) = individuals(index(1),:);
        
    elseif val > selectionProb
        
        selection(i,:) = individuals(index(2),:);
        
    end
    
end
            
end