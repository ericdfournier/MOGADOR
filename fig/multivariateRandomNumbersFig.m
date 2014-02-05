%% Preliminaries

cd('/Users/ericfournier/Google Drive/PhD/Dissertation/Project/Genetic Algorithms/');

%% Generate Distribution Parameters

mu = zeros(8,2);

mu(1,:) = [-1 -1];
mu(2,:) = [-1 0];
mu(3,:) = [-1 1];
mu(4,:) = [0 -1];
mu(5,:) = [0 1];
mu(6,:) = [1 -1];
mu(7,:) = [1 0];
mu(8,:) = [1 1];

sigma = cell(1,3);

sigma{1,1} = [1 0; 0 1];
sigma{1,2} = [10 0; 0 10];
sigma{1,3} = [100 0; 0 100];

x1 = -1:0.1:1;
x2 = -1:0.1:1;
[X1,X2] = meshgrid(x1,x2);

%% Compute PDF Values

F = cell(8,3);

for i = 1:8
    
    for j = 1:3

        F_tmp = mvnpdf([X1(:) X2(:)],mu(i,:),sigma{1,j});
        F{i,j} = reshape(F_tmp,length(x2),length(x1));

    end
    
end

%% Plot Set

F1 = F(:,1);
F2 = F(:,2);
F3 = F(:,3);

figure();

for i = 1:8
    
    subplot(8,1,i);
    imagesc(F1{i,1});
    colorbar
    axis square
        
end

figure();

for i = 1:8
    
    subplot(8,1,i);
    imagesc(F2{i,1});
    colorbar
    axis square
        
end

figure();

for i = 1:8
    
    subplot(8,1,i);
    imagesc(F3{i,1});
    colorbar
    axis square
        
end