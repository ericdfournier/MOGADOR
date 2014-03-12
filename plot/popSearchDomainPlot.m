function [ plotHandle ] = popSearchDomainPlot(  popCell,...
                                                popIndex,...
                                                paramsStruct )
% popSearchDomainPlot.m Function to provide a high level visual overview of
% the range of grid cells visited by the set of the individuals contained
% within a given population. 
%
% DESCRIPTION:
%
%   The number of times each grid cell is visited by all of the individuals
%   within the input population is counted, recorded, and ploted, as a
%   scaled color image in which forbidden cells are given the value of
%   zero, allowed but unvisited cells are given the value of one, and all
%   other allowed and visited cells are given a value commensurate with the
%   number of times they have been visited by the individuals within the
%   population. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] = popSearchDomainPlot(popCell, popIndex, paramsStruct);
%
% INPUTS:
%
%   popCell =       [p x r] array in which each row [p] corresponds to an
%                   individual within the population and each column [r] 
%                   corresponds to the sequential index numbers of the grid
%                   cells visited by each individual.
%
%   popIndex =   [q] scalar value indicating the index number of the
%                   popualation within the popCell to be used for plotting
%
%   paramsStruct =  Structure object containing the parameter settings used
%                   to generate the popCell input. 
%
% OUTPUTS:
%
%   plotHandle =    A plot handle object is generate for the output
%                   population search domain plot produced by the function. 
%   
% EXAMPLES:
%   
%   Example 1 =
%
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
    x == 3);
addRequired(P,'popCell',@(x)...
    iscell(x) &&...
    ~isempty(x));
addRequired(P,'popIndex',@(x)...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'paramsStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));

parse(P,nargin,popCell,popIndex,paramsStruct);

%% Function Parameters

inputPop = popCell{popIndex,1};
sourceIndex = paramsStruct.sourceIndex;
destinIndex = paramsStruct.destinIndex;
gridMask = paramsStruct.gridMask;
gS = size(gridMask);
pS = size(inputPop,1);

%% Find Unique Points

visited = zeros(gS);

for i = 1:pS
    individual = inputPop(i,:);
    individual = individual(any(individual,1))';
    visits = visited(individual);
    visited(individual) = visits+1;
end

visited(sourceIndex(1,1),sourceIndex(1,2)) = 0;
visited(destinIndex(1,1),destinIndex(1,2)) = 0;

%% Generate Plot

plotHandle = imagesc(visited);
title(['Population #',num2str(popIndex),' Search Domain']);
xlabel('X Dimension');
ylabel('Y Dimension');
colorbar();
axis tight square

end