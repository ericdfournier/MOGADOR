function [ sourceShadowMask ] = sourceShadowMaskFnc( sourceIndex,...
                                                        destinIndex,...
                                                        gridMask )
% 
% sourceShadowMaskFnc.m Function to compute the grid cell mask containing
% only those cells that are situated along the same orientation as the
% relationship between the source and the destination.
%
% DESCRIPTION: 
%
% Function to compute the set of grid cells that are situated in the shadow
% of the source with respect to the destination as determined by their
% relative positions within the gridMask domain. 
%
% SYNTAX:
%
%   [ sourceShadowMask ] =  sourceShadowMask( gridMask,...
%                               topCentroidsMask, sourceIndex,...
%                               destinIndex, method )
%
% INPUTS:
%
%   gridMask =          [n x m] binary array with valid pathway grid cells
%                       labeled as zeros and invalid pathway grid cells 
%                       labeled as NaN placeholders
%
%   sourceIndex =       [i,j] index value of the source node for to be used
%                       as the reference point for determining the convex 
%                       area mask
%
%   destinIndex =       [1 x 2] array with the subscript indices of the
%                       destination location within the study area for 
%                       which the paths are to be evaluated
%                   
% OUTPUTS:
%
%   sourceShadowMask =  [n x m] binary array with the valid search domain 
%                       as determined by the relatives position of the
%                       source node to the destination node, indexed as 1's
%                       the remaining area within the search domain as 0's
%                       and the rest of the gridMask area labeled as NaN
%                       placeholders
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
%
%                       sourceIndex = [20 20];
%                       destinIndex = [80 80];
%
%                       sourceShadowMask = sourceShadowMaskFnc(...
%                                           sourceIndex,destinIndex,...
%                                           gridMask);
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

addRequired(p,'nargin', @(x) x == 3);
addRequired(p,'sourceIndex', @(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'destinIndex', @(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'gridMask', @(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,sourceIndex,destinIndex,gridMask);

%% Function Parameters

gS = size(gridMask);

%% Generate Source Shadow Mask
    
orientation = -sign(sourceIndex-destinIndex);
sourceShadowMask = zeros(gS);

switch orientation(1,1)
    
    case -1
        
        switch orientation(1,2)
            
            case -1
                
                sourceShadowMask...
                    (1:sourceIndex(1,1),...
                    1:sourceIndex(1,2)) = 1;
                
            case 0
                
                sourceShadowMask...
                    (:,1:sourceIndex(1,2)) = 1;
                
            case 1
                
                sourceShadowMask...
                    (sourceIndex(1,1):end,...
                    1:sourceIndex(1,2)) = 1;
                
        end
        
    case 0
        
        switch orientation(1,2)
            
            case -1
                
                sourceShadowMask...
                    (1:sourceIndex(1,1),:) = 1;
                
            case 1
                
                sourceShadowMask...
                    (sourceIndex(1,1):end,:) = 1;
                
        end
        
    case 1
        
        switch orientation(1,2)
            
            case -1
                
                sourceShadowMask...
                    (1:sourceIndex(1,1),...
                    sourceIndex(1,2):end) = 1;
                
            case 0
                
                sourceShadowMask...
                    (:,sourceIndex(1,2):end) = 1;
                
            case 1
                
                sourceShadowMask...
                    (sourceIndex(1,1):end,...
                    sourceIndex(1,2):end) = 1;
                
        end
        
end

end