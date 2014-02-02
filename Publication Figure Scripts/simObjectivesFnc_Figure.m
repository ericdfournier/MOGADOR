cd('/Users/ericfournier/Google Drive/PhD/Dissertation/Project/Genetic Algorithms/');

%% Simulate Grid Mask

n = 100;
gridMask = zeros(n);
gridMask(:,1) = nan;
gridMask(1,:) = nan;
gridMask(end,:) = nan;
gridMask(:,end) = nan;

%% Generate Objective Variables

objectiveVars = simObjectivesFnc(3,5,100,gridMask);

%% Generate Plot Data

obj1 = reshape(objectiveVars(:,1),100,100);
obj2 = reshape(objectiveVars(:,2),100,100);
obj3 = reshape(objectiveVars(:,3),100,100);

%% Generate Plot 1

figure();

subplot(1,3,1);
imagesc(obj1);
colorbar
axis square

subplot(1,3,2);
imagesc(obj2);
colorbar
axis square

subplot(1,3,3);
imagesc(obj3);
colorbar
axis square

%% Randomly Generate Objective Variables

objectiveVars = simObjectivesFnc(3,5,10,gridMask);

%% Generate Plot Data

obj1 = reshape(objectiveVars(:,1),100,100);
obj2 = reshape(objectiveVars(:,2),100,100);
obj3 = reshape(objectiveVars(:,3),100,100);

%% Generate Plot 2

figure();

subplot(1,3,1);
imagesc(obj1);
colorbar
axis square

subplot(1,3,2);
imagesc(obj2);
colorbar
axis square

subplot(1,3,3);
imagesc(obj3);
colorbar
axis square

%% Randomly Generate Objective Variables

objectiveVars = simObjectivesFnc(3,5,1,gridMask);

%% Generate Plot Data

obj1 = reshape(objectiveVars(:,1),100,100);
obj2 = reshape(objectiveVars(:,2),100,100);
obj3 = reshape(objectiveVars(:,3),100,100);

%% Generate Plot 3

figure();

subplot(1,3,1);
imagesc(obj1);
colorbar
axis square

subplot(1,3,2);
imagesc(obj2);
colorbar
axis square

subplot(1,3,3);
imagesc(obj3);
colorbar
axis square






