%% Temp

figure(1);

subplot(4,1,1);
imagesc(sourceDistMask);

subplot(4,1,2);
imagesc(topCentroidsMask);

subplot(4,1,3);
imagesc(convexAreaMask);

subplot(4,1,4);
imagesc(eCentroidMask);

%%

basePoints(any(basePoints,2),:)
currentBasePoint
