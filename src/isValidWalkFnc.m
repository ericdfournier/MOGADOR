function [ isValidWalk ] = isValidWalkFnc( individual,...
                                       gridMask )
                                        
% validateWalkFnc.m Checks for walk validity on the basis of continuous
% walk connectivity as well as search domain gridMask boundary errors.
%
% DESCRIPTION:
%
%   Function to determine whether an individual walk is valid on the basis
%   of pathway connectivity as well as 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ output ] =  isValidWalkFnc( individual, gridMask )
%
% INPUTS:
%
%   individual =    [1 x m] array of grid cell indices corresponding to a
%                   connected pathway linking some source to some
%                   destination within the search domain specified in the
%                   binary input gridMask
%
%   gridMask =      [q x s] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   individual =    [1 x m] array containing the index values of the 
%                   childPathways produced as a result of the signle point 
%                   epigenetic smoothing procedure
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
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'individual',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,individual,gridMask);

%% Function Parameters

gS = size(gridMask);
wI = any(individual,1);
aI = individual(wI);

%% Screen on the Basis

gridMaskVals = gridMask(aI);

if all( 

end

