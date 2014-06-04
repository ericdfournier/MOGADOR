function [ gridMaskBoundary ] = gridMaskBoundaryFnc( gridMask )

% crossoverFnc.m Generates a binary array that is the same dimensions as
% the input grid mask containing values of 1 at the cell locations
% corresponding to the peripheral boundary of the gridMask
%
% DESCRIPTION:
%
%   Function to generate the cells occurring at the boundary of the
%   gridMask prior to the computation of the convex area mask. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ gridMaskBoundary ] =  gridMaskBoundaryFnc( gridMask )
%
% INPUTS:
%
%   gridMask =          [q x s] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zero placeholders
%
% OUTPUTS:
%
%   gridMaskBoundary =  [q x s] binary array with the grid cells occuring
%                       at the boundary of the mask labeled as ones and all
%                       other grid cell locations labeled as zero 
%                       placeholders
%
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
    x == 1);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,gridMask);

%% Create Neighborhood Filter

gridMaskConv = conv2(gridMask,ones(3,3));
gridMaskBoundaryRaw = gridMaskConv < 9 & gridMaskConv > 0;
gridMaskBoundary = gridMaskBoundaryRaw(2:end-1,2:end-1);

end