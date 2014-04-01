function [ topCentroidsMask, topCentroidsCount ] = topCentroidsMaskFnc(...
                                                        objectiveVars,...
                                                        objectiveFrac,...
                                                        minClusterSize,...
                                                        gridMask )
%
% topCentroidsMaskFnc.m Generates a mask layer containg the centroids of 
% contiguous regions of grid cells whose various objective scores are 
% below some user specified threshold quantile
%
% DESCRIPTION:
%
%   Function that generates clusters of low valued objective
%   scores and computes their centroids. These centroids are then delivered
%   as a mask layer out for use in conjunction with other functions in the
%   population initialization procedure. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ topCentroidsMask, topCentroidsCount ] =   topCentroidsFnc(...
%                                               objectiveVars,...
%                                               objectiveFrac,...
%                                               minClusterSize,...
%                                               gridMask );
%
% INPUTS:
%
%   objectiveVars =     [n x m x g] array in which the first two dimensions
%                       correspond to the spatial dimensions of the grid
%                       mask and the third dimension corresponds to the
%                       number of objective variables.
%
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
%                       cells with low objective score values accross all 
%                       of the different objectives.
%
%   topCentroidsCount = [f] scalar value indicating the number of unique
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
%%%                 University of California Santa Barbara               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x)...
    x == 4);
addRequired(P,'nargout',@(x)...
    x == 2);
addRequired(P,'objectiveVars',@(x)...
    isnumeric(x) &&...
    numel(size(x)) >= 2 &&...
    ~isempty(x));
addRequired(P,'objectiveFrac',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    rem(x,1) ~= 0 &&...
    x <= 1 &&...
    x >= 0 &&...
    ~isempty(x));
addRequired(P,'minClusterSize',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    rem(x,1) == 0 &&...
    x > 0 &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,objectiveVars,objectiveFrac,minClusterSize,...
    gridMask);

%% Function Parameters

gS = size(gridMask);
oC = size(objectiveVars);

%% Compute Aggregate Objective Scores and Mask Out Top Fraction

rowLen = gS(1,1).*gS(1,2);
topCentroidsInd = cell(oC(1,3),1);

for i = 1:oC(1,3)
    
    % Extract Top Objective Variable Fraction Mask
    
    objVars = reshape(objectiveVars(:,:,i),rowLen,1);
    fracQuant = quantile(objVars,objectiveFrac,1);
    fracInd = objVars <= fracQuant;
    topFracMask = reshape(fracInd,gS(1,1),gS(1,2));
    
    % Compute Connected Area Centroids for Each Objective Variable
    
    bw = bwconncomp(topFracMask);
    rg = regionprops(bw,'centroid','area');
    rgCell = struct2cell(rg)';
    rgArea = cell2mat(rgCell(2:end,1));
    rgCentroid = fliplr(floor(cell2mat(rgCell(2:end,2))));
    rgAreaCentroid = horzcat(rgArea,rgCentroid);
    
    % Sort Centroids by Connected Area Size
    
    rgSort = flipud(sortrows(rgAreaCentroid,1));
    topCentroids = rgSort(rgSort(:,1) >= minClusterSize,2:3);
    topCentroidsInd{i,1} = sub2ind(gS,topCentroids(:,1),topCentroids(:,2));
    
end

topCentroidsInd = unique(cell2mat(topCentroidsInd));

%% Generate Output

topCentroidsMask = zeros(gS);
topCentroidsCount = numel(topCentroidsInd);
topCentroidsMask(topCentroidsInd) = 1;

end