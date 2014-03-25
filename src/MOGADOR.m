function [ varargout ] = MOGADOR( varargin )

% MOGADOR.m Initializes a multi-objective genetic algorithm for the
% solution of the corridor location problem. The user is required to supply
% an input parameter object (structure object) which specifies the source
% of the input data for the for the corridor location problem as well as a
% number of parameter values that are used to control the operation of the
% algorithm.
%
% DESCRIPTION:
%
%   Function to execute a multi-objective genetic search algorithm for use
%   in solving the corridor location problem within a discrete 2-D search
%   domain. The input parameter structure object contains information about
%   the search domain location and extent as well as information about the
%   objective variables and various algorithmic processes. 
%
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ popCell ] =       MOGADOR( varargin );
%
% INPUTS:
%
%   Type 1: 
%   
%   prmFilePath =     
%
%   Type 2:
%
%   prmFolderPath =
%
%   Optional Arguments: 
%
%
%   
%
% OUTPUTS:
%
%   popCell =           [j x k] double array containing the grid index 
%                       values of the individuals within the population 
%                       (Note: each individual corresponds to a connected 
%                       pathway from the source to the destination grid 
%                       cells within the study area)
%
% EXAMPLES:
%   
%   Example 1:
%
%   [ popCell ] = MOGADOR();
%
%   % Executes the function on a previously specified demo problem with
%   % data layers and pre-tuned parameter values
%   
%   Example 2:
%       
%   [ popCell ] = MOGADOR('parameterFile.m');
%
%   % Executes the function on a user specified input parameter file stored
%   % in the 'prm' parameter sub directory of the MOGADOR toolbox file 
%   % system
%   
%   Example 3:
%   
%   [ popCell ] = MOGADOR('parameterFolder');
%
%   % Sequentially xecutes the function on all of the input parameter files
%   % contained within a the 'parameterFolder' sub directory contained
%   % within the 'prm' parameter sub directory of the MOGADOR toolbox file
%   % system
%
%   Example 4: 
%   
%   [ popCell ] = MOGADOR('parameterFolderName','Surpress Output');
%
%   Example 5: 
%
%   [ popCell ] = MOGADOR('parameterFile.m','Plot Figures');
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

addRequired(
end

