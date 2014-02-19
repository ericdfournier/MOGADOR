function [ outputPop ] = popTournamentSelectionFnc( inputPop,...
                                                    tournamentSize,...
                                                    selectionProb,...
                                                    selectionType,...
                                                    objectiveVars,...
                                                    gridMask)

% popTournamentSelectionFnc selects individuals from an input population 
% for transferral to the output population on the basis of a tournament
% selection process. 
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
%   [ ouputPop ] =  popTournamentSelectionFnc(  inputPop,...
%                                               tournamentSize,...
%                                               selectionProb,...
%                                               selectionType,...
%                                               objectiveVars,...
%                                               gridMask )
%
% INPUTS:
%
%   inputPop =          [j x k] array where each row represents a set of
%                       index values listing the connected grid cells 
%                       forming a pathway from a specified source to a 
%                       specified target destination given the constraints
%                       of a specified study region
%
%   tournamentSize =    [g] an even numbered scalar value with the number
%                       of individuals from the input population desired to 
%                       participate in the tournament process. With larger 
%                       tournament sizes, weaker individuals have a smaller 
%                       chance of being selected for crossover
%
%   selectionProb =     [r] scalar value ranging from 0 to 1, indicating 
%                       the probability that an individual will be selected
%                       if it is determined to be more fit than its 
%                       tournament opponent during each phase of the 
%                       tournament
%
%   selectionType =     [0|1] a binary scalar value with the following two
%                       case definitions:
%                           Case 0: Selection with removal
%                           Case 1: Selection without removal
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
%%%               University of California Santa Barbara                 %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Fixed Parameters 

pS = size(inputPop);

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin', @(x)...
    x == 6);
addRequired(P,'nargout', @(x)...
    x == 1); 
addRequired(P,'inputPop',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'tournamentSize',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'selectionType',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
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

parse(P,nargin,nargout,inputPop,tournamentSize,selectionType,...
    selectionProb,objectiveVars);

%% Error Checking 

if selectionType == 0 && tournamentSize > pS(1,1)/2
    
    warning(['For selection with replacement {selectionType = 0) ',...
        'the tournament size must less than or equal to 1/2 the ',...
        'total number of individuals in the input population']);
    
end 

%% Function Parameters

m = 1:1:pS(1,1);
outputPop = zeros(tournamentSize,pS(1,2));
individuals = zeros(2,pS(1,2));
fitness = zeros(2,1);

%% Switch Case

switch selectionType
    
    case 0      % With Removal
        
        pairs = reshape(datasample(m,tournamentSize*2,'Replace',false),...
            [tournamentSize,2]);
        
    case 1      % Without Removal
        
        h = 0;
        
        while h == 0
            
            pairs = reshape(datasample(m,tournamentSize*2,'Replace',...
                true),[tournamentSize,2]);
            
            for i = 1:2
                
                if pairs(i,1) == pairs(i,2)
                    
                    h = 0;
                    
                else
                    
                    h = 1;
                    
                end
                
            end
            
        end
        
end

%% Perform Tournament Selection

for i = 1:tournamentSize
    
    individuals(1,:) = inputPop(pairs(i,1),:);
    individuals(2,:) = inputPop(pairs(i,2),:);
    fitness(1,1) = sum(fitnessFnc(individuals(1,:),...
        objectiveVars,...
        gridMask));
    fitness(2,1) = sum(fitnessFnc(individuals(2,:),...
        objectiveVars,...
        gridMask));
    [~, index] = sort(fitness,1,'ascend');
    val = rand(1);
    
    if val <= selectionProb
        
        outputPop(i,:) = individuals(index(1),:);
        
    elseif val > selectionProb
        
        outputPop(i,:) = individuals(index(2),:);
        
    end
    
end
            
end