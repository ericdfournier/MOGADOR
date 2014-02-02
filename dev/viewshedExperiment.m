%% Preliminaries

cd('/Users/ericfournier/Google Drive/PhD/Dissertation/Project/Genetic Algorithms/');
load gridMask.mat
gridMask = imresize(gridMask,2,'nearest');
sourceIndex = [75 100];
destinIndex = [210 200];
gridMask(isnan(gridMask)) = 10000;

%% Create Spatial Referencing Vector

gS = size(gridMask);
R = georasterref('rastersize',gS,'latlim', [0 .000000001], 'lonlim', [0 .000000001]);
worldmap(gridMask,R)

%% Determine Source and Destination Lat/Lon

sourceLAT = sourceIndex(1,1).*R.DeltaLat;
sourceLON = sourceIndex(1,2).*R.DeltaLon;
destinLAT = destinIndex(1,1).*R.DeltaLat;
destinLON = destinIndex(1,2).*R.DeltaLon;

%% Compute Viewsheds

sourceView = viewshed(gridMask,R,sourceLAT,sourceLON);
sourceView(sourceIndex(1,1),sourceIndex(1,2)) = 10;
destinView = viewshed(gridMask,R,destinLAT,destinLON);
destinView(destinIndex(1,1),destinIndex(1,2)) = 10;

%% Plot Viewsheds

fig1 = figure(1);
set(fig1,'position',[0 0 500 1500]);

subplot(3,1,1);
imagesc(gridMask);
axis square

subplot(3,1,2);
imagesc(sourceView);
axis square

subplot(3,1,3);
imagesc(destinView);
axis square