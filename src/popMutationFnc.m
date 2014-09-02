function [ outputPop ] = popMutationFnc(    inputPop,...
                                            mutationFraction,...
                                            mutationCount,...
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
%   inputPop =    [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   mutationFraction = [r] scalar indicating the fraction (ranging from 0 to 
%                   1) of the input that will be subject to the mutation 
%                   process 
%   
%   mutationCount = [s] scalar indicating the number of multi-point
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
    isscalar(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));

parse(P,nargin,nargout,inputPop,mutationFraction,mutationCount,...
    randomness,gridMask);

%% Iteration Parameters

popSize = size(inputPop,1);
gL = size(inputPop,2);
mF = floor(mutationFraction*popSize);
mutSum = 0;
mL = zeros(popSize,1);

while mutSum <= mF
    
    mI = datasample(1:1:popSize,1);
    mL(mI) = 1;
    mutSum = sum(mL);
    
end

outputPop = zeros(popSize,gL);

%% Compute Mutations

for i = 1:popSize
    
    if mL(i) == 1
        
        outputPop(i,:) = multiMutationFnc(inputPop(i,:),mutationCount,...
            randomness,gridMask);
        
    else
        
        outputPop(i,:) = inputPop(i,:);
        
    end
    
end

end