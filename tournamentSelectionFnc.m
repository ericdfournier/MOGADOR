function [ outputPop, outputPopFitness ] = tournamentSelectionFnc(...
                                            inputPop, tournamentSize,...
                                            selectionProb,...
                                            selectionType, objectiveVars )

% selectionFnc selects individuals from an input population for
% transferal to the output population on the basis of a tournament
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
%   [ ouputPop, outputPopFitness ] =  tournamentSelectionFnc( inputPop,...
%                                       tournamentSize, selectionProb,...
%                                       selectionType, objectiveVars )
%
% INPUTS:
%
%   inputPop =          [n x m] array where each row represents a set of
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
%   objectiveVars =     [r x s] array in which each column corresponds to a
%                       decision variable (s) and in which each row 
%                       corresponds to a spatially referenced grid cell 
%                       value (covering the entire search domain)                      
%
% OUTPUTS:
%   
%   outputPop =         [r x m] array where each row represents a set of
%                       index values listing the connected grid cells 
%                       forming a pathway from a specified source to a 
%                       specified target destination given the constraints
%                       of a specified study region (r < n) to be carried
%                       over to participate in the crossover operation
%
%   outputPopFitness =  [r x 1] array where each row represents the summed
%                       fitness value for the corresponding output 
%                       individual contained within the rows of the 
%                       outputPop output argument
%
% EXAMPLES:
%   
%   Example 1 =
%
%                       gridMask = zeros(100);
%                       gridMask(1,:) = nan;
%                       gridMask(:,1) = nan;
%                       gridMask(end,:) = nan;
%                       gridMask(:,end) = nan;
%                       sourceIndex = [20 20];
%                       destinIndex = [80 80];
%                       iterations = 1000;
%                       sigma = [10 0; 0 10];
%                       plot = 0;
% 
%                       inputPop = initializePopFnc(10,gridMask,...
%                           iterations,sigma,sourceIndex,destinIndex);
% 
%                       objective1 = randi([0 10],10000,1);
%                       objective2 = randi([0 10],10000,1);
%                       objective3 = randi([0 10],10000,1);
%                       objectiveVars = horzcat(objective1, objective2,...
%                           objective3);
% 
%                       tournamentSize = 5;
%                       selectionType = 0;
%                       selectionProb = 1; % A value of 1 here indicates 
%                                          % deterministic selection
% 
%                       popFitnessSum = populationFitnessFnc(inputPop,...
%                       objectiveVars);
% 
%                       [outputPop, outputPopFitness] = ...
%                           tournamentSelectionFnc(inputPop,...
%                           tournamentSize,selectionProb,selectionType,...
%                           objectiveVars);
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

n = size(inputPop);

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin', @(x) x == 5);
addRequired(p,'inputPop',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));
addRequired(p,'tournamentSize',@(x) isnumeric(x) && isscalar(x) &&...
    ~isempty(x));
addRequired(p,'selectionType',@(x) isnumeric(x) && isscalar(x) &&...
    ~isempty(x));
addRequired(p,'selectionProb',@(x) isnumeric(x) && x >= 0 && x <= 1 &&...
    ~isempty(x));
addRequired(p,'objectiveVars',@(x) isnumeric(x) && ismatrix(x) &&...
    ~isempty(x));

parse(p,nargin,inputPop,tournamentSize,selectionType,selectionProb,...
    objectiveVars);

%% Error Checking 

if selectionType == 0 && tournamentSize > n(1,1)/2
    
    tit=['While selectionType = 0, tournamentSize must be less ',...
        'than or equal to the number of individuals in the input ',...
        'population divided by 2'];
    disp(tit);
    error(['Tournament Size Must be Less than or Equal to One Half ',...
        'the Number of Individuals in the Input Population While ',...
        'selectionType = 0']);
end 

%% Iteration Parameters

m = 1:1:n(1,1);
outputPop = zeros(tournamentSize,n(1,2));
outputPopFitness = zeros(tournamentSize,1);
individuals = zeros(2,n(1,2));
fitness = zeros(2,1);

%% Initiate Tournament Selection

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

for i = 1:tournamentSize
    
    individuals(1,:) = inputPop(pairs(i,1),:);
    individuals(2,:) = inputPop(pairs(i,2),:);
    fitness(1,1) = sum(fitnessFnc(individuals(1,:),objectiveVars));
    fitness(2,1) = sum(fitnessFnc(individuals(2,:),objectiveVars));
    [ranking, index] = sort(fitness,1,'ascend');
    val = rand(1);
    
    if val <= selectionProb
        
        outputPop(i,:) = individuals(index(1),:);
        outputPopFitness(i,1) = ranking(1,1);
        
    elseif val > selectionProb
        
        outputPop(i,:) = individuals(index(2),:);
        outputPopFitness(i,1) = ranking(2,1);
        
    end
    
end
            
end