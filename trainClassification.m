%----------------------------------------------------------------------------------------------------------
% 3. CLASSIFICA��O (Treino)
%----------------------------------------------------------------------------------------------------------
% Dados para a Neural Network
trainDataMatrix = feature(:, 1:264);
targetData = [feature(:,300),1-feature(:, 300)];
%Dados para SVM, Trees, KNN
trainData = array2table(feature(:, [1:264 300])); 
%----------------------------------------------------------------------------------------------------------
% 3.1 SVM
% Fun��o trainClassifierCubicSVM rertirada da APP Classification Learner
% sendo o SVM com maior Accuracy.
%----------------------------------------------------------------------------------------------------------
        
[CubicSVM, AccuracySVM] = trainClassifierCubicSVM(trainData);

%----------------------------------------------------------------------------------------------------------
% 3.2 KNN
% Fun��o trainClassifierFineKNN rertirada da APP Classification Learner
% sendo o KNN com maior Accuracy.
%----------------------------------------------------------------------------------------------------------

[FineKNN, AccuracyKNN] = trainClassifierFineKNN(trainData);

%----------------------------------------------------------------------------------------------------------
% 3.3 Decision Tree
% Fun��o trainClassifierFineTree rertirada da APP Classification Learner
% sendo a Tree com maior Accuracy.
%----------------------------------------------------------------------------------------------------------

[FineTree, AccuracyTree] = trainClassifierFineTree(trainData);

%----------------------------------------------------------------------------------------------------------
% 3.4 Deep Neural Network
% Fun��o trainDeepNeuralNetwork rertirada da APP Neural Net Pattern
% Recognition
%----------------------------------------------------------------------------------------------------------

DeepNeuralNetwork = trainDeepNeuralNetwork(trainDataMatrix, targetData);