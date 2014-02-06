function [ outputPop ] = singlePartConvexWalkFnc( popSize, sourceIndex,...
                                                    destinIndex, gridMask )                                                 
%
% singlePartConvexWalkFnc.m Initializes the creation of a population where
% the search domain is sufficiently small that each walk has only a single
% part and also, the relationship between the source and the destination
% within the search domain indicates that a euclidean shortest path 
% basis solution is convex
%
% DESCRIPTION:
%
%   Function that initializes a set of walk pathways of desired size for a
%   solution space that is both small and convex with respect to the
%   orientation between the source index and the destination index
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputPop ] =  singlePartConvexWalkFnc( popSize, sourceIndex,...
%                       destinIndex, gridMask );
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
%   gridMask =          [n x m] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zeros
%
% OUTPUTS:
%
%   outputPop =        [j x k] double array containing the grid index 
%                       values of the individuals within the population 
%                       (Note: each individual corresponds to a connected 
%                       pathway from the source to the destination grid 
%                       cells within the study area)
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
%%%               University of California Santa Barbara                 %%
%%%                            February 2014                             %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x)...
    x == 4);
addRequired(p,'nargout',@(x)...
    x == 1);
addRequired(p,'popSize',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    rem(x,1) == 0 &&...
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
    isrow(x) && ~isempty(x)...
    && rem(x(1,1),1) == 0 &&...
    rem(x(1,2),1) == 0);
addRequired(p,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(p,nargin,nargout,popSize,sourceIndex,destinIndex,gridMask);

%% Function Parameters

plot = 0;
pS = popSize;
sD = pdist([sourceIndex; destinIndex]);
gL = ceil(5*sD);
outputPop = zeros(pS,gL);

%% Generate Output

w = waitbar('Generating Walks');

for i = 1:pS
    
    outputPop(i,:) = pseudoRandomWalkFnc(gridMask,sourceIndex,...
        destinIndex,plot);
    
    % Display Function Progress

    perc = i/pS;
    waitbar(perc,w,[num2str(perc*100),'% Completed...']);
    
end

close(w);

end