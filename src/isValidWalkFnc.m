function [ isValidWalk ] = isValidWalkFnc(  individual, ...
                                            sourceIndex, ...
                                            destinIndex, ...
                                            gridMask )
                                        
% validateWalkFnc.m Checks for walk validity on the basis of destination 
% achievment, continuous walk connectivity, search domain gridMask boundary 
% errors as well as walk cyclicity.
%
% DESCRIPTION:
%
%   Function to determine whether an individual walk is valid on the basis
%   of pathway connectivity as well as 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ isValidWalk ] =  isValidWalkFnc(  individual, ...
%                                       sourceIndex, ...
%                                       destinIndex, ...
%                                       gridMask )
%
% INPUTS:
%
%   individual =    [1 x m] array of grid cell indices corresponding to a
%                   connected pathway linking some source to some
%                   destination within the search domain specified in the
%                   binary input gridMask
%
%   sourceIndex =   [i x j] index value of the source node for the
%                   start of the pseudo random walk
%
%   destinIndex =   [p x q] index value of the destination node for
%                   the termination of the pseudo random walk
%
%   gridMask =      [q x s] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   isValidWalk =   [0 | 1] binary decision variable indicating whether or
%                   not the input individual constitutes a valid walk
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
    x == 4);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'individual',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'sourceIndex',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    size(x,1) == 1 && ...
    size(x,2) == 2 && ...
    ~isempty(x));
addRequired(P,'destinIndex',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    size(x,1) == 1 && ...
    size(x,2) == 2 && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,individual,sourceIndex,destinIndex,gridMask);

%% Function Parameters

gS = size(gridMask);
wI = any(individual,1);
aI = individual(wI);
isValidWalk = 1;
pathLen = size(aI,2);

%% Check Grid Mask Intersection

gridMaskVals = gridMask(aI);

%% Check Cyclicity

uniqueVals = unique(aI);
sizeUnique = size(uniqueVals,2);

%% Check Destination

pathEnd = aI(1,end);
destin = sub2ind(gS,destinIndex(1,1),destinIndex(1,2));

%% Check Connectivity

pathGrid = zeros(gS);
pathGrid(aI) = 1;
connComp = bwconncomp(pathGrid);
connectivity = connComp.NumObjects == 1;

%% Evaluate Checks

if all(gridMaskVals) ~= 1
    
    isValidWalk = 0;
    disp('Grid Mask Error');
    
elseif sizeUnique ~= pathLen
    
    isValidWalk = 0;
    disp('Cyclicity Error');
    
elseif pathEnd ~= destin
    
    isValidWalk = 0;
    disp('Destination Error');
    
elseif connectivity ~= 1
    
    isValidWalk = 0;
    disp('Connecivity Error');
    
end

end