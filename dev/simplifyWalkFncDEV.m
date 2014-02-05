function [individualOut] = simplifyWalkFncDEV( individual, tolerance,...
                                                gridMask)

% simplifyWalkFnc.m Function which recursively executes the Douglas-Peucker
% polyline simplification algorithm to generate a simplified version of an
% input pseudoRandomWalk individual pathway.
%
% DESCRIPTION:
%
%   Uses the recursive Douglas-Peucker line simplification 
%   algorithm to reduce the number of vertices in a piecewise linear curve 
%   according to a specified tolerance. The algorithm is also know as
%   Iterative Endpoint Fit. It works also for polylines and polygons
%   in higher dimensions. In case of nans (missing vertex coordinates) 
%   simplifyWalkFnc assumes that nans separate polylines. As such, the
%   simplifyWalkFnc treats each line separately.
%
%   Warning: Minimal error checking is performed
%
% SYNTAX: 
%   
%   [ individualOut ] = simplifyWalkFnc( individual, tolerance, gridMask )
%
%
% INPUTS:
%
%   individual      = [1 x s] array of grid cell index values corresponding
%                   to a connected pathway from the source to the 
%                   destination grid cells within the study area
%
%   tolerance       = [r] scalar value indicating the tolerance (maximal 
%                   euclidean distance allowed between each new line 
%                   segment and the nearest vertex
%
%   gridMask =      = [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells 
%                   labeled as NaN placeholders
%
% OUTPUTS:
%
%     individualOut = [1 x s] array of grid cell index values corresponding
%                   to a simplified version of the input individual 
%                   connected grid cell pathway 
%
% EXAMPLES:
%
%   Example 1 =  
%
%                       gridMask = zeros(200);
%                       gridMask(:,1) = nan;
%                       gridMask(1,:) = nan;
%                       gridMask(end,:) = nan;
%                       gridMask(:,end) = nan;
%
%                       sourceIndex = [20 20];
%                       destinIndex = [180 180];
%                       objectiveVars = randi([0 10],40000,3);
%                       objectiveFrac = 0.10;
%                       minClusterSize = 5;
%                       popSize = 1;
%
%                       [individual, popParams] = initPopFnc(...
%                                       popSize,objectiveVars,...
%                                       objectiveFrac,minClusterSize,...
%                                       sourceIndex,destinIndex, gridMask);
%
%                       individualOut = simplifyWalkFnc(individual,...
%                                       tolerance,gridMask);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                     Modified From: dpsimplify.m                      %%
%%%                Original Author: Wolfgang Schwanghart                 %%
%%%                     Published: July 13, 2010.                        %%
%%%                 Contact: w.schwanghart[at]unibas.ch                  %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputparser;

addRequired(p,'nargin',@(x) x == 3);
addRequired(p,'individual',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'tolerance',@(x) isnumeric(x) && isscalar(x) && ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,individual,tolerance,gridMask);

%% Iteration Parameters

gS = size(gridMask);
gL = size(individual,2);
[Row,Col] = ind2sub(gS,individual(any(individual,1))');
individual = horzcat(Col,Row);
sizeIndiv = size(individual,1);
dims = size(individual,2);
compare = @(a,b) abs(a-b)/max(abs(a),abs(b)) <= eps;
indivSections = any(isnan(individual),2);
nanExist = any(indivSections);

%% Recursion Case Evaluation

% Single Vertex Case

if sizeIndiv == 1 || isempty(individual);
    
    individualOut = individual;

% Two Vertex Case

elseif sizeIndiv == 2 && ~nanExist;

    if dims == 2;
        
        d = hypot(individual(1,1)-individual(2,1),...
                individual(1,2)-individual(2,2));
        
    else
        
        d = sqrt(sum((individual(1,:)-individual(2,:)).^2));
        
    end
    
    if d <= tolerance;
        
        individualOut = sum(individual,1)/2;

    else
        
        individualOut = individual;
        
    end
    
% Multiple Vertex Case
    
elseif nanExist;
    
    indivSections = ~indivSections;
    sIX = strfind(indivSections',[0 1])' + 1; 
    eIX = strfind(indivSections',[1 0])'; 
 
    if indivSections(end)==true;
        
        eIX = [eIX;sizeIndiv];
        
    end
    
    if indivSections(1);
        
        sIX = [1;sIX];
        
    end
    
    lIX = eIX-sIX+1;   
    c   = mat2cell(individual(indivSections,:),lIX,dims);
    
    if nargout == 2;
        
        individualOut   = cellfun(@(x)...
            dpsimplify(x,tolerance),c,'uniformoutput',false);

    else
        
        individualOut = cellfun(@(x)...
            dpsimplify(x,tolerance),c,'uniformoutput',false);
        
    end
    
    	individualOut = cellfun(@(x)...
        [x;nan(1,dims)],individualOut,'uniformoutput',false);    
        individualOut = cell2mat(individualOut);
        individualOut(end,:) = [];
     
else

ixe = size(individual,1);
ixs = 1;
I = true(ixe,1);

individual = simplifyrec(individual,tolerance,ixs,ixe);
individual = individual(I,:);
sizeLSS = size(individual,1);
sections = cell(sizeLSS-1,1);

% Compute Simplified Line Segments

for i = 1:sizeLSS-1
    
    section = euclShortestWalkFnc(gridMask,individual(i,:),...
        individual(i+1,:));
    sectionRaw = section(any(section,1))';
    
    if i == 1
        
        sections{i,1} = sectionRaw;
    
    elseif i > 1
        
        sections{i,1} = sectionRaw(2:end);
         
    end
    
end

sectionsMat = cell2mat(sections)';

end

%% Eliminate Loops

loopsExist = 1;
iter = 0;
individualOut = zeros(1,gL);

while loopsExist == 1
    
iter = iter + 1;

if iter == 1
    
    uniqueInd = unique(sectionsMat);
    histUniqueInd = hist(sectionsMat,uniqueInd);
    replicateInd = uniqueInd(histUniqueInd > 1);
    
    if any(replicateInd)
        
        currentIndiv = sectionsMat;
        loopsExist = 0;
        
    else
        
        currentRep = sectionsMat == replicateInd(1,1);
        currentRepInd = find(currentRep);
        subSection1 = sectionsMat(1:currentRepInd(1));
        subSection2 = sectionsMat(currentRepInd(2):end);
        currentIndiv = horzcat(subSection1,subSection2);
        loopsExist = 1;
        
    end
    
elseif iter > 1
    
    uniqueInd = unique(currentIndiv);
    histUniqueInd = hist(currentIndiv,uniqueInd);
    replicateInd = uniqueInd(histUniqueInd > 1);
    
    if any(replicateInd)
        
        loopsExist = 0;
        
    else
        
        currentRep = currentIndiv == replicateInd(1,1);
        currentRepInd = find(currentRep);
        subSection1 = currentIndiv(1:currentRepInd(1));
        subSection2 = currentIndiv(currentRepInd(2):end);
        currentIndiv = horzcat(subSection1,subSection2);
        loopsExist = 1;
        
    end
    
end

disp(iter);

end

sizeCI = size(currentIndiv,2);
individualOut(1,1:sizeCI) = currentIndiv;

%% Recursive Line Simplification Function

function individual = simplifyrec(individual,tolerance,ixs,ixe)
    
    % check if startpoint and endpoint are the same
    
    c1 = num2cell(individual(ixs,:));
    c2 = num2cell(individual(ixe,:));   
    sameSE = all(cell2mat(cellfun(compare,c1(:),c2(:),...
        'UniformOutput',false)));

    % Compute shortest distances between simplification points
    
    if sameSE; 

        if dims == 2;
            
            d = hypot(individual(ixs,1)-individual(ixs+1:ixe-1,1),...
                individual(ixs,2)-individual(ixs+1:ixe-1,2));
        else
            
            d = sqrt(sum(bsxfun(@minus,individual(ixs,:),...
                individual(ixs+1:ixe-1,:)).^2,2));
            
        end
        
    else    
        
        % Compute shortest distance of all points to the line segment
        
        pt = bsxfun(@minus,individual(ixs+1:ixe,:),individual(ixs,:));
        a = pt(end,:)';
        beta = (a' * pt')./(a'*a);
        b    = pt-bsxfun(@times,beta,a)';
        
        % Two Dimensional Case
        
        if dims == 2;
            
            d = hypot(b(:,1),b(:,2));
            
        % Higher Dimensional Case
            
        else
            
            d = sqrt(sum(b.^2,2));
            
        end
        
    end
    
    [dmax,ixc] = max(d);
    ixc  = ixs + ixc; 
    
    % Check if distance is smaller than specified tolerance
    
    if dmax <= tolerance;
        
        if ixs ~= ixe-1;
            
            I(ixs+1:ixe-1) = false;
            
        end
        
    % If tolerance is not met recurcsively call the function again
    
    else
        
        individual = simplifyrec(individual,tolerance,ixs,ixc);
        individual = simplifyrec(individual,tolerance,ixc,ixe);

    end

end

end