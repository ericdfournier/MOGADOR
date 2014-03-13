function [ plotHandle ] = individualPlot(   individual,...
                                            gridMask )
% individualPlot is a function that is used to plot the pathway of a single
% individual pathway through a given study domain given by gridMask
%
% DESCRIPTION:
%
%   Function to graphically display the pathway of a given individual which
%   represents a set of grid cells with queens connectivity through a given
%   study domain specified by the gridMask variable.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =  individualPlot( individual, gridMask )
%
% INPUTS:
%
%   individual =        (n x p) array of the grid cell values corresponding
%                       to the genome of a individual pathway leading from
%                       a given start point within the study domain to a
%                       given destination point
%
%   gridMask =          (q x r) binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zeros
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
%                   % Pass 'individual' as output of some pathway
%                   generation procedure (either bresenham.m function or
%                   pseudoRandomWalk.m)
%
%                   plotHandle = individualPlot(individual,gridMask);
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
    x == 2);
addRequired(P,'individual',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,individual,gridMask);

%% Prepare Data for Plotting

individualRaw = individual(any(individual,1));
individualMask = gridMask;
individualMask(individualRaw) = 2;
individualMask(individualRaw(1)) = 3;
individualMask(individualRaw(end)) = 4;

%% Generate Output Plot

plotHandle = imagesc(individualMask);
axis square
xlabel('X Dimension');
ylabel('Y Dimension');
title('Individual Plot');

end