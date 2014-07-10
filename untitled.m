%%

cd ~/Repositories/MOGADOR/
run ./prm/convexSmall.m

%%

gridMask = p.gridMask;
sourceIndex = p.sourceIndex;
destinIndex = p.destinIndex;
randomness = 10;

%%

test = pseudoRandomWalkFnc(sourceIndex,destinIndex,randomness,gridMask);
individualPlot(test,gridMask);