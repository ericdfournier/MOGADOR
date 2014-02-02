%% Preliminaries

cd('/Users/ericfournier/Google Drive/PhD/Dissertation'); % Set local working directory

scrn = get(0,'screensize'); % Get screen size
rng('default'); % Set random number generator type
rng(12345); % Seed random number generator 

%% Generate 2D Simulation Grid

nPx = 100; nPy = 100; nP = nPx*nPy;
xSize = 1; ySize = 1; 
xMin = 0.5; yMin = 0.5;
GridSpecs = [nPx xMin xSize; nPy yMin ySize];
xy = makegrid(GridSpecs);

fig_1 = figure(1);
set(fig_1,'Position',scrn);
plot(xy(:,1),xy(:,2),'.','MarkerSize',10);
axis square
title('Grid nodes of 2D grid','FontWeight','Bold','FontSize',20);

%% Construct Covariance Matrix

r = 100; % Range of covariance model
C = exp(-3*squareform(pdist(xy))/r); % Compute covariance model

fig_2 = figure(2);
set(fig_2,'Position',scrn);
imagesc(C); colorbar;
title('Point-to-point covariance matrix','FontWeight','Bold','FontSize',20);

%% Generate 2D Realizations from a Multivariate Gaussian Distribution

nS = 100; % Set the number of realizations
m = repmat(5,[1 nPx*nPy]); % Random variables with means of 5 at nPx*nPy locations
YY = mvnrnd(m,C,nS);
% Generate realizations using the function mvnrnd
% # of rows = # of realizations or samples
% # of columns = # of locations or variables

mask = ones(100,100);
mask(:,1) = nan; mask(:,end) = nan; mask(1,:) = nan; mask(end,:) = nan;
mask = reshape(mask,1,10000);
mask = repmat(mask,100,1);
YY = YY.*mask;
% Mask out boundary rows and columns as nan values

%% Randomly Select a Simulated Realization for Display

iSim = randi([1 100],[6 1]); % Randomly select six simulation realizations
yyDisp = YY(iSim,:)'; % Select that realization from the simulated set

fig_3 = figure(3); 
set(fig_3,'Position',scrn);

for i = 1:6
    subplot(2,3,i);
    rastermap(GridSpecs,yyDisp(:,i),1,'cont',[],{'color','vbar'});
    axis square
    ylabel('X-coordinates','FontWeight','Bold','FontSize',20);
    xlabel('Y-coordinates','FontWeight','Bold','FontSize',20);
    tit = ['Correlated Gaussian Realization #',num2str(iSim(i))];
    title(tit,'FontWeight','Bold','FontSize',20);
end

%% Euclidean Shortest Path & Pseudo Random Walk Seeds

gridMask = zeros(100,100);
gridMask(:,1) = nan; gridMask(:,end) = nan; gridMask(1,:) = nan; gridMask(end,:) = nan;

w = nPx*nPy;
euclGenotype = zeros(nS,w);
euclPhenotype = zeros(nS,1);
euclMeanFitness = zeros(nS,1);
psrwGenotype = zeros(nS,w);
psrwPhenotype = zeros(nS,1);
psrwMeanFitness = zeros(nS,1);
runs = 25;
iterations = w;
sigma = [10 0; 0 10];
plotVal = 0;

tic
for i = 1:nS
    yySamp = reshape(YY(i,:),nPx,nPy);
    [sVal, sInd] = min(yySamp(:));
    [dVal, dInd] = max(yySamp(:));
    [sRow, sCol] = ind2sub([nPx nPy],sInd);
    [dRow, dCol] = ind2sub([nPx nPy],dInd);
    tmp1 = bresenham(gridMask,[sRow sCol],[dRow dCol]);
    tmp2 = size(tmp1);
    tmp3 = (w-tmp2(2));
    tmp4 = horzcat(tmp1,zeros(1,tmp3));
    euclGenotype(i,:) = tmp4; % Each row is a unique pathway
    euclPhenotype(i) = sum(YY(i,tmp1));
    euclMeanFitness(i) = euclPhenotype(i)/tmp2(1); 
    tmp5 = pseudoRandomWalkFnc(gridMask,runs,iterations,sigma,[sRow sCol],...
        [dRow dCol],plotVal); % THIS STILL NEEDS WORK...
    tmp6 = size(tmp5);
    tmp7 = (w-tmp6(2));
    tmp8 = horzcat(tmp5,zeros(1,tmp7));
    psrwGenotype(i,:) = tmp8;
    psrwPhenotype(i) = sum(YY(i,tmp5));
    psrwMeanFitness(i) = psrwPhenotype(i)/tmp6(1);
    disp(i)
end
toc

%% Compare Histograms of Average Euclidean Seed vs. Average Pseudo Random Walk Seed Fitness

fig_4 = figure(4);
set(fig_4,'Position',scrn);

subplot(1,2,1);
hist(euclMeanFitness);bgd
axis square
ylabel('Mean Objective Value for All Cells in Pathway','FontWeight','Bold','FontSize',20);
xlabel('Number of Pathways','FontWeight','Bold','FontSize',20);
tit = ['Distribution of Mean Fitness Values for 100 Euclidean Shortest Paths'];
title(tit,'FontWeight','Bold','FontSize',20);

subplot(1,2,2);
hist(psrwMeanFitness);
axis square
ylabel('Mean Objective Value for All Cells in Pathway','FontWeight','Bold','FontSize',20);
xlabel('Number of Pathways','FontWeight','Bold','FontSize',20);
tit =['Distribution of Mean Fitness Values for 100 Pseudo Random Walk Paths'];
title(tit,'FontWeight','Bold','FontSize',20);

%% Test GA Solver 


