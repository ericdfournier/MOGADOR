function [ individual ] = basePoints2WalkFnc(   basePoints,...
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
% [ individual ] = basePoints2WalkFnc( basePoints, basePointCount,...
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
    x == 2);
addRequired(P,'nargout',@(x)...
    x == 1);
addRequired(P,'basePoints',@(x)...
    isnumeric(x) &&...
    ismatrix(x)...
    && ~isempty(x));
addRequired(P,'gridMask',@(x)...
    isnumeric(x) &&...
    ismatrix(x)...
    && ~isempty(x));

parse(P,nargin,nargout,basePoints,gridMask);

%% Function Parameters

plot = 0;

%% Initialize Walk Procedure 

basePointCount = size(basePoints,1);
iterations = basePointCount-1;
sectionsFinal = cell(1,iterations);

for i = 1:iterations
    
    if i < iterations
        
        sections = pseudoRandomWalkFnc(gridMask,...
            basePoints(i,:),basePoints(i+1,:),plot);
        sections = sections(any(sections,1));
        sections = sections(1,1:end-1);
        sectionsFinal{1,i} = sections;
        
    elseif i == iterations
        
        sections = pseudoRandomWalkFnc(gridMask,...
            basePoints(i,:),basePoints(i+1,:),plot);
        sections = sections(any(sections,1));
        sections = sections(1,1:end);
        sectionsFinal{1,i} = sections;
    
    end
    
end

individual = [sectionsFinal{:,:}];

end