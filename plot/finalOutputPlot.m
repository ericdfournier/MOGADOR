function [ plotHandle ] = finalOutputPlot(  inputPopCell, ...
                                            paramsStruct )
% finalOutputPlot.m Function to generate a composite panel of six sub-plots
% including: a population convergence plot, a population search domain
% plot, an individual fitness tradeoff plot, a population pareto frontier 
% plot, and a fittest individual plot.  
%
% DESCRIPTION:
%
%   The final output plot provides an overview of the algorithm results and
%   convergence behavior. It allows the user to assess the quality of the
%   solution set which has been generated and make informed decisions about
%   parameter settings. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] = finalOutputPlot(   inputPopCell, ...
%                                       paramsStruct );
%
% INPUTS:
%
%   inputPopCell =  {q x 3} cell array in which all of the elements in the
%                   first column are population arrays, all of the elements
%                   in the second column are individual fitness value
%                   arrays, and all of the elements in the third column are
%                   mean population wide average fitness values. 
%
%   paramsStruct =  Structure object containing the parameter settings used
%                   to generate the inputPopCell. 
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

%% Function Parameters

finalGen = sum(~cellfun(@isempty,inputPopCell(:,1)));
[~, topRank] = sort(sum(inputPopCell{finalGen,2},2),'ascend');

%% Generate Outputs

plotHandle = figure();

subplot(2,3,1);
popConvergencePlot(inputPopCell,paramsStruct);

subplot(2,3,2);
popSearchDomainPlot(inputPopCell,1,paramsStruct);

subplot(2,3,3);
fitnessTradeoffPlot(inputPopCell{finalGen,1}(1,:),paramsStruct);

subplot(2,3,4);
popParetoFrontierPlot(inputPopCell,finalGen,paramsStruct);

subplot(2,3,5);
popSearchDomainPlot(inputPopCell,finalGen,paramsStruct);

subplot(2,3,6);
individualPlot(inputPopCell{finalGen,1}(topRank(1),:),...
    paramsStruct.gridMask);

end