function [ output ] = epigeneticSmoothingFnc(   individual,...
                                                objectiveVars,...
                                                gridMask )
% epigeneticSmoothingFnc.m performs epigenetic smoothing to an input
% individual from a final stage population. This smoothing procedure
% involves an iterative neighborhood search procedure which operates along
% the length of the input individual. 
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
%   [ output ] =  epigeneticSmoothingFnc( individual, objectiveVars,...
%                                           gridMask )
%
% INPUTS:
%
%   individual =    [1 x m] array of grid cell indices corresponding to a
%                   connected pathway linking some source to some
%                   destination within the search domain specified in the
%                   binary input gridMask
%
%   objectiveVars = [q x s x k] three dimensional array in which the first
%                   two dimensions correspond to the spatial dimensions 
%                   depicted in the gridMask search domain input and the
%                   values in the third dimension correspond to the scores
%                   for one or more objective variables used in the
%                   analysis
%
%   gridMask =      [q x s] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   individual =    [1 x m] array containing the index values of the 
%                   childPathways produced as a result of the signle point 
%                   epigenetic smoothing procedure
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

P = inputParser;

addRequired(P,'nargin',@(x)...
    x == 3);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'individual',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'objectiveVars',@(x)...
    isnumeric(x) &&...
    numel(size(x)) == 3 &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,individual,objectiveVars,gridMask);

%% Function Parameters

gS = size(gridMask);
gL = size(individual,2);
indiv = individual(any(individual,1));
pL = size(indiv,2);
output = zeros(1,gL);
nodeList = cell(1,3);

%% Generate Sorted Node Lists

nodeList{1,1} = indiv(1,1);
nodeList{1,3} = indiv(1,end);

indivMask = zeros(gS);
indivMask(indiv) = 1;

tmp = bwmorph(indivMask,'diag');
tmp = bwmorph(tmp,'thicken',5);
tmp = bwmorph(tmp,'majority');
tmp = bwmorph(tmp,'close');
tmp = bwmorph(tmp,'skel',Inf);
tmp = bwmorph(tmp,'spur');
nodeMask = bwmorph(tmp,'branch');
nodeInd = find(nodeMask);

nM = size(nodeInd,1);
unsortedNodes = zeros(1,nM);

for i = 1:nM
    
   [~,I] = min(abs(nodeInd(i)-indiv));
   unsortedNodes(i) = indiv(I);
   
end

[~, ~, sortInd] = intersect(unsortedNodes,indiv);
sortedNodes = indiv(sortInd);
nodeList{1,2} = sortedNodes;
nodes = [nodeList{:,:}];

%% Generate Epigenetic Replicates Using Modified Ramer-Douglas-Peucker

sN = size(nodes,2);
sections = cell(1,sN-1);

for k = 1:(sN-1)
    
    [sourceRow, sourceCol] = ind2sub(gS,nodes(1,k));
    sourceIndex = [sourceRow, sourceCol];
    
    [destinRow, destinCol] = ind2sub(gS,nodes(1,k+1));
    destinIndex = [destinRow, destinCol];
    
    if sourceIndex(1,1) == destinIndex(1,1) &&...
            sourceIndex(1,2) == destinIndex(1,2)
        
        sections{1,k} = [];
        
    else
        
        sections{1,k} = euclShortestWalkFnc(...
            sourceIndex,...
            destinIndex,...
            gridMask);
    end
    
end

choice = [sections{1,:}];
choice = choice(any(choice,1));

%% Evaluate Fitness of Replicates

indivFitness = sum(fitnessFnc(individual,objectiveVars,gridMask),2);
choiceFitness = sum(fitnessFnc(choice,objectiveVars,gridMask),2);

%% Generate Output

if indivFitness <= choiceFitness
    
    output = individual;
    disp('No Fitness Improvement, Individual Returned');
    
else 
    
    sC = size(choice,2);
    output(1,1:sC) = choice;

end

end