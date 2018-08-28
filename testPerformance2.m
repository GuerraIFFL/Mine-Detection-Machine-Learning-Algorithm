function [Acuracy, IFinal, pos, yfit1, target] = testPerformance2(feature)

[imulti, img_binaria] = multiImages;

dataTest = feature(:, 1:299);
dataTestNorm = [normalize(dataTest(:,1:264)),dataTest(:,296:299)];

%Carregar os classificadores para o workspace
trainedModelGaussianSVM = load('C:\Users\Ivo\Dropbox\Tese (AM-IST) - Ivo Guerra\10-Scripts_Guerra\1-Metodologia_Proposta\Classificadores 264features\GaussianSVM.mat');
trainedModelFineTree = load('C:\Users\Ivo\Dropbox\Tese (AM-IST) - Ivo Guerra\10-Scripts_Guerra\1-Metodologia_Proposta\Classificadores 264features\FineTree.mat');
trainedModelFineKNN = load('C:\Users\Ivo\Dropbox\Tese (AM-IST) - Ivo Guerra\10-Scripts_Guerra\1-Metodologia_Proposta\Classificadores 264features\FineKNN.mat');
trainedModelEnsemble = load('C:\Users\Ivo\Dropbox\Tese (AM-IST) - Ivo Guerra\10-Scripts_Guerra\1-Metodologia_Proposta\Classificadores 264features\Emsemble.mat');
trainedModelCubicSVM = load('C:\Users\Ivo\Dropbox\Tese (AM-IST) - Ivo Guerra\10-Scripts_Guerra\1-Metodologia_Proposta\Classificadores 264features\CubicSVM.mat');



yfit1=[trainedModelCubicSVM.trainedModelCubicSVM.predictFcn(dataTestNorm(:,1:264)),dataTestNorm(:,265:268)];
yfit2=[trainedModelEnsemble.trainedModelEnsemble.predictFcn(dataTestNorm(:,1:264)),dataTestNorm(:,265:268)];
yfit3=[trainedModelFineKNN.trainedModelFineKNN.predictFcn(dataTestNorm(:,1:264)),dataTestNorm(:,265:268)];
yfit4=[trainedModelFineTree.trainedModelFineTree.predictFcn(dataTestNorm(:,1:264)),dataTestNorm(:,265:268)];
yfit5=[trainedModelGaussianSVM.trainedModelGaussianSVM.predictFcn(dataTestNorm(:,1:264)),dataTestNorm(:,265:268)];

target = feature(:,300);
Acuracy(1,1) = 1-sum(abs(target-yfit1(:,1)))/length(target);
Acuracy(2,1) = 1-sum(abs(target-yfit2(:,1)))/length(target);
Acuracy(3,1) = 1-sum(abs(target-yfit3(:,1)))/length(target);
Acuracy(4,1) = 1-sum(abs(target-yfit4(:,1)))/length(target);
Acuracy(5,1) = 1-sum(abs(target-yfit5(:,1)))/length(target);
pos = [];

for i=1:1:9775
   if yfit1(i,1)==1
      coordy = floor((yfit1(i,3)+yfit1(i,2))/2);
      coordx = floor((yfit1(i,5)+yfit1(i,4))/2);
      pos = [pos;coordx,coordy];
   end 
end

IFinal = insertMarker(imulti(:,:,1:3),pos);  % VER ISTO QUE ACHO QUE ESTÁ MAL
                                             % METER AS CONFUSION MATRIX


en