function [ convexAreaMask ] = convexAreaMaskFnc( sourceIndex, gridMask )
% 
% convexAreaFnc.m Generates a binary mask of grid cells that are convex 
% relative to a user specified source index and irregularly shaped search
% boundary
%
% DESCRIPTION: 
%
% Function to compute a binary mask of grid cells containing the portion of
% an irrgegular polygonal area that is convex to a user specified source.
% This function iteratively applies a modified version of bresenham's 
% shortest euclidean path algorithm to enumerate the grid cells that are
% convex to the source. 
%
% SYNTAX:
%
% [ convexAreaMask ] =  convexAreaFnc( gridMask, sourceIndex )
%
% INPUTS:
%
% gridMask =        [n x m] binary array with valid pathway grid cells
%                   labeled as zeros and invalid pathway grid cells labeled
%                   as NaN placeholders
%
% sourceIndex =     [i,j] index value of the source node for to be used as
%                   the reference point for determining the convex area 
%                   mask.
%                   
% OUTPUTS:
%
% convexAreaMask =  [n x m] binary array with the area which is convex to 
%                   the user specified source location labeled as zeros and
%                   the rest of the domain labeled as NaN placeholders
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
%
%                       convexAreaMask = convexAreaFnc(gridMask,...
%                                                       sourceIndex);
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

%% Development Notes

% Something is wrong with this convex area function. It only works with
% certain sourceIndex inputs. I need to figure out what the problem is
% before we can move forward. It may have to do with the attempted speed up
% procedure involving limiting the search domain to only the cells at the
% perimeter of the gridMask. MORE INVESTIGATION NEEDED.

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin', @(x) x == 2);
addRequired(p,'sourceIndex', @(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'gridMask', @(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,sourceIndex,gridMask);

%% Iteration Parameters

gS = size(gridMask);
perimeter = bwperim(gridMask);
perimeter = bwmorph(perimeter,'thicken',2);
perimeter = bwmorph(perimeter,'diag');
perimeter = perimeter.*gridMask;
perimeter(sourceIndex(1,1),sourceIndex(1,2)) = 0;
[Xdestin, Ydestin, ~] = find(perimeter);
iter = size(Xdestin,1);
convexAreaMask = zeros(gS);

%% Determine Steepness and Generate Paths

for i = 1:iter
    
    dX = abs(Xdestin(i)-sourceIndex(1,1));
    dY = abs(Ydestin(i)-sourceIndex(1,2));
    steep = abs(dY) > abs(dX);
    
    if steep
        
        t = dX;
        dX = dY;
        dY = t;
        
    end
    
    % Generate Non-Steep Path
    
    if dY == 0
        
        q = zeros(dX+1,1);
        
    else
        
        q = [0; diff(mod((floor(dX/2):-dY:-dY*dX+floor(dX/2))',dX)) >= 0];
        
    end
    
    % Generate Steep Path
    
    if steep
        
        if sourceIndex(1,2) <= Ydestin(i)
            
            y = (sourceIndex(1,2):Ydestin(i))';
            
        else
            
            y = (sourceIndex(1,2):-1:Ydestin(i))';
            
        end
        
        if sourceIndex(1,1) <= Xdestin(i)
            
            x = sourceIndex(1,1)+cumsum(q);
            
        else
            
            x = sourceIndex(1,1)-cumsum(q);
            
        end
        
    else
        
        if sourceIndex(1,1) <= Xdestin(i)
            
            x = (sourceIndex(1,1):Xdestin(i))';
            
        else
            
            x = (sourceIndex(1,1):-1:Xdestin(i))';
            
        end
        
        if sourceIndex(1,2) <= Ydestin(i)
            
            y = sourceIndex(1,2)+cumsum(q);
            
        else
            
            y = sourceIndex(1,2)-cumsum(q);
            
        end
        
    end
    
    % THE PROBLEM STARTS HERE....SOMEWHERE????
    
    pathInd = sub2ind(gS,x,y);
    pathZeros = gridMask(pathInd);
    isUnbrokenPath = all(pathZeros,1);
    
    if isUnbrokenPath == 1
        
        convexAreaMask(sub2ind(gS,x,y)) = 1;
        
    elseif isUnbrokenPath == 0
        
        pathZeroInd = find(pathZeros);
        convexAreaMask(sub2ind(gS,x(1:pathZeroInd(1,1)-1,:),...
            y(1:pathZeroInd(1,1)-1,:))) = 1;
        
    end

end

end