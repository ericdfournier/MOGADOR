function [ plotHandle ] = finalOutputPlot(  inputPopCell, ...
                                            paramsStruct )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

finalGen = sum(~cellfun(@isempty,inputPopCell(:,1)));

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

[~, topRank] = sort(sum(inputPopCell{finalGen,2},2),'ascend');

subplot(2,3,6);
individualPlot(inputPopCell{finalGen,1}(topRank(1),:),...
    paramsStruct.gridMask);

end

