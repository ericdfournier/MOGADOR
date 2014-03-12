function [ plotHandle ] = popParetoFrontierPlot(    popCell,...
                                                    popIndex,...
                                                    paramsStruct)
% popParetoFrontierPlot.m Function to plot the pareto frontier of a given
% input population for two or three objectives. If two objectives are
% provided then the plot returned is a line plot in two dimensions. If
% three objectives are provided then the plot returned is a surface plot in
% three dimensions.
%
% DESCRIPTION:
%
%   This plot shows, for each individual within a population, the aggregate
%   fitness value according to each of two or three input objectives 
%   specified by the user in the input array 'objectiveIndices.' This plot
%   can be used to observe apparent tradeoffs in the fitness of individuals
%   within a population between two or three objectives in the context of a
%   multi-objective corridor location problem. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] = popParetoFrontierPlot( popCell,...
%                                           popIndex,...
%                                           paramsStruct );
%
% INPUTS:
%
%   popCell =           [p x r] array in which each row [p] corresponds to 
%                       an individual within the population and each column
%                       [r] corresponds to the sequential index numbers of
%                       the grid cells visited by each individual.
%
%   popIndex =          [q] scalar value indicating the index number of the
%                       popualation within the popCell to be used for
%                       plotting
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

modelFit = paramsStruct.modelFit;
objectiveIndices = paramsStruct.objectiveIndices;

%% Compute Basis Fitness

basisSolution = euclShortestWalkFnc(...
    paramsStruct.gridMask,...
    paramsStruct.sourceIndex,...
    paramsStruct.destinIndex);

basisFitness = fitnessFnc(...
    basisSolution,...
    paramsStruct.objectiveVars,...
    paramsStruct.gridMask);

%% Switch Case

iC = numel(objectiveIndices);

if iC < 2 || iC > 3

    error('There must be either 2 or 3 objective indices');
   
elseif iC == 2 && modelFit == 0
    
    switchCase = 1;
    
elseif iC == 2 && modelFit == 1
    
    switchCase = 2;
    
elseif iC == 3 && modelFit == 0
    
    switchCase = 3;
    
elseif iC == 3 && modelFit == 1
    
    switchCase = 4;
    
end

%% Generate Output Plots

switch switchCase
    
    case 1 % Two Dimensional Pareto Frontier Plot with No Fit
        
        hold on
        plotHandle = scatter(...
            popCell{popIndex,2}(:,objectiveIndices(1,1)),...
            popCell{popIndex,2}(:,objectiveIndices(1,2)),...
            'ko');
        scatter(...
            basisFitness(objectiveIndices(1,1)),...
            basisFitness(objectiveIndices(1,2)),...
            'co');
        hold off
        set(gca,'YDir','reverse','XDir','reverse');
        axis tight square
        grid on
        legend('Observed Data','Basis Solution');
        xlabel(paramsStruct.objectiveNames(1,1));
        ylabel(paramsStruct.objectiveNames(1,2));
        title('Pareto Frontier Plot');
        
    case 2 % Two Dimensional Pareto Frontier Plot with Polynomial Fit
        
        [fitObject, goodnessParams] = fit(...
            popCell{popIndex,2}(:,objectiveIndices(1,1)),...
            popCell{popIndex,2}(:,objectiveIndices(1,2)),...
            'poly2');
        
        hold on
        plotHandle = scatter(...
            popCell{popIndex,2}(:,objectiveIndices(1,1)),...
            popCell{popIndex,2}(:,objectiveIndices(1,2)),...
            'ko');
        plot(fitObject);
        scatter(...
            basisFitness(objectiveIndices(1,1)),...
            basisFitness(objectiveIndices(1,2)),...
            'co');
        hold off
        set(gca,'YDir','reverse','XDir','reverse');
        axis tight square
        grid on
        legend('Observed Data','Basis Solution','Fit Curve');
        xlabel(paramsStruct.objectiveNames(1,1));
        ylabel(paramsStruct.objectiveNames(1,2));
        title('Pareto Frontier Plot');
        
        disp('Fit Parameters:')
        disp(fitObject);
        disp('Goodness of Fit Parameters:');
        disp(goodnessParams);
        
    case 3 % Three Dimensional Pareto Surface Plot with No Fit
        
        hold on
        plotHandle = scatter3(...
            popCell{popIndex,2}(:,objectiveIndices(1,1)),...
            popCell{popIndex,2}(:,objectiveIndices(1,2)),...
            popCell{popIndex,2}(:,objectiveIndices(1,3)),...
            'ko');
        scatter3(...
            basisFitness(objectiveIndices(1,1)),...
            basisFitness(objectiveIndices(1,2)),...
            basisFitness(objectiveIndices(1,3)),...
            'co');
        hold off
        set(gca,'YDir','reverse','XDir','reverse','ZDir','reverse');
        axis tight square
        grid on
        colorbar();
        legend('Observed Data','Basis Solution');
        xlabel(paramsStruct.objectiveNames(1,1));
        ylabel(paramsStruct.objectiveNames(1,2));
        zlabel(paramsStruct.objectiveNames(1,3));
        title('Pareto Frontier Plot');
        
    case 4 % Three Dimensional Pareto Surface Plot with Polynomial Fit
        
        [fitObject, goodnessParams] = fit(...
            [popCell{popIndex,2}(:,objectiveIndices(1,1)),...
            popCell{popIndex,2}(:,objectiveIndices(1,2))],...
            popCell{popIndex,2}(:,objectiveIndices(1,3)),...
            'poly22');
        
        hold on
        plotHandle = scatter3(...
            popCell{popIndex,2}(:,objectiveIndices(1,1)),...
            popCell{popIndex,2}(:,objectiveIndices(1,2)),...
            popCell{popIndex,2}(:,objectiveIndices(1,3)),...
            'ko');
        scatter3(...    
            basisFitness(objectiveIndices(1,1)),...
            basisFitness(objectiveIndices(1,2)),...
            basisFitness(objectiveIndices(1,3)),...
            'co'); 
        plot(fitObject);
        hold off
        set(gca,'YDir','reverse','XDir','reverse','ZDir','reverse');
        axis tight square
        grid on
        colorbar();
        legend('Observed Data','Basis Solution','Fit Plane');
        xlabel(paramsStruct.objectiveNames(1,1));
        ylabel(paramsStruct.objectiveNames(1,2));
        zlabel(paramsStruct.objectiveNames(1,3));
        title('Pareto Frontier Plot');
        
        disp('Fit Parameters:');
        disp(fitObject);
        disp('Goodness of Fit Parameters:');
        disp(goodnessParams);
        
end

end