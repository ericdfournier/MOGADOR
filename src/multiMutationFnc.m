function [ mutant ] = multiMutationFnc(     individual,... 
                                            gridMask,...
                                            mutations )

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
%                                   gridMask,...
%                                   mutations )
%
% INPUTS:
%
%   mutant =        [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   gridMask =      [n x m] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
%   mutations =     [s] scalar value indicating the number of randomly
%                   selected mutations to be processes on the input 
%                   mutant
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
%                   % Pass 'mutant' and 'gridMask' input arguments as 
%                   output arguments from the crossover procedure
%
%                   mutations = 5;
%
%                   [ mutant ] = multiMutationFnc(  mutant,...
%                                                   gridMask,...
%                                                   mutations);
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
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'mutant',@(x)...
    isnumeric(x) &&...
    isrow(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'mutations',@(x)...
    isnumeric(x) &&...
    isscalar(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,individual,gridMask,mutations);

%% Iteration Parameters

gL = size(individual);

%% Compute Mutations

for i = 1:mutations
    
    individual = mutationFnc(individual,gridMask);
    
end

%% Generate Output

mutant = individual;

end