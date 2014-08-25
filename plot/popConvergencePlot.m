function [ plotHandle ] = popConvergencePlot(   popCell,...
                                                paramsStruct )
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
%   [ plotHandle ] = popConvergencePlot( popCell, paramsStruct );
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
%%%                 University of California Santa Barbara               %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x)...
    x == 2);
addRequired(P,'popCell',@(x)...
    iscell(x) &&...
    ~isempty(x));
addRequired(P,'paramsStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));
    
parse(P,nargin,popCell,paramsStruct);

%% Function Parameters

concave = paramsStruct.concave;
modelFit = paramsStruct.modelFit;
avgFitness = [popCell{:,3}]';
gN = (1:size(avgFitness,1))';

if modelFit == 0 && concave == 0
    switchCase = 0;
elseif modelFit == 0 && concave == 1
    switchCase = 1;
elseif modelFit == 1 && concave == 0
    switchCase = 2;
elseif modelFit == 1 && concave == 1
    switchCase = 3;
end

%% Compute Basis Fitness

basisSolution = euclShortestWalkFnc(...
    paramsStruct.sourceIndex,...
    paramsStruct.destinIndex,...
    paramsStruct.gridMask);

basisAverageFitness = sum(fitnessFnc(...
    basisSolution,...
    paramsStruct.objectiveVars,...
    paramsStruct.gridMask),2);

%% Switch Case

switch switchCase
    
    case 0
        
        hold on
        plotHandle = scatter(gN, avgFitness,'ko');
        plot(gN,repmat(basisAverageFitness, [size(gN,1), 1]),'co-');
        hold off
        axis tight square
        grid on
        title(' Convergence Plot');
        xlabel('Population Generation #');
        ylabel('Population Mean Fitness');
        legend('Populations','Basis Solution');
        
    case 1
        
        plotHandle = scatter(gN, avgFitness,'ko');
        axis tight square
        grid on
        title(' Convergence Plot');
        xlabel('Population Generation #');
        ylabel('Population Mean Fitness');
        legend('Populations');
        
    case 2
        
        [fitObject, goodnessParams] = fit(gN, avgFitness,'exp2');
        
        hold on
        scatter(gN,avgFitness,'ko')
        plot(fitObject);
        plot(gN,repmat(basisAverageFitness, [size(gN,1), 1]),'co-');
        hold off
        axis tight square
        grid on
        title(' Convergence Plot');
        xlabel('Population Generation #');
        ylabel('Population Mean Fitness');
        legend('Populations','Fitted Curve','Basis Solution');
        
        disp('Convergence Fit Parameters:');
        disp(fitObject);
        disp('Goodness of Fit Parameters:');
        disp(goodnessParams);
        
    case 3
        
        [fitObject, goodnessParams] = fit(gN, avgFitness,'exp2');
        
        hold on
        scatter(gN,avgFitness,'ko')
        plot(fitObject);
        hold off
        axis tight square
        grid on
        title(' Convergence Plot');
        xlabel('Population Generation #');
        ylabel('Population Mean Fitness');
        legend('Populations','Fitted Curve');
        
        disp('Convergence Fit Parameters:');
        disp(fitObject);
        disp('Goodness of Fit Parameters:');
        disp(goodnessParams);
        
end