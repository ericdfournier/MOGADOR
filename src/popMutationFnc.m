function [ outputPop ] = popMutationFnc(    inputPop,...
                                            fraction,...
                                            mutations,...
                                            randomness,...
                                            gridMask )

% popMutationFnc.m Function to generate a child pathway from the 
% single point crossover of two previously selected parent pathways.
%
% DESCRIPTION:
%
%   Function to randomly select a valid crossover sites for the production
%   of new child pathways from a population of previously selected parent 
%   pathways.
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ outputPop ] =  popMutationFnc(    inputPop,...
%                                       fraction,...
%                                       mutations,...
%                                       randomness,...
%                                       gridMask )
%
% INPUTS:
%
%   individual =    [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   fraction =      [r] scalar indicating the fraction (ranging from 0 to 
%                   1) of the input that will be subject to the mutation 
%                   process 
%   
%   mutations =     [s] scalar indicating the number of multi-point
%                   mutations to be processed for each individual within 
%                   the input population
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
%   ouputPop =      [1 x m] array of index values listing the connected 
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
    x == 5);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'inputPop',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'fraction',@(x)...
    isnumeric(x) &&...
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

parse(P,nargin,nargout,inputPop,fraction,mutations,randomness,gridMask);

%% Iteration Parameters

popSize = size(inputPop,1);
gL = size(inputPop,2);
mF = floor(fraction*popSize);
mS = randomsample(1:1:popSize,mF);
mutPop = inputPop(mS,:);
outputPop = zeros(mF,gL);

%% Compute Mutations

for i = 1:mF
    
    outputPop(i,:) = multiMutationFnc(mutPop(i,:),mutations,randomness,...
        gridMask);
    
end

end