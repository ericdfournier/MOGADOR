function [ individual ] = basePoints2WalkFnc(   basePoints,...
                                                walkType,...
                                                gridMask )
                                            
% basePoints2WalkFnc.m Creates individual pseudo random walk sections
% connecting a list of base points generated during the population
% initialization procedure
%
% DESCRIPTION:
%
%   During population initialization, when a concave multi-part or
%   convex multi-part path must be generated a list of base points passing
%   through the search domain are generated. This function generates and
%   connects a set of path sections spanning the areas between the base
%   points in this list using the pseudo-random walk procedure. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
% [ individual ] = basePoints2WalkFnc( basePoints,walkType,...
%                                                gridMask )
%
% INPUTS:
%
%   basePoints =        [s x 2] array with the subscript values of the
%                       locations of base points from which a multi-part 
%                       pathway is to be generated. The first row in this 
%                       array should contain the subscripts corresponding 
%                       to the path's source and the last row of this array
%                       should contain the subscripts corresponding to the 
%                       path's final destination
%
%   walkType =          [0 | 1 | 2] decision variable indicating whether or not
%                       the path sections are to be constructed of
%                       pseudoRandomWalks, euclideanShortestWalks, or a
%                       random mixture of the two.
%                           0 : All pseudoRandomWalk
%                           1 : All euclShortestWalk
%                           2 : Random mixture of pseudoRandomWalk &
%                               euclShortestWalk                      
%
%   gridMask =          [n x m] binary array in which all grid cells that
%                       are contained within the allowed search domain 
%                       have a value of one and all other grid cells are 
%                       given a placeholder value of zero
%
% OUTPUTS:
%
%   individual =        [1 x r] array with the subscript indices of the
%                       path way connecting some initial source to some 
%                       final destination passing through an intermediate 
%                       series of base point locations
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
    x == 3);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'basePoints',@(x)...
    isnumeric(x) &&...
    ismatrix(x)...
    && ~isempty(x));
addRequired(P,'walkType',@(x)...
    isnumeric(x) &&...
    isscalar(x)...
    && ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x)...
    && ~isempty(x));

parse(P,nargin,nargout,basePoints,walkType,gridMask);

%% Function Parameters

basePointCount = size(basePoints,1);
iterations = basePointCount-1;
sectionsFinal = cell(1,iterations);

%% Initialize Walk Procedure 

for i = 1:iterations
    
    switch walkType
        
        case 0
            
            sections = pseudoRandomWalkFnc(...
                basePoints(i,:),basePoints(i+1,:),gridMask);
            
        case 1
            
            sections = euclShortestWalkFnc(...
                basePoints(i,:),basePoints(i+1,:),gridMask);
            
        case 2
            
            choice = randi([0 1],1);
            
            if choice == 0
                
                sections = pseudoRandomWalkFnc(...
                    basePoints(i,:),basePoints(i+1,:),gridMask);
                
            else
                
                sections = euclShortestWalkFnc(...
                    basePoints(i,:),basePoints(i+1,:),gridMask);
                
            end
            
    end
    
    sections = sections(any(sections,1));
    sections = sections(1,1:end-1);
    sectionsFinal{1,i} = sections;
    
end

individual = [sectionsFinal{:,:}];

end