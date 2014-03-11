function [ child ] = crossoverFnc(  parent1,...
                                    parent2,...
                                    sourceIndex,...
                                    destinIndex,...
                                    crossoverType,...
                                    gridMask )

% crossoverFnc generates a child pathway from the single or double point 
% crossover of two previously selected parent pathways.
%
% DESCRIPTION:
%
%   Function to randomly selects valid crossover sites for the production
%   of a new child pathway from a set of two previously selected parent 
%   pathways.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ child ] =  crossoverFnc( parent1, parent2, sourceIndex,...
%                               destinIndex, crossoverType, gridMask )
%
% INPUTS:
%
%   parent1 =       [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source 
%                   to a specified target destination given the constraints
%                   of a specified study region
%
%   parent2 =       [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   sourceIndex =   [i j] index value of the source node for each parent
%
%   destinIndex =   [p q] index value of the destination node for each
%                   parent
%   
%   crossoverType = [0|1] binary scalar in which specifies one of two
%                   possible cases:
%                       Case 0: Single Point Crossover
%                       Case 1: Double Point Crossover
%
%   gridMask =      [q x s] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   child =         [1 x m] array containing the index values of the 
%                   childPathways produced as a result of the signle point 
%                   crossover operation (p = floor(s*n))
%   
% EXAMPLES:
%   
%   Example 1 =
%
%                   % Pass 'parent1' and 'parent2' input arguments as 
%                   output arguments from 'tournamentFnc'
%
%                   crossoverType = 1;
%
%                   child = crossoverFnc(parent1,parent2,sourceIndex,...
%                                           destinIndex,crossoverType,...
%                                           gridMask);
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
    x == 6);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'parent1',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'parent2',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'sourceIndex',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'destinIndex',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'crossoverType',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,parent1,parent2,sourceIndex,destinIndex,...
    crossoverType,gridMask);

%% Function Parameters

gS = size(gridMask);
n = size(parent1);
child = zeros(1,n(1,2));
sourceInd = sub2ind(gS,sourceIndex(1,1),sourceIndex(1,2));
destinInd = sub2ind(gS,destinIndex(1,1),destinIndex(1,2));

%% Extract Parent Data

p1 = parent1(any(parent1,1));
p2 = parent2(any(parent2,1));

[cx,cxPt1,cxPt2] = intersect(p1(2:end-1),p2(2:end-1),'stable');
cxSize = size(cx);

%% Check for Crossover Sites and Initiate Crossover

switch crossoverType
    
    case 0
        
        if cxSize(1,2) < 1
            
            child = [];
            
        elseif cxSize(1,2) == 1
            
            cxSel = cxSize(1,2);
            section1 = p1(1,1:cxPt1(cxSel));
            section2 = p2(1,cxPt2(cxSel)+1:end);
            sections = horzcat(section1,section2);
            sizeST = size(sections);
            child(1,2:sizeST(1,2)+1) = sections;
            child(1,1) = sourceInd;
            child(1,sizeST(1,2)+2) = destinInd;
            
        elseif cxSize(1,2) > 1
            
            cxSel = randi(cxSize(1,2));
            section1 = p1(1,1:cxPt1(cxSel));
            section2 = p2(1,cxPt2(cxSel)+1:end);
            sections = horzcat(section1,section2);
            sizeST = size(sections);
            child(1,2:sizeST(1,2)+1) = sections;
            child(1,1) = sourceInd;
            child(1,sizeST(1,2)+2) = destinInd;
            
        end
        
    case 1
        
        if cxSize(1,2) < 2
            
            child = [];
            
        elseif cxSize(1,2) == 2
            
            cxSel1 = 1;
            cxSel2 = 2;
            section1 = p1(1,1:cxPt1(cxSel1));
            section2 = p2(1,cxPt2(cxSel1)+1:cxPt2(cxSel2));
            section3 = p1(1,cxPt1(cxSel2)+1:end);
            sections = horzcat(section1,section2,section3(1,2:end));
            sizeST = size(sections);
            child(1,2:sizeST(1,2)+1) = sections;
            child(1,1) = sourceInd;
            child(1,sizeST(1,2)+2) = destinInd;
            
        else
            
            mid = ceil(cxSize(1,2)/2);
            cxSel1 = randi(mid);
            cxSel2 = randi([mid+1, cxSize(1,2)]);
            section1 = p1(1,1:cxPt1(cxSel1));
            section2 = p2(1,cxPt2(cxSel1)+1:cxPt2(cxSel2));
            section3 = p1(1,cxPt1(cxSel2)+1:end);
            sections = horzcat(section1,section2,section3(1,2:end));
            sizeST = size(sections);
            child(1,2:sizeST(1,2)+1) = sections;
            child(1,1) = sourceInd;
            child(1,sizeST(1,2)+2) = destinInd;
            
        end
        
end

end