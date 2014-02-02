function [ topCentroidsMask ] = topCentroidsMaskFnc( objectiveVars,...
                                                        objectiveFrac,...
                                                        minClusterSize,...
                                                        gridMask )
%
% topCentroidsFnc.m Generates a mask layer containg the centroids of contiguous
% regions of grid cells whose aggregate objective scores are below some
% user specified threshold level
%
% DESCRIPTION:
%
%   Function that generates clusters of low valued aggregate objective
%   scores and computes their centroids. These centroids are then delivered
%   as a mask layer out for use in conjunction with other functions in the
%   population initialization procedure. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ topCentroidsMask, topCentroidsCount ] =  topCentroidsFnc(...
%                                               objectiveVars,...
%                                               objectiveFrac,...
%                                               minClusterSize,...
%                                               gridMask );
%
% INPUTS:
%
%   objectiveVars =     [g x h] array in which each column corresponds to a
%                       decision variable (s) and in which each row 
%                       corresponds to a spatially referenced grid cell 
%                       value (covering the entire search domain)
%
%   objectiveFrac =     [s] scalar value indicating the fraction of the
%                       aggregated objective score values for which 
%                       clusters will be evaluated
%
%   minClusterSize =    [r] scalar value indicating the minimum number of
%                       connected cells (assuming queen's connectivity) 
%                       that are required to consititute a viable cluster
%
%   gridMask =          [n x m] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as NaN placeholders
%
% OUTPUTS:
%
%   topCentroidsMask =  [n x m] binary array masking out the location of
%                       the top centroids of contiguous regions containing 
%                       cells with low aggregate objective score values.
%
% EXAMPLES:
%   
%   Example 1 =
%
%                       gridMask = zeros(100);
%                       gridMask(:,1) = nan;
%                       gridMask(1,:) = nan;
%                       gridMask(end,:) = nan;
%                       gridMask(:,end) = nan;
%
%                       objectiveVars = randi([0 10],...
%                           (size(gridMask,1).*size(gridMask,2)),3);
%                       objectiveFrac = 0.10;
%                       minClusterSize = 5;
%
%                       [topCentroidsMask, topCentroidsCount] = ...
%                                       topCentroidsFnc(objectiveVars,...
%                                       objectiveFrac,minClusterSize,...
%                                       gridMask);
%                                       
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                             January 2014                             %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x) x == 4);
addRequired(p,'nargout',@(x) x == 1);
addRequired(p,'objectiveVars',@(x) isnumeric(x) && ismatrix(x)...
    && ~isempty(x));
addRequired(p,'objectiveFrac',@(x) isnumeric(x) && isscalar(x)...
    && rem(x,1) ~= 0 && x <= 1 && x >= 0 && ~isempty(x));
addRequired(p,'minClusterSize',@(x) isnumeric(x) && isscalar(x)...
    && rem(x,1) == 0 && x > 0 && ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,nargout,objectiveVars,objectiveFrac,...
    minClusterSize,gridMask);

%% Function Parameters

gS = size(gridMask);

%% Compute Aggregate Objective Scores and Mask Out Top Fraction

aggObjectiveVars = sum(objectiveVars,2);
fracCount = objectiveFrac*(gS(1,1)*gS(1,2));
[~, sortInd] = sort(aggObjectiveVars,'ascend');
topFraction = sortInd(1:fracCount,1);
topFracMask = zeros(gS);
topFracMask(topFraction) = 1;

%% Extract Clusters and Rank Centroids

bw = bwconncomp(topFracMask);
rg = regionprops(bw,'centroid','area');
rgCell = struct2cell(rg)';
rgArea = cell2mat(rgCell(2:end,1));
rgCentroid = fliplr(floor(cell2mat(rgCell(2:end,2))));
rgAreaCentroid = horzcat(rgArea,rgCentroid);
rgSort = flipud(sortrows(rgAreaCentroid,1));

%% Extract Top Centroid Clusters

topCentroids = rgSort(rgSort(:,1) >= minClusterSize,2:3);
topCentroidsMask = zeros(gS);
topCentroidsInd = sub2ind(gS,topCentroids(:,1),topCentroids(:,2));

%% Generate Output

topCentroidsMask(topCentroidsInd) = 1;

end