function [ objectiveVars ] = initObjectivesFnc( gridMask, varargin )

% initObjectivesFnc.m This function reformats the 2-D objective 
% variable arrays into a collection of column vectors. 
% 
%
% DESCRIPTION:
%
%   Function to reformat the individual 2-D arrays corresponding to each of
%   the problem's objective variables into a collection of column vectors
%   labeled as objectiveVars
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ objectiveVars ] =  initObjectivesFnc( gridMask, varargin )
%
% INPUTS:
%
%   gridMask =      [g x f] binary array with valid pathway grid cells 
%                   labeled as ones and invalid pathway grid cells labeled 
%                   as NaN placeholders
%
%   varargin =      [1 x n] cell array in which each cell contains the 
%                   [j x k] array corresponding to the objective function
%                   values for each of the grid cells contained within the
%                   study domain bounded by gridMask
%
% OUTPUTS:
%
%   objectiveVars = [r x s] array in which each column corresponds to a
%                   decision variable (s) and in which each row (r) 
%                   corresponds to a spatially referenced grid cell value 
%                   (covering the entire search domain)
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
%                   obj1 = randi([0 100],[100 100]);
%                   obj2 = randi([0 100],[100 100]);
%                   obj3 = randi([0 100],[100 100]);
%
%                   [objectiveVars] = initObjectivesFnc(gridMask,obj1,...
%                                       obj2,obj3);
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

%% Fixed Parameters

n = size(varargin);

%% Parse Inputs

p = inputParser;

addRequired(p,'nargin',@(x) x >= 2);
addRequired(p,'gridMask',@(x) isnumeric(x) && ismatrix(x) && ~isempty(x));

parse(p,nargin,gridMask);

%% Error Checking

for i = 1:n(1,2)
    if size(varargin{i}) ~= size(gridMask)
        tit='Each Input Matrix Must Have the Same Dimensions as gridMask';
        disp(tit);
        error(['Dimensions of matrices being concatenated are not ',... 
        'consistent']);
    else
    end
end

%% Iteration Parameters

m = size(gridMask);
r = m(1,1)*m(1,2);
objectiveVars = zeros(r,n(1,2));
        
%% Generate Final Outputs

for i = 1:n(1,2)
    tmp = reshape(varargin{i},[r 1]);
    objectiveVars(:,i) = tmp;
end

end