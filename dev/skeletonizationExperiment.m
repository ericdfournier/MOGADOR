%% Experimental Skeletonization Refinement for pseudoRandomWalkFnc.m

% Below is an expirimental additional cleaning procedure involving first 
% thickening then skeletonizing the paths. It does not seem to guarantee 
% path connectivity nor successful path completion. 

% for q = 1:m(1,1)
%     dirtyPath = pathways(q,any(pathways(q,:),1))';
%     emptyGrid = zeros(g);
%     emptyGrid(dirtyPath) = 1;
%     pathFill = find(bwmorph(emptyGrid,'thicken',Inf);
%     cleanSet = find(bwmorph(pathFill,'skel',Inf));
%     [~, ia, ~] = intersect(dirtyPath,cleanSet);
%     cleanPath = dirtyPath(ia)';
%     z = size(cleanPath);
%     pathways(q,:) = 0;
%     pathways(q,1:z(2)) = cleanPath;
% end