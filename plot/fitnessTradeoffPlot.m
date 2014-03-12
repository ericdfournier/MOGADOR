function [ plotHandle ] = fitnessTradeoffPlot(  individual,...
                                                paramsStruct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Function Parameters

indiv = individual(any(individual,1));
gL = size(indiv,2);
objectiveVars = paramsStruct.objectiveVars;
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
title('Along Path Objective Value Comparison'); 
legend(paramsStruct.objectiveNames);

end