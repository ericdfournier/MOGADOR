function [ plotHandle ] = crossoverPlot( parent1, parent2, child,...
                            sourceIndex, destinIndex, gridMask )

% crossoverPlot is a function that is used to plot the output of the
% crossoverFnc function.
%
% DESCRIPTION:
%
%   Function to graphically display the results of a crossover operation
%   performed on a parent population of individuals. This graphical display
%   can be used to debug the algorithms used by the crossoverFnc in
%   executing the crossover procedure. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =  crossoverPlot( parent1, parent2, child, gridMask )
%
% INPUTS:
%
%   parent1 =           [1 x m] array of index values listing the connected
%                       grid cells forming a pathway from a specified
%                       source to a specified target destination given the
%                       constraints of a specified study region
%
%   parent2 =           [1 x m] array of index values listing the connected
%                       grid cells forming a pathway from a specified
%                       source to a specified target destination given the
%                       constraints of a specified study region
%
%   child =             [1 x m] array of index values listing the connected
%                       grid cells forming a pathway from a specified
%                       source to a specified target destination given the
%                       constraints of a specified study region and
%                       produced as the output of the crossover operation
%                       performed on parentPop.
%   
%   sourceIndex =       [i j] index value of the source node for each 
%                       parent
%
%   destinIndex =       [p q] index value of the destination node for each
%                       parent
%
%   gridMask =          [q x r] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as NaN placeholders
%
% OUTPUTS:
%
%   plotHandle =        An output variable assigning a plot handle to the 
%                       crossover plot.
%
% EXAMPLES:
%   
%   Example 1 =
%
%                   % Pass 'parents' input as output from
%                   'initializePop' function
%
%                   % Pass 'child' inputs as outputs from 
%                   'crossoverFnc' function
%
%                   plotHandle = crossoverPlot(parent1,parent2,child,...
%                                   gridMask);
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

addRequired(p,'nargin',@(x) x == 6);
addRequired(p,'parent1',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'parent2',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'child',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'sourceIndex',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'destinIndex',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,parent1,parent2,child,sourceIndex,destinIndex,gridMask);

%% Generate Iteration Paramters

gS = size(gridMask);
sourceInd = sub2ind(gS,sourceIndex(1,1),sourceIndex(1,2));
destinInd = sub2ind(gS,destinIndex(1,1),destinIndex(1,2));

%% Extract Parent Data

parent1Plt = gridMask;
p1 = parent1(any(parent1,1));
parent1Plt(p1(2:end-1)) = 4;
parent1Plt(sourceInd) = 7;
parent1Plt(destinInd) = 10;

parent2Plt = gridMask;
p2 = parent2(any(parent2,1));
parent2Plt(p2) = 5;
parent2Plt(sourceInd) = 7;
parent2Plt(destinInd) = 10;

childPlt = gridMask;
c = child(any(child,1));

parent1_cont = intersect(p1(2:end-1),c(2:end-1),'stable');
parent2_cont = intersect(p2(2:end-1),c(2:end-1),'stable');

childPlt(parent1_cont) = 4;
childPlt(parent2_cont) = 5;
childPlt(sourceInd) = 7;
childPlt(destinInd) = 10;

%% Generate Plot

scrn = get(0,'screensize');
plotHandle = figure();
set(plotHandle,'position',scrn);

subplot(1,3,1);
imagesc(parent1Plt);
axis square
title('Parent #1 Phenotype','FontSize',16,'FontWeight','Bold');

subplot(1,3,2);
imagesc(parent2Plt);
axis square
title('Parent #2 Phenotype','FontSize',16,'FontWeight','Bold');

subplot(1,3,3);
imagesc(childPlt);
axis square
title('Child Phenotype With Parent Contributions','FontSize',16,...
    'FontWeight','Bold');

end