function [ outputPop ] = popEpigeneticSmoothingFnc( popCell,...
                                                    popIndex,...
                                                    paramsStruct )
% popEpigeneticSmoothingFnc.m function to generate epigenetic variants of
% individuals within a given input population. 
%
% DESCRIPTION:
%
%   Function to generate epigenetic derivatives for an input population of
%   individuals using an interative fitness based pathway smoothing
%   procedure. Ten smoothed paths are generated using progressively more
%   coarse smoothing tolerances. The fitness of these smoothed paths are
%   then evaluated relative both to one another as well as to the input
%   individual with the fitest overall path being returned for each
%   individual in the population. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputPop ] =  popEpigeneticSmoothingFnc( popCell, popIndex,...
%                                               paramsStruct )
%
% INPUTS:
%
%   popCell =           [p x r] array in which each row [p] corresponds to 
%                       an individual within the population and each column
%                       [r] corresponds to the sequential index numbers of
%                       the grid cells visited by each individual.
%
%   popIndex =          [q] scalar value indicating the index number of the
%                       popualation within the popCell to be used for the
%                       epigenetic smoothing process
%
%   paramsStruct =      Structure object containing the parameter settings
%                       used to generate the popCell input.
%
% OUTPUTS:
%
%   outputPop =         [1 x m] array containing the index values of the 
%                       childPathways produced as a result of the signle 
%                       point epigenetic smoothing procedure
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
    x == 3);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'popCell',@(x)...
    iscell(x) &&...
    ~isempty(x));
addRequired(P,'popIndex',@(x)...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'paramsStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,popCell,popIndex,paramsStruct);

%% Function Parameters

inputPop = popCell{popIndex,1};
gridMask = paramsStruct.gridMask;
objectiveVars = paramsStruct.objectiveVars;
pS = size(inputPop,1);
gL = size(inputPop,2);
outputPop = zeros(pS,gL);

%% Generate Epigenetic Derivatives

for i = 1:pS
    
    outputPop(i,:) = epigeneticSmoothingFnc(...
        inputPop(i,:),...
        objectiveVars,...
        gridMask);
    
end

end

