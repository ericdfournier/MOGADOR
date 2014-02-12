cd ~/Repositories/MOGADOR/fig/

%% Simulate Grid Mask

n = 100;
gridMask = zeros(n);
gridMask(:,1) = nan;
gridMask(1,:) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;

%% Parameters

gS = size(gridMask);
simObjCount = 1;
simMean = 5;
simRange = [1 1 1 10 10 10 100 100 100];
obj = zeros([gS 9]);

%% Perform Simulations and Generate Plot

figure();

for i = 1:size(obj,3)
    
    obj(:,:,i) = ...
        simObjectivesFnc(simObjCount,simMean,simRange(1,i),gridMask);
    subplot(3,3,i);
    imagesc(obj(:,:,i));
    colorbar
    axis square
    
end