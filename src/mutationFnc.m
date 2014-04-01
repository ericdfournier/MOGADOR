function [ mutant ] = mutationFnc( individual, gridMask )

% mutationFnc Function to generate a single or multi-point mutation of an
% of an individual pathway
%
% DESCRIPTION:
%
%   Function to generate a single point mutation which obeys the 8 way
%   connectivity rule for individual pathways from some population
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   mutant =  mutationFnc( individual, gridMask )
%
% INPUTS:
%
%   individual =    [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   gridMask =      [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   mutant =        [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
% EXAMPLES:
%   
%   Example 1 =         
%
%                   n = 100;
%                   gridMask = zeros(n);
%                   gridMask(:,1) = nan;
%                   gridMask(1,:) = nan;
%                   gridMask(end,:) = nan;
%                   gridMask(:,end) = nan;
%
%                   sourceIndex = [20 20];
%                   destinIndex = [80 80];
%                   objectiveVars = randi([0 10],10000,3);
%                   objectiveFrac = 0.10;
%                   minClusterSize = 5;
%                   popSize = 1;
%
%                   [individual, popParams] = initPopFnc(...
%                                       popSize,objectiveVars,...
%                                       objectiveFrac,minClusterSize,...
%                                       sourceIndex,destinIndex, gridMask);
%
%                   mutant = mutationFnc(individual,gridMask);
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
    x == 2);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'individual',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,individual,gridMask);

%% Iteration Parameters

indiv = individual(any(individual,1));
gL = size(indiv,2);
gS = size(gridMask);
indivMask = zeros(gS);
indivMask(indiv) = 1;

%% Select Mutation Sites and Generate Mutations

validMutSite = 1;

while validMutSite == 1
    
    mutSel = randsample(2:1:gL-1,1);
    mutInd = indiv(1,mutSel);
    mutRange = indiv((mutSel-1):(mutSel+1));
    
    neighSub = zeros(9,2);
    newMut = cell(1,1);
    
    [j,k] = ind2sub(gS,mutInd);
    neighSub(1,:) = [j-1,k-1];
    neighSub(2,:) = [j-1,k];
    neighSub(3,:) = [j-1,k+1];
    neighSub(4,:) = [j,k-1];
    neighSub(5,:) = [j,k];
    neighSub(6,:) = [j,k+1];
    neighSub(7,:) = [j+1,k-1];
    neighSub(8,:) = [j+1,k];
    neighSub(9,:) = [j+1,k+1];
    neighInd = sub2ind(gS,neighSub(:,1),neighSub(:,2));
    
    [~, B, C] = intersect(mutRange, neighInd);
    sdMask = zeros(3);
    sdMask(C(B == 1)) = 1;
    sdMask(C(B == 3)) = 1;
    
    % Check for Deletion Mutation Validity
    
    sdConn = bwconncomp(sdMask,8);
    
    if sdConn.NumObjects == 1
        
        tryMut = [];
        break
        
    end
    
    % Eliminate Invalid Mutation Sites and Iteratively Select Candidates
    
    allMask =  reshape(indivMask(neighInd),[3 3]);
    choices = find(allMask == 0);
    
    viableMut = 0;
    mutCount = 0;
    mutSDMask = sdMask;
    
    s = 0;
    
    while viableMut == 0
        
        s = s + 1;
        
        if s == 10;
            
            validMutSite = 0;
            
            break
        
        elseif nnz(sdMask) == numel(sdMask)
            
            validMutSite = 0;
            
            break
            
        elseif isempty(choices) == 1
            
            validMutSite = 0;
            
            break
            
        end
        
        mutCount = mutCount + 1;
        mutChoice = randomsample(choices,1);
        mutSDMask(mutChoice) = 1;
        mutTest = bwconncomp(mutSDMask);
        
        if mutTest.NumObjects == 1
            
            viableMut = 1;
            
        end
        
    end
    
    % Generate Mutation Site Indices
    
    newMutSite = reshape(sdMask == 0 & mutSDMask == 1,[9 1]);
    tryMut = neighInd(newMutSite);

end 

newMut{1,1} = tryMut';

%% Insert New Mutations into Individual

sections = cell(2,2);
z = vertcat(1,mutSel,gL);

sections{1,1} = indiv(1,z(1):z(2)-1);
tmp = size(sections{1,1});
sections{1,2} = tmp(1,2);

sections{2,1} = indiv(1,z(2)+1:z(3));
tmp = size(sections{2,1});
sections{2,2} = tmp(1,2);

mutantRaw = horzcat(sections{1,1},newMut{1,1},sections{2,1});

%% Generate Final Output

x = size(individual);
mutant = zeros(x);
v = size(mutantRaw);
mutant(1,1:v(1,2)) = mutantRaw;

end