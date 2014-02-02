function [ initialRange ] = initRangesFnc( genomeLength, gridMask )

% initRangesFnc.m This function generates an initial range of values for
%   a genetic algorithm based global optimization procedure.
%
% DESCRIPTION:
%
%   Function to generate the initial range of potential values for the
%   input variables used in a genetic algorithm based global optimization
%   procedure. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ initialRange ] = initRangesFnc( genomeLength, gridMask )
%
% INPUTS:
%
%   genomeLength =  [s] scalar value indicating the maximum length of the 
%                   genome for all of the individuals within the population
%
%   gridMask =      [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   initialRange =  [2 x r] double array containing the lower and upper 
%                   bounds for the potential values of the decision 
%                   variables in the global optimization problem
%
% EXAMPLES:
%
%   Example 1 =
%
%                   gridMask = zeros(100); 
%                   gridMask(1,:) = nan; 
%                   gridMask(:,1) = nan; 
%                   gridMask(end,:) = nan; 
%                   gridMask(:,end) = nan;
%                   genomeLength = 100;
%                   initialRange = initRangesFnc(genomeLength,gridMask);
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                            July 2013                                 %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin', @(x) x == 2);
addRequired(p,'genomeLength',@(x) isnumeric(x) && isscalar(x) &&...
    ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,genomeLength,gridMask);

%% Generate Input Parameters

initialRange = zeros(2,genomeLength);
a = size(gridMask);
b = a(1,1)*a(1,2);

%% Generate Initial Range Output Array

initialRange(1,:) = 1;
initialRange(2,:) = b;

end