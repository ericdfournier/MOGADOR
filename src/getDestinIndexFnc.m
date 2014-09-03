function [ destinIndex ] = getDestinIndexFnc(   gridMaskGeoRasterRef, ...
                                                gridMask )
% getDestinIndexFnc.m Function which prompts the user to manually select the
% location of the destination index which will be used to initiate the 
% MOGADOR corridor location procedure
%
% DESCRIPTION:
%
%   Function which provides the user with a map of the gridMask region and
%   prompts the user to manually click on the map to generate the row
%   column indices of the destination location to be used in a following
%   corridor location procedure. 
% 
%   Warning: minimal error checking is performed.
%
% SYNTAX:
%
%   [ destinIndex ] =  getDestinIndexFnc(   gridMaskGeoRasterRef, ...
%                                           gridMask );
%
% INPUTS: 
%
%   gridMaskGeoRasterRef = {q} cell orientated geo raster reference 
%                       object providing spatial reference information for 
%                       the input gridMask data layer
%
%   gridMask =          [n x m] binary array with valid pathway grid cells 
%                       labeled as ones and invalid pathway grid cells 
%                       labeled as zero placeholders
%
% OUTPUTS:
%
%   destinIndex =       [1 x 2] row vector containing the row column
%                       indices of the destination location with respect to
%                       the gridMask data layer described by the 
%                       gridMaskGeoRasterRef object
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
addRequired(P,'gridMaskGeoRasterRef',@(x)...
    isa(x,'spatialref.GeoRasterReference'));
addRequired(P,'gridMask',@(x)...
    ismatrix(x) && ...
    ~isempty(x));

parse(P,nargin,nargout,gridMaskGeoRasterRef,gridMask);

%% Function Parameters

gS = gridMaskGeoRasterRef.RasterSize;

%% Generate Interactive Map Plot

fig1 = figure();

usamap(gridMaskGeoRasterRef.Latlim,gridMaskGeoRasterRef.Lonlim);
title(gca,'Select Destination Location');
geoshow(gridMask, gridMaskGeoRasterRef);
[destinLat, destinLon] = inputm(1);
close(fig1);

%% Generate Source Index Value

indices = 1:1:(gS(1,1)*gS(1,2));
indexMask = reshape(indices,gS);
indexVal = ltln2val(indexMask,gridMaskGeoRasterRef,destinLat,destinLon);
[rowInd, colInd] = find(indexMask == indexVal);
destinIndex = [rowInd colInd];

end