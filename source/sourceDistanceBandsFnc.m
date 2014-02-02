function [ sourceDistanceBands, bandLabels ] = sourceDistanceBandsFnc(...
                                                sourceIndex, gridMask )
% 
% sourceDistanceBandsFnc.m 
%
% DESCRIPTION: 
%
% Function to compute 
%
% SYNTAX:
%
%   sourceDistanceBands =  sourceDistanceBandsFnc( sourceIndex,...
%                                                       gridMask );
%
% INPUTS:
%                           
%   sourceIndex =           [i j] index value of the source node for to be 
%                           used as the reference point for determining the 
%                           convex area mask
%
%   gridMask =              [n x m] binary array with valid pathway grid 
%                           cells labeled as zeros and invalid pathway grid  
%                           cells labeled as NaN placeholders
%                   
% OUTPUTS:
%
%   sourceDistanceBands =   [n x m] binary array
%
%   bandLabels =            [r] scalar value
%
% EXAMPLES:
%
%   Example 1:  
%
%                       gridMask = zeros(100);
%                       gridMask(:,1) = nan;
%                       gridMask(1,:) = nan;
%                       gridMask(end,:) = nan;
%                       gridMask(:,end) = nan;
%                       sourceIndex = [20 20];
%                       [sourceDistanceBands, bandLabels] = ...
%                                           sourceDistanceBandsFnc(...
%                                           sourceIndex,gridMask);
%   
% CREDITS:
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

addRequired(p,'nargin', @(x) x == 2);
addRequired(p,'nargout', @(x) x == 2);
addRequired(p,'sourceIndex', @(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'gridMask', @(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,nargout,sourceIndex,gridMask);

%% Function Parameters

gS = size(gridMask);
sourceMask = zeros(gS);
sourceMask(sourceIndex(1,1),sourceIndex(1,2)) = 1;

%% Compute Distances

sourceDist = bwdist(sourceMask);
maxDist = ceil(max(max(sourceDist)));

%% Compute Band Intervals

bandWidth = 142;
bandInt = (0:bandWidth:maxDist);
bS = size(bandInt,2);

%% Label Bands

sourceDistanceBands = zeros(gS);
bandLabels = (1:1:bS-1);

for i = 1:bS-1
    currentBand = sourceDist > bandInt(1,i) & sourceDist <= bandInt(1,i+1);
    sourceDistanceBands(currentBand) = bandLabels(i);
end

end