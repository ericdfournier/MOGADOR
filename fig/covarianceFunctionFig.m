%% Generate Data

randomness = 10;
iter = 1:1:100;
dist = 1:1:100;
covGrid = meshgrid(iter,dist);

for i = 1:100
    
    for j = 1:100
        
        covGrid(i,j) = nthroot(dist(i),randomness)./ ...
            nthroot(iter(j),randomness);
        
    end
    
end

%% Plot Surface

scrn = get(0,'ScreenSize');
fig1 = figure(1);
set(fig1,'position',scrn);

surface(covGrid);
axis square;
xlabel('Search Iterations');
ylabel('Distance from Basis Solution');
zlabel('Covariance');

%% Plot PDF

sampleCount = 2;
iHat = linspace(1,100,sampleCount);
jHat = linspace(1,100,sampleCount);

plotGrids = cell(sampleCount,sampleCount);

for i = 1:size(iHat,2)
    
    for j = 1:size(jHat,2)
        
        sigma = [covGrid(iHat(i),jHat(j)) 0; 0 covGrid(iHat(i),jHat(j))];
        [X1, X2] = meshgrid(linspace(-1,1,100),linspace(-1,1,100));
        X = [X1(:) X2(:)];
        probVec = mvnpdf(X,mu,sigma);
        plotGrids{i,j} = reshape(probVec,[100 100]);
        
    end
    
end

%% Plot Surface

fig2 = figure();
set(fig2,'position',scrn);

reshape(plotGrids,[sampleCount^2 1]);

for k = 1:(sampleCount^2)

    subplot(sampleCount,sampleCount,k);
    surf(plotGrids{k});
    axis square;
    xlabel('X Dim');
    ylabel('Y Dim');
    zlabel('Probability Density');
    zlim([0 0.25]);

end