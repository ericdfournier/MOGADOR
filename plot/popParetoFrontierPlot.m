function [ plotHandle ] = popParetoFrontierPlot(    popCell,...
                                                    popIndex,...
                                                    paramsStruct,...
                                                    objectiveIndices,...
                                                    modelFit )
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
%                                           paramsStruct,...
%                                           objectiveIndices,...
%                                           modelFit );
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
%   objectiveIndices =  [1 x f] array in which each column [f] corresponds
%                       to the index value of an objective variable that
%                       will be used to generate the pareto frontier plot
%                       (3 <= numel(f) >= 2)
%   
%   modelFit =          [0 | 1] binary value indicating whether or not the
%                       user would like to fit a 2 or 3 dimensional 
%                       polynomial to the data using a least square error
%                       fitting procedure. The model fit will be included
%                       in the plot with calculated parameter estimates.
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
    x == 5);
addRequired(P,'popCell',@(x)...
    iscell(x) &&...
    ~isempty(x));
addRequired(P,'popIndex',@(x)...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'paramsStruct',@(x)...
    isstruct(x) &&...
    ~isempty(x));
addRequired(P,'objectiveIndices',@(x)...
    isnumeric(x) &&...
    ~isempty(x));
addRequired(P,'modelFit',@(x)...
    isnumeric(x) &&...
    ~isempty(x) &&...
    isscalar(x));
    
parse(P,nargin,popCell,popIndex,paramsStruct,objectiveIndices,modelFit);

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
        
        plotHandle = scatter(...
            popCell{popIndex,2}(:,objectiveIndices(1,1)),...
            popCell{popIndex,2}(:,objectiveIndices(1,2)));
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
            popCell{popIndex,2}(:,objectiveIndices(1,2)));
        plot(fitObject);
        hold off
        xlabel(paramsStruct.objectiveNames(1,1));
        ylabel(paramsStruct.objectiveNames(1,2));
        title('Pareto Frontier Plot');
        
        disp('Fit Parameters:')
        disp(fitObject);
        disp('Goodness of Fit Parameters:');
        disp(goodnessParams);
        
    case 3 % Three Dimensional Pareto Surface Plot with No Fit
        
        plotHandle = scatter3(...
            popCell{popIndex,2}(:,objectiveIndices(1,1)),...
            popCell{popIndex,2}(:,objectiveIndices(1,2)),...
            popCell{popIndex,2}(:,objectiveIndices(1,3)));
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
            popCell{popIndex,2}(:,objectiveIndices(1,3)));
        plot(fitObject);
        hold off
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