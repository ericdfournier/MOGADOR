%% Preliminaries

cd ~/Repositories/MOGADOR/fig/

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
sigma{1,2} = [1.5 0; 0 1.5];
sigma{1,3} = [2 0; 0 2];

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

ind = [3 5 8 2 7 1 4 6];

figure(1);

for i = 1:9
    
    if i < 5
    
        subplot(3,3,i);
        pcolor(F1{ind(i),1});
        shading interp
        axis square off
        
    elseif i == 5
        
        subplot(3,3,i);
        axis off
        
    elseif i > 5
        
        subplot(3,3,i);
        pcolor(F1{ind(i-1),1});
        shading interp
        axis square off
        
    end
        
end

cmap = colormap;

%% Plot

figure(2);

subplot(1,3,1);
surfc(F1{3,1});
axis tight square
color = caxis;
zlimit = zlim;
shading interp

subplot(1,3,2);
surfc(F2{3,1});
axis tight square
caxis(color);
zlim(zlimit);
shading interp

subplot(1,3,3);
surfc(F3{3,1});
axis square tight
caxis(color);
zlim(zlimit);
shading interp


