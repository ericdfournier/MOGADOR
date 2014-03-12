function [ plotHandle ] = objectiveVarsPlot(    popCell,...
                                                paramsStruct )
% objectiveVarsPlot.m Function to produce a multi-pane image plot of the
% two or three objective variables used as inputs to the
% popParetoFrontierPlot function.
%
% DESCRIPTION:
%
%   Function creates a orthagonal perspective layer stack of scaled images
%   generated from the continuous fields of objective values for two or
%   three variables specified in the variable objectiveIndices within the
%   parameters structure object.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =  objectiveVarsPlot( objectiveVars, paramsStruct );
%
% INPUTS:
%
%   popCell =       [p x r] array in which each row [p] corresponds to an
%                   individual within the population and each column [r] 
%                   corresponds to the sequential index numbers of the grid
%                   cells visited by each individual.
%
%   paramsStruct =  Structure object containing the parameter settings used
%                   to generate the popCell input. 
%
% OUTPUTS:
%
%   plotHandle =    A plot handle object is generate for the output
%                   objective variables plot produced by the function. 
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
%%%                 University of California Santa Barbara               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x)...
    x == 2);
addRequired(P,'popCell',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'paramsStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));

parse(P,nargin,popCell,paramsStruct);

%% Function Parameters

objectiveVars = paramsStruct.objectiveVars;
sourceIndex = paramsStruct.sourceIndex;
destinIndex = paramsStruct.destinIndex;

%% Generate Neighborhood Buffer



end