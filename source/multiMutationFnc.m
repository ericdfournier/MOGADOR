function [ mutant, mutationInd ] = multiMutationFnc( individual,... 
                                    gridMask, mutations )

% multiMutationFnc function to generate an output mutant individual from
% the multi-point mutation of an input individual
%
% DESCRIPTION:
%
%   Function to randomly generate multiple point mutations within an input
%   individual and produce as output a valid mutated individual
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ mutant, mutationInd ] =  multiMutationFnc( individual, gridMask,...
%                                   mutations )
%
% INPUTS:
%
%   individual =    [1 x m] array of index values listing the connected 
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
%                   individual
%
% OUTPUTS:
%
%   mutant =        [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   mutationInd =   [s x 1] scalar value indicating the index number of the
%                   individual at which the mutation occcurred
%
% EXAMPLES:
%   
%   Example 1 =         
%
%                   % Pass 'individual' and 'gridMask' input arguments as 
%                   output arguments from the crossover procedure
%
%                   mutations = 5;
%
%                   [mutant, mutationInd] = multiMutationFnc(individual,...
%                                               gridMask,mutations);
%
% CREDITS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                      %%
%%%                          Eric Daniel Fournier                        %%
%%%                  Bren School of Environmental Science                %%
%%%               University of California Santa Barbara                 %%
%%%                            September 2013                            %%
%%%                                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x) x == 3);
addRequired(p,'individual',@(x) isnumeric(x) && isrow(x) && ~isempty(x));
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));
addRequired(p,'mutations',@(x) isnumeric(x) && isscalar(x) && ~isempty(x));

parse(p,nargin,individual,gridMask,mutations);

%% Iteration Parameters

n = size(individual);
mutant = zeros(n);
mutationInd = zeros(mutations,1);

%% Compute Mutations 

for i = 1:mutations
    [individual, mutationInd(i,1)] = mutationFnc(individual,gridMask);
end

%% Generate Final Output

mutant(:,:) = individual;

end

