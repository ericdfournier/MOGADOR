function [ mutant, mutationInd ] = mutationFnc( individual, gridMask )

% mutationFnc function to generate a child pathway from the 
% single point crossover of two previously selected parent pathways.
%
% DESCRIPTION:
%
%   Function to randomly select a valid crossover site for the production
%   of a new child pathway from a set of two previously selected parent 
%   pathways.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ mutant, mutationInd ] =  mutationFnc( individual, gridMask )
%
% INPUTS:
%
%   individual =    [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   gridMask =      [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   mutant =        [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   mutationInd =   [r] scalar value indicating the index number of the
%                   locus grid cell at which the mutation occcurred
%
% EXAMPLES:
%   
%   Example 1 =         
%
%                   n = 100;
%                   gridMask = zeros(n);
%                   gridMask(:,1) = nan;
%                   gridMask(1,:) = nan;
%                   gridMask(end,:) = nan;
%                   gridMask(:,end) = nan;
%
%                   sourceIndex = [20 20];
%                   destinIndex = [80 80];
%                   objectiveVars = randi([0 10],10000,3);
%                   objectiveFrac = 0.10;
%                   minClusterSize = 5;
%                   popSize = 1;
%
%                   [individual, popParams] = initPopFnc(...
%                                       popSize,objectiveVars,...
%                                       objectiveFrac,minClusterSize,...
%                                       sourceIndex,destinIndex, gridMask);
%
%                   [mutant, mutantInd] = mutationFnc(individual,gridMask);
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                            September 2013                            %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin', @(x) x == 2);
addRequired(p,'individual',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,individual,gridMask);

%% Iteration Parameters

indiv = individual(any(individual,1));
q = size(indiv);
a = size(gridMask);

%% Select Mutation Sites and Generate Mutations

% THERE IS A PROBLEM WITH THE SEQUENCING OF THE MUTATION 

% YOU NEED TO GENERATE THE NEIGHBORHOOD ON THE BASIS OF THE INPUT PATH
% SEQUENCE. SELECT SOME NUMBER OF THE PREVIOUS AND SUBSEQUENT CELLS
% VISITED. TURN THESE CELLS INTO THE FORBIDDEN AREAS OF A GRID MASK. MAKE 
% MUTATION CELL FORBIDDEN AS WELL. THEN MAKE PREVIOUS CELL THE SOURCE INDEX
% AND THE SUBSEQUENT CELL THE DESTINATION INDEX. 
% RUN THE PSEUDORANDOM WALK FUNCTION TO CONNECT THE SOURCE TO THE
% DESTINATION INDEX THEN INSERT THIS PATH SEGMENT INTO THE LARGER PATHWAY
% AS A MUTATION. THIS ENSURES THAT ALL MUTATIONS ARE VIABLE PATHWAYS.

h = 0;

while h == 0
    
    mutSel = randsample(2:1:q(1,2)-1,1);
    mutInd = indiv(1,mutSel);
    neighSub = zeros(9,2);
    newMut = cell(1,1);
    
    [j,k] = ind2sub(a,mutInd);
    neighSub(1,:) = [j-1,k-1];
    neighSub(2,:) = [j-1,k];
    neighSub(3,:) = [j-1,k+1];
    neighSub(4,:) = [j,k-1];
    neighSub(5,:) = [j,k];
    neighSub(6,:) = [j,k+1];
    neighSub(7,:) = [j+1,k-1];
    neighSub(8,:) = [j+1,k];
    neighSub(9,:) = [j+1,k+1];
    neighInd = sub2ind(a,neighSub(:,1),neighSub(:,2));
    
    c = intersect(neighInd,indiv);
    u = size(c);
    d = setdiff(neighInd,c);
    
    p = 0;
    e = 0;
    
    if u(1,2) < 3
        
        error('Input path connectivity rule violated.')
    
    elseif u(1,2) == 3
        
        while p == 0
                        
            tmp = gridMask;
            tmp(c) = 1;
            tmp(mutInd) = 0;
            tryMut = datasample(d,2,2);
            tmp(tryMut) = 1;
            bw = reshape(tmp(neighInd),[3,3]);
            result = bwconncomp(bw,8);
            
            if result.NumObjects > 1
                p = 0;
            else
                p = 1;
            end
            
            e = e+1;
            
            if e == 50
                p = 1;
                h = 0;
            else
                h = 1;
            end
            
        end
        
    elseif u(1,2) > 3
        
        while p == 0
            
            tmp = gridMask;
            tmp(c) = 1;
            tmp(mutInd) = 0;
            tryMut = datasample(d,1,2);
            tmp(tryMut) = 1;
            bw = reshape(tmp(neighInd),[3,3]);
            result = bwconncomp(bw,8);
            
            if result.NumObjects > 1
                p = 0;
            else
                p = 1;
            end
            
            e = e+1;
            
            if e == 50
                p = 1;
                h = 0;
            else
                h = 1;
            end
            
        end
        
    end
    
end

newMut{1,1} = tryMut;

%% Insert New Mutations into Individual

sections = cell(2,2);
z = vertcat(1,mutSel,q(1,2));

sections{1,1} = indiv(1,z(1):z(2)-1);
tmp = size(sections{1,1});
sections{1,2} = tmp(1,2);

sections{2,1} = indiv(1,z(2)+1:z(3));
tmp = size(sections{2,1});
sections{2,2} = tmp(1,2);

mutantRaw = horzcat(sections{1,1},newMut{1,1},sections{2,1});

%% Generate Final Output

x = size(individual);
mutant = zeros(x);
v = size(mutantRaw);
mutant(1,1:v(1,2)) = mutantRaw;
mutationInd = mutInd;

end