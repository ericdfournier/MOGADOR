function [ alongPathDist ] = alongPathDistance( individual, ...
                                                    searchDomain, ...
                                                    mapUnits)
%alongPathDistance.m Function to compute the along path distance for a
% given input individual pathway.

% Get individual length
chromSize = size(individual(individual ~= 0),2);
domSize = size(searchDomain);
alongPathDist = zeros(1,1);

% Loop through and compute pairwise distances
for i = 2:chromSize
   
    [prvRow, prvCol] = ind2sub(domSize,individual(1,i-1));
    [curRow, curCol] = ind2sub(domSize,individual(1,i));
    curDist = pdist([prvRow prvCol; curRow curCol]);
    alongPathDist = alongPathDist + curDist;
    
end

    alongPathDist = alongPathDist .* mapUnits;

end

