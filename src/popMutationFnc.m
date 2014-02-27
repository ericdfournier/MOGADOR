function [ outputPop, mutationInd ] = popMutationFnc(   inputPop,...
                                                        gridMask,...
                                                        fraction,...
                                                        mutations )

% popMutationFnc function to generate a child pathway from the 
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
%   [ outputPop, mutationInd ] =  popMutationFnc( inputPop,...
%                   fraction, gridMask )
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
%   fraction =      [r] scalar indicating the fraction (ranging from 0 to 
%                   1) of the input that will be subject to the mutation 
%                   process 
%   
%   mutations =     [s] scalar indicating the number of multi-point
%                   mutations to be processed for each individual within 
%                   the input population
%
% OUTPUTS:
%
%   ouputPop =      [1 x m] array of index values listing the connected 
%                   grid cells forming a pathway from a specified source to
%                   a specified target destination given the constraints of
%                   a specified study region
%
%   mutationInd =   [r*n x 1] cell array in which each cell contains a 
%                   [s x 1] array with the index values of the sites at 
%                   which point mutations were performed upon each 
%                   corresponding input individual     
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
%                   sourceIndex = [20 20];
%                   destinIndex = [80 80];
%                   iterations = 1000;
%                   sigma = [10 0; 0 10];
%                   plot = 0;
%                   [initialPop, genomeLength] = initializePopFnc(popSize,
%                                               gridMask,iterations,...
%                                               sigma,sourceIndex,...
%                                               destinIndex);
%               
%                   fraction = 0.25;
%                   mutations = 1;
%
%                   [ouputPop, mutationCount] = mutationFnc(inputPop,...
%                                               gridMask,fraction,...
%                                               mutations);
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
    x == 2);
addRequired(P,'inputPop',@(x)...
    isnumeric(x) &&...
    ismatrix(x) &&...
    ~isempty(x));
addRequired(P,'gridMask',@(x)...
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

parse(P,nargin,nargout,inputPop,gridMask,fraction,mutations);

%% Iteration Parameters

popSize = size(inputPop,1);
gL = size(inputPop,2);
f = floor(fraction*popSize);
s = randomsample(1:1:popSize,f);
mutPop = inputPop(s,:);
outputPop = zeros(f,gL);
mutationInd = zeros(f,popSize);

%% Compute Mutations

for i = 1:f
    [outputPop(i,:), mutationInd(i,1)] = multiMutationFnc(mutPop(i,:),...
        gridMask,mutations);
end

end