function [ mutant ] = multiMutationFnc(     individual,...
                                            mutations,...
                                            randomness,...
                                            gridMask )

% multiMutationFnc Function to generate an output mutant mutant from
% the multi-point mutation of an input mutant
%
% DESCRIPTION:
%
%   Function to randomly generate multiple point mutations within an input
%   mutant and produce as output a valid mutated mutant
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ mutant ] =  multiMutationFnc( mutant,...
%                                   mutations,...
%                                   randomness,...
%                                   gridMask )
%
% INPUTS:
%
%   individual =    [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   mutations =     [s] scalar value indicating the number of randomly
%                   selected mutations to be processes on the input 
%                   mutant
%
%   randomness =    [h] a value > 0 indicating the degree of randomness
%                   to be applied in the process of generating the 
%                   walk. Specifically, this value corresponds to  the 
%                   degree of the root that is used to compute the 
%                   covariance from the minimum basis distance at each 
%                   movement iteration along the path. Higher numbers 
%                   equate to less random paths.
%
%   gridMask =      [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
% OUTPUTS:
%
%   mutant =        [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
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
%%%               University of California Santa Barbara                 %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

P = inputParser;

addRequired(P,'nargin',@(x)...
    x == 4);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'individual',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'mutations',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'randomness',@(x)...
    isnumeric(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,individual,mutations,randomness,gridMask);

%% Compute Mutations

for i = 1:mutations
    
    individual = mutationFnc(individual,randomness,gridMask);
    
end

%% Generate Final Output

mutant = individual;

end