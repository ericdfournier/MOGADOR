function [ output ] = readEliteSetCsv(    eliteSetCsvFilepath, ...
                                          searchDomainCsvFilepath,...
                                          objectiveCount)
% readEliteSetCsv.m

rawSearchDomain = csvread(searchDomainCsvFilepath);
domainSize = size(rawSearchDomain);

rawEliteSet = csvread(eliteSetCsvFilepath);

chromosomeCount = size(rawEliteSet,1) ./ (objectiveCount+2);
chromosomeLength = size(rawEliteSet,2);

output = cell(1,3);
popMat = zeros(chromosomeCount,chromosomeLength);
fitMat = zeros(chromosomeCount,objectiveCount);
aggFitMat = zeros(chromosomeCount,1);

indices = 1:(objectiveCount+2):(chromosomeCount*(objectiveCount+2));

for i = 1:chromosomeCount
    for j = 1:chromosomeLength
        
                rowSub = rawEliteSet(indices(i),j);
                colSub = rawEliteSet(indices(i)+1,j);
                
                if rowSub <= 0 && colSub <= 0
                    curInd = 0;
                else
                    curInd = sub2ind(domainSize, rowSub ,colSub);
                end
                
                popMat(i,j) = curInd;
                fitMat(i,:) = sum(rawEliteSet((indices(i)+2):(indices(i)+1+objectiveCount),:),2)';
                aggFitMat(i,:) = sum(fitMat(i,:));

    end
end

output{1,1} = popMat;
output{1,2} = fitMat;
output{1,3} = aggFitMat;

end

