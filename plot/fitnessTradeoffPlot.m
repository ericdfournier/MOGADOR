function [ plotHandle ] = fitnessTradeoffPlot(  individual,...
                                                paramsStruct )
% fitnessTradeoffPlot.m Function to visualize the objective scores of each
% grid cell visisted by an individual pathway across all of the different
% objectives used in the analysis. 
%
% DESCRIPTION:
%
%   Function constructs a set of line plots depicting the objective score
%   values for each grid cell along a given pathway across all of the
%   different objectives used in the analysis. The different lines
%   corresponding to the different objective are given different colors and
%   labeled with their corresponding names in the figure legend. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =  fitnessTradeoffPlot( individual, paramsStruct )
%
% INPUTS:
%
%   individual =        (n x p) array of the grid cell values corresponding
%                       to the genome of a individual pathway leading from
%                       a given start point within the study domain to a
%                       given destination point
%
%   gridMask =          Structure object containing all of the parameters
%                       used to inform the MOGADOR model run that was used 
%                       to generate the population from which the input 
%                       individual was drawn. 
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
addRequired(P,'paramsStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));

parse(P,nargin,individual,paramsStruct);

%% Function Parameters

indiv = individual(any(individual,1));
gL = size(indiv,2);
objectiveVars = paramsStruct.objectiveVariables;
oC = size(objectiveVars,3);
rawFit = zeros(oC,gL);
nodes = 1:1:gL;

%% Compute Individual Fitness

for i = 1:oC
    
    currObj = objectiveVars(:,:,i);
    rawFit(i,:) = currObj(indiv);
    
end

%% Generate Plot

plotHandle = plot(nodes,rawFit(:,:));
axis tight square
grid on
xlabel('Along Path Location');
ylabel('Objective Value');
title('Individual Fitness Tradeoff Plot'); 
legend(paramsStruct.objectiveNames);

end