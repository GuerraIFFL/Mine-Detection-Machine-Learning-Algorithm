function [dataTrain, dataTrainNorm] = roiSelector

D = dir('*.mat');
S = cellfun(@load,{D.name});
[~, NrF] = size(S);
feature=[];
for i=1:1:NrF
   feature = [feature;S(i).feature];
end


comMina = feature(feature(:,300)==1,:);
[numMina, nfeatures] = size(comMina);
semMinaAux = feature(feature(:,300)==0,:);
[numSemMina, nfeatures2] = size(semMinaAux);
k = randperm (numSemMina);
semMina = semMinaAux (k(1:numMina),:);

dataTrain = [comMina; semMina];
dataTrainNorm = [normalize(dataTrain(:,1:264)),dataTrain(:,300)];
end

