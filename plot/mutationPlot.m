function [ plotHandle ] = mutationPlot(     individual,...
                                            mutant,...
                                            sourceIndex,...
                                            destinIndex,...
                                            gridMask )

% crossoverPlot is a function that is used to plot the output of the
% crossoverFnc function.
%
% DESCRIPTION:
%
%   Function to graphically display the results of a mutantion operation
%   performed on an individual. This graphical display
%   can be used to debug the algorithms used by the mutantFnc in
%   executing the mutation procedure. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =  crossoverPlot(    individual,...
%                                       mutant,...
%                                       sourceIndex,...
%                                       destinIndex,...
%                                       gridMask )
%
% INPUTS:
%
%   individual =        [1 x m] array of index values listing the connected
%                       grid cells forming a pathway from a specified
%                       source to a specified target destination given the
%                       constraints of a specified study region
%
%
%   mutant =            [1 x m] array of index values listing the connected
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
%                       mutation plot.
%
% EXAMPLES:
%   
%   Example 1 =
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

addRequired(P,'nargin',@(x) ...
    x == 5);
addRequired(P,'individual',@(x) ...
    isnumeric(x) && ...
    isrow(x) && ...
    ~isempty(x));
addRequired(P,'mutant',@(x) ...
    isnumeric(x) && ...
    isrow(x) && ...
    ~isempty(x));
addRequired(P,'sourceIndex',@(x) ...
    isnumeric(x) && ...
    isrow(x) && ...
    ~isempty(x));
addRequired(P,'destinIndex',@(x) ...
    isnumeric(x) && ...
    isrow(x) && ...
    ~isempty(x));
addRequired(P,'gridMask',@(x) ...
    isnumeric(x) && ...
    ismatrix(x) && ...
    ~isempty(x));

parse(P,nargin,individual,mutant,sourceIndex,destinIndex,gridMask);

%% Generate Function Paramters

gS = size(gridMask);
sourceInd = sub2ind(gS,sourceIndex(1,1),sourceIndex(1,2));
destinInd = sub2ind(gS,destinIndex(1,1),destinIndex(1,2));

%% Extract Individual and Mutation Data

individualPlt = gridMask;
indiv = individual(any(individual,1));
individualPlt(indiv) = 2;

mutantPlt = gridMask;
mut = mutant(any(mutant,1));
mutantPlt(mut) = 2;

mutation = mutantPlt - individualPlt;

mutantPlt(mut(2:end-1)) = 3;
mutantPlt(mutation == -1) = 10;
mutantPlt(mutation == 1) = 5;
mutantPlt(sourceInd) = 7;
mutantPlt(destinInd) = 9;

%% Generate Plot

scrn = get(0,'ScreenSize');
plotHandle = figure();
set(plotHandle,'position',scrn);

subplot(1,3,1);
individualPlot(individual,gridMask);

subplot(1,3,2);
individualPlot(mutant,gridMask);

subplot(1,3,3);
imagesc(mutantPlt);
axis square
title('Mutation Plot');

end