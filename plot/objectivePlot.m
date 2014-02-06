function [ plotHandle ] = objectivePlot( objectiveVars, gridMask )
%
% objectiveVarsPlot.m Function to create a 3-D image stack of the
% objective variable input used for a given problem paramterization
%
% DESCRIPTION:
%
%   Function that creates a three dimensional perspective plot of the
%   individual objective surfaces contained within the multi-dimensional
%   objective vars input.
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ plotHandle ] =    singlePartConcaveWalkFnc(   objectiveVars,...
%                                                   gridMask );
%
% INPUTS:
%
%   objectiveVars =     [m x n x g] array in which the first two dimensions
%                       [n x m] correspond to the two spatial dimensions of
%                       the gridMask and in which the third dimension [g]
%                       corresponds to the index number of the objective
%                       variable
%
%   gridMask =          [n x m] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zeros
%
% OUTPUTS:
%
%   plotHandle =        A matlab figure object containing plotting specs
%                       for the output 3-D objective variable image stack 
%                       plot 
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

%% Function Parameters

oS = size(objectiveVars);
cam = [1035.5 759.1 12.7];

%% Generate Plot

[X,Y] = meshgrid(1:oS(1,2), 1:oS(1,1));
Z = ones(oS(1,1),oS(1,2));

plotHandle = figure();
set(plotHandle,'position',[0 0 1000 1000]);

for i = 1:oS(1,3)
    
    surface('XData',X-0.5, 'YData',Y-0.5, 'ZData', Z.*i, ...
        'CData',(objectiveVars(:,:,i) .* gridMask), 'CDataMapping',...
        'scaled','EdgeColor','none','FaceColor','texturemap');
    
end

campos(cam);
colormap(jet);
view(3), box on, axis tight square
set(gca, 'YDir','reverse','ZLim',[0 oS(1,3)+1]);

end