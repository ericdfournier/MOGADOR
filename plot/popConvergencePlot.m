function [ plotHandle ] = popConvergencePlot(   popCell,...
                                                paramsStruct,...
                                                modelFit )
% popConvergencePlot.m Function to plot the convergence characteristics of
% a set of populations over successive generations of evolutionary
% operations
%
% DESCRIPTION:
%
%   This plot shows the progress of successive generations of populations
%   from a MOGADOR run as measured in terms of overall average fitness
%   across all of the individuals in each generation of the population for
%   all of the objective variables included in the analysis. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] = popConvergencePlot(    popCell,...
%                                           paramsStruct,...
%                                           modelFit );
%
% INPUTS:
%
%   popCell =           [p x r] array in which each row [p] corresponds to 
%                       an individual within the population and each column
%                       [r] corresponds to the sequential index numbers of
%                       the grid cells visited by each individual.
%
%   paramsStruct =      Structure object containing the parameter settings
%                       used to generate the popCell input.
%   
%   modelFit =          [0 | 1] binary value indicating whether or not the
%                       user would like to fit a polynomial function to the 
%                       data using a least square error fitting procedure.
%
% OUTPUTS:
%
%   plotHandle =        A plot handle object is generate for the output
%                       population search domain plot produced by the 
%                       function. 
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
addRequired(P,'paramsStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));
addRequired(P,'modelFit',@(x)...
    isnumeric(x) &&...
    ~isempty(x) &&...
    isscalar(x));
    
parse(P,nargin,popCell,paramsStruct,modelFit);

%% Function Parameters

avgFitness = [popCell{:,3}]';
gN = 1:size(popCell,1);

%% Switch Case

switch modelFit
    
    case 0
        
        plotHandle = scatter(gN,gN,avgFitness);
        
    case 1
        
        [fitObject, goodnessParams] = fit(gN, gN, avgFitness,'poly1');
        
        hold on
        scatter(gN,gN,avgFitness)
        plot(fitObject);
        hold off
        
        disp('Fit Parameters:');
        disp(fitObject);
        disp('Goodness of Fit Parameters:');
        disp(goodnessParams);
        
end