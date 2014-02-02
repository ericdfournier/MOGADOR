cd('/Users/ericfournier/Google Drive/PhD/Dissertation/Project/Genetic Algorithms/');

%% Simulate Grid Mask

n = 100;
gridMask = zeros(n);
gridMask(:,1) = nan;
gridMask(1,:) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;

%% Generate Source and Destination Indices

sourceIndex = [20 20];
destinIndex = [80 80];

gridMask(sub2ind([100 100],sourceIndex(1,1),sourceIndex(1,2))) = 2;
gridMask(sub2ind([100 100],destinIndex(1,1),destinIndex(1,2))) = 3;

%% Generate Figure

figure();

imagesc(gridMask);
axis square;
