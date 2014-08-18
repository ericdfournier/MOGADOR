function [ mutant ] = mutationFnc(  individual,...
                                    randomness,...
                                    gridMask )

% mutationFnc Function to generate a single-point mutation on an individual
% pathway
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
%   mutant =  mutationFnc(  individual,...
%                           gridMask )
%
% INPUTS:
%
%   individual =    [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   randomness =    [h] a value > 0 indicating the degree of randomness
%                   to be applied in the process of generating the 
%                   walk. Specifically, this value corresponds to  the 
%                   degree of the root that is used to compute the 
%                   covariance from the minimum basis distance at each 
%                   movement iteration along the path. Higher numbers 
%                   equate to less random paths.
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
    x == 3);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'individual',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'randomness',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,individual,randomness,gridMask);

%% Iteration Parameters

validSite = 0;

while validSite == 0;

    indiv = individual(any(individual,1));
    aI = size(indiv,2);
    gS = size(gridMask);
    indivMask = gridMask;
    indivMask(indivMask == 0) = NaN;
    indivMask(indivMask == 1) = 0;
    indivMask(indiv) = 1;
    
    % Select Mutation Sites
    
    mutSel = randsample(5:1:aI-5,1);
    mutInd = indiv(1,mutSel);
    mutRange = indiv(mutSel-1:mutSel+1);
    neighSub = zeros(9,2);
    newMut = cell(1,1);
    
    % Generate mutation site neighborhood
    
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
    neighMask = reshape(indivMask(neighInd),[3 3]);
    
    % Find and sort nearest path neighbors
    
    [~, B, C] = intersect(mutRange, neighInd);
    sdMask = zeros(3);
    
    for i = 1:size(B)
        
        sdMask(C(i)) = B(i);
        
    end
    
    rankMask = sdMask ./ min(B);
    
    % Generate mutation using pseudo random walk on sub grid mask
    
    sourceDestinMask = zeros(5,5);
    sourceDestinMask(2:4,2:4) = rankMask;
    
    [x1, y1] = find(sourceDestinMask == 1);
    subSourceInd = [x1 y1];
    
    [x2, y2] = find(sourceDestinMask == 3);
    subDestinInd = [x2 y2];
    
    if isempty(subDestinInd)
        
        validSite = 0;
        continue;
   
    end
    
    subGridMask = zeros(5,5);
    subGridMask(2:4,2:4) = ...
        double(imcomplement(rankMask ~= 0 )) == 1 & ...
        neighMask == 0 & ...
        reshape(~isnan(indivMask(neighInd)),[3 3]) == 1 | ...
        rankMask == 1 | ...
        rankMask == 3;
    
    tryMutRawMask = zeros(5,5);
    tryMutRawInd = pseudoRandomWalkFnc(subSourceInd,subDestinInd,...
        randomness,subGridMask);
        
        
    tryMutRawInd(1,1) = 0;
    tryMutRawInd = tryMutRawInd(any(tryMutRawInd,1));
    tryMutRawSize = size(tryMutRawInd,2);
    
    if tryMutRawSize < 1 
        
        validSite = 0;
        
    else
        
        validSite = 1;
       
    end

end

%% Generate mutation indices depending on mutation size

if tryMutRawSize == 1
    
    tryMutRawMask(tryMutRawInd) = 1;
    tryMutMask = tryMutRawMask(2:4,2:4);
    tryMutInd = tryMutMask == 1;
    tryMut = neighInd(tryMutInd);
    
    % Generate Final Output
    
    mutant = individual;
    mutant(mutSel) = tryMut;
    
elseif tryMutRawSize > 1
    
    tryMutRawSeq = 1:1:tryMutRawSize;
    
    for i = 1:tryMutRawSize
        
        tryMutRawMask(tryMutRawInd(i)) = tryMutRawSeq(i);
        
    end
    
    tryMutMask = tryMutRawMask(2:4,2:4);
    tryMutMaskVec = reshape(tryMutMask,[9 1]);
    tryMutMaskVecInd = find(tryMutMaskVec);
    [a, b] = sort(tryMutMaskVecInd,'ascend');
    tryMut = zeros(1,tryMutRawSize);
    
    for i = 1:tryMutRawSize
        
        tryMut(1,i) = neighInd(a(b(i)));
        
    end
    
    newMut{1,1} = tryMut;
    
    % Insert New Mutations into Individual
    
    sections = cell(2,2);
    z = vertcat(1,mutSel,aI);
    
    sections{1,1} = indiv(1,z(1):z(2)-1);
    tmp = size(sections{1,1});
    sections{1,2} = tmp(1,2);
    
    sections{2,1} = indiv(1,z(2)+1:z(3));
    tmp = size(sections{2,1});
    sections{2,2} = tmp(1,2);
    
    mutantRaw = horzcat(sections{1,1},newMut{1,1},sections{2,1});
    
    % Generate Final Output
    
    x = size(individual);
    mutant = zeros(x);
    v = size(mutantRaw);
    mutant(1,1:v(1,2)) = mutantRaw;

end

end