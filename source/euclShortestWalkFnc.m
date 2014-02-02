function [ individual ] = euclShortestWalkFnc( gridMask, sourceIndex,...
                        destinIndex )
% 
% euclShortestWalkFnc.m Generate pathway index values for a euclidean 
% shortest path on a grid according to Bresenham's Algorithm 
%
%% DESCRIPTION: 
%
% Function to compute and store the grid cell indices of the euclidean 
% shortest path between a source and destination point within a regular
% gridded domain.
%
%% SYNTAX:
%
% [ individual ] =  euclShortestWalk( gridMask, sourceIndex, destinIndex )
%
%% INPUTS:
%
% gridMask =        [n x m] binary array with valid pathway grid cells
%                   labeled as ones and invalid pathway grid cells labeled
%                   as NaN placeholders
%
% sourceIndex =     [i,j] index value of the source node for the
%                   start of the pseudo random walk
%
% destinIndex =     [p,q] index value of the destination node for
%                   the termination of the pseudo random walk
%
%% OUTPUTS:
%
% individual =      [1 x j] array with the index values of the pathway
%                   from the source to the desintation node computed from
%                   the random walk process.
%
%% EXAMPLES:
%
%   Example 1:
%
%   
%% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%                University of California Santa Barbara                %%
%%%                             January 2014                             %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin', @(x) x == 3);
addRequired(p,'gridMask', @(x) isnumeric(x) && ismatrix(x) && ~isempty(x));
addRequired(p,'sourceIndex', @(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'destinIndex', @(x) isnumeric(x) && isrow(x) && ~isempty(x));

parse(p,nargin,gridMask,sourceIndex,destinIndex);

%% Error Checking

if destinIndex == sourceIndex
    tit='Source Cannot be the Same as Destination';
    disp(tit);
    error('Source Cannot be the Same as Destination');
end

%% Iteration Parameters

x1 = sourceIndex(1,2);
x2 = destinIndex(1,2);
y1 = sourceIndex(1,1);
y2 = destinIndex(1,1);

%% Determine Steepness

dx=abs(x2-x1);
dy=abs(y2-y1);
steep=abs(dy)>abs(dx);

if steep 
    t=dx;
    dx=dy;
    dy=t; 
end

%% Generate Non-Steep Path

if dy==0 
    q=zeros(dx+1,1);
else
    q=[0;diff(mod([floor(dx/2):-dy:-dy*dx+floor(dx/2)]',dx))>=0];
end

%% Generate Steep Path

if steep
    if y1<=y2 
        y=[y1:y2]'; 
    else
        y=[y1:-1:y2]'; 
    end
    if x1<=x2 
        x=x1+cumsum(q);
    else
        x=x1-cumsum(q);
    end
else
    if x1<=x2 
        x=[x1:x2]'; 
    else
        x=[x1:-1:x2]'; 
    end
    if y1<=y2 
        y=y1+cumsum(q);
    else
        y=y1-cumsum(q); 
    end
end

%% Generate Final Ouput

a = size(gridMask);
individual = sub2ind(a,y,x)';

end