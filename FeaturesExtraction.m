tic;
tempo_inicio = tic;
warning('off');
%----------------------------------------------------------------------------------------------------------
% 1. Inicialização das variaveis para o Sliding Windows
%----------------------------------------------------------------------------------------------------------
clear;
passo_Y=2;
passo_X=2;  
sizeROI=10;
[imulti, img_binaria] = multiImages;

nGrayLevels = 256;
vetorGrayLevels = (1:nGrayLevels)'; 

[y_max, x_max, d_max] = size(imulti);
feature=zeros(9775, 300);
nMaxRoi = ((240-sizeROI)/passo_X)*((180-sizeROI)/passo_Y);
contador=1;                                   %Número de Rois
%----------------------------------------------------------------------------------------------------------
% PROCESAMENTO DE CADA UMA DAS ROIS
% 2. EXTRAÇÃO DE CARACTERÍSTICAS
%----------------------------------------------------------------------------------------------------------
for x= 1:passo_X:x_max-sizeROI
    for y= 1:passo_Y:y_max-sizeROI
        %Rotina para contar o tempo de processamento
        tempo_parcial = toc;
        if tempo_parcial > 30
            disp(['Já realizou ' num2str(contador/nMaxRoi*100,3) '%']);
            tic;
        end
        
        ROI = imulti(y:y+sizeROI, x:x+sizeROI,:); %Imagem em Matlab é matriz (y,x)
        [x_roi, y_roi, d_roi] = size(ROI);
        contadorFeatures = 1;
    %----------------------------------------------------------------------------------------------------------
    % 1. Características 1.º Ordem (De cada um dos espetros)
    %----------------------------------------------------------------------------------------------------------
        for d=4:1:d_max                             %Processamente apenas aos canais TIR (d=4) e multi (d=5,6,7)
            
            Histograma = imhist(ROI(:,:,d));
            Prob = Histograma./(x_roi*y_roi);
            %1.1 Média
            feature(contador, contadorFeatures) = mean(reshape(ROI(:,:,d),x_roi*y_roi,1)); contadorFeatures=contadorFeatures+1;
            %Med = sum(Prob.*vetorGrayLevels);
            %1.2 Variância
            feature(contador, contadorFeatures) = sum(Prob.*(vetorGrayLevels-feature(contador, contadorFeatures-1)).^2); contadorFeatures=contadorFeatures+1;
            %1.3 Entropia
            %feature(contador, 3) = -sum(Prob.*log(Prob));
            feature(contador, contadorFeatures) = entropy(Prob); contadorFeatures=contadorFeatures+1;
            %1.4 Energia
            feature(contador, contadorFeatures) = sum(Prob.*Prob); contadorFeatures=contadorFeatures+1;
            %1.5 Simetria (Skewness)    Ver se está correto
            feature(contador, contadorFeatures) = skewness(Prob); contadorFeatures=contadorFeatures+1;
            %feature(contador, 6) = calculaSimetria(vetorGrayLevels, Prob, feature(contador, 1),feature(contador, 2) );
            %1.6 Curtose (Kurtosis)     Ver se está correto
            feature(contador, contadorFeatures) = kurtosis(Prob); contadorFeatures=contadorFeatures+1;
        end
    %----------------------------------------------------------------------------------------------------------
    % 2. Características 2.º Ordem (Método da Dependência de Níveis de Cinzento)
    %----------------------------------------------------------------------------------------------------------
        for d=4:1:d_max 
            dist=1;
            
            %GLCM dist=d e 0º
            glcm0 = graycomatrix(ROI(:,:,d), 'Offset', [0,dist]);
            stats0 = graycoprops(glcm0);
            %2.1.1 Contraste
            feature(contador, contadorFeatures) = stats0.Contrast; contadorFeatures=contadorFeatures+1;
            %2.1.2 Correlação
            if isnan(stats0.Correlation)
                feature(contador, contadorFeatures) = 0;
                contadorFeatures=contadorFeatures+1;
            else
                feature(contador, contadorFeatures) = stats0.Correlation;
                contadorFeatures=contadorFeatures+1;
            end
            %2.1.3 Energia
            feature(contador, contadorFeatures) = stats0.Energy; contadorFeatures=contadorFeatures+1;
            %2.1.4 Homogeneidade
            feature(contador, contadorFeatures) = stats0.Homogeneity; contadorFeatures=contadorFeatures+1;
            
            %GLCM dist=d e 45º
            glcm45 = graycomatrix(ROI(:,:,d), 'Offset', [-dist,dist]);
            stats45 = graycoprops(glcm45);
            %2.2.1 Contraste
            feature(contador, contadorFeatures) = stats45.Contrast; contadorFeatures=contadorFeatures+1;
            %2.2.2 Correlação
            if isnan(stats45.Correlation)
                feature(contador, contadorFeatures) = 0;
                contadorFeatures=contadorFeatures+1;
            else
                feature(contador, contadorFeatures) = stats45.Correlation;
                contadorFeatures=contadorFeatures+1;
            end
            %2.2.3 Energia
            feature(contador, contadorFeatures) = stats45.Energy; contadorFeatures=contadorFeatures+1;
            %2.2.4 Homogeneidade
            feature(contador, contadorFeatures) = stats45.Homogeneity; contadorFeatures=contadorFeatures+1;
            
            %GLCM dist=d e 90º
            glcm90 = graycomatrix(ROI(:,:,d), 'Offset', [-dist,0]);
            stats90 = graycoprops(glcm90);
            %2.3.1 Contraste
            feature(contador, contadorFeatures) = stats90.Contrast; contadorFeatures=contadorFeatures+1;
            %2.3.2 Correlação
            if isnan(stats90.Correlation)
                feature(contador, contadorFeatures) = 0;
                contadorFeatures=contadorFeatures+1;
            else
                feature(contador, contadorFeatures) = stats90.Correlation;
                contadorFeatures=contadorFeatures+1;
            end
            %2.3.3 Energia
            feature(contador, contadorFeatures) = stats90.Energy; contadorFeatures=contadorFeatures+1;
            %2.3.4 Homogeneidade
            feature(contador, contadorFeatures) = stats90.Homogeneity; contadorFeatures=contadorFeatures+1;
            
            %GLCM dist=d e 135º
            glcm135 = graycomatrix(ROI(:,:,d), 'Offset', [-dist,-dist]);
            stats135 = graycoprops(glcm0);
            %2.4.1 Contraste
            feature(contador, contadorFeatures) = stats135.Contrast; contadorFeatures=contadorFeatures+1;
            %2.4.2 Correlação
            if isnan(stats135.Correlation)
                feature(contador, contadorFeatures) = 0;
                contadorFeatures=contadorFeatures+1;
            else
                feature(contador, contadorFeatures) = stats135.Correlation;
                contadorFeatures=contadorFeatures+1;
            end
            %2.4.3 Energia
            feature(contador, contadorFeatures) = stats135.Energy; contadorFeatures=contadorFeatures+1;
            %2.4.4 Homogeneidade
            feature(contador, contadorFeatures) = stats135.Homogeneity; contadorFeatures=contadorFeatures+1;
        
        end
    %----------------------------------------------------------------------------------------------------------
    % 3. Características Ordem Superior (Método do Comprimento de Primitivas dos Niveis de Cinzento)
    % Toolbox adaptada de https://www.mathworks.com/matlabcentral/fileexchange/17482-gray-level-run-length-matrix-toolbox#feedbacks
    % [1] Xunkai Wei, Gray Level Run Length Matrix Toolbox v1.0,Software,Beijing Aeronautical Technology Research Center, 2007
    %----------------------------------------------------------------------------------------------------------
        %   3.1 Short Run Emphasis (SRE)
        %   3.2 Long Run Emphasis (LRE)
        %   3.3 Gray-Level Nonuniformity (GLN)
        %   3.4 Run Length Nonuniformity (RLN)
        %   3.5 Run Percentage (RP)
        %   3.6 Low Gray-Level Run Emphasis (LGRE)
        %   3.7 High Gray-Level Run Emphasis (HGRE)
        %   3.8 Short Run Low Gray-Level Emphasis (SRLGE)
        %   3.9 Short Run High Gray-Level Emphasis (SRHGE)
        %   3.10 Long Run Low Gray-Level Emphasis (LRLGE)
        %   3.11 Long Run High Gray-Level Emphasis (LRHGE)
        for d=4:1:d_max 
            %GLRL 0º
            glrlm0 = grayrlmatrix(ROI(:,:,d), 'NumLevels', 256, 'Offset', 1);
            statsRL0 = grayrlprops(glrlm0);
            feature(contador, contadorFeatures:contadorFeatures+10) = statsRL0; contadorFeatures=contadorFeatures+11;
            
            %GLRL 45º
            glrlm45 = grayrlmatrix(ROI(:,:,d), 'NumLevels', 256, 'Offset', 2);
            statsRL45 = grayrlprops(glrlm45);
            feature(contador, contadorFeatures:contadorFeatures+10) = statsRL45; contadorFeatures=contadorFeatures+11;
            
            %GLRL 90º
            glrlm90 = grayrlmatrix(ROI(:,:,d), 'NumLevels', 256, 'Offset', 3);
            statsRL90 = grayrlprops(glrlm90);
            feature(contador, contadorFeatures:contadorFeatures+10) = statsRL90; contadorFeatures=contadorFeatures+11;
            
            %GLRL 135º
            glrlm135 = grayrlmatrix(ROI(:,:,d), 'NumLevels', 256, 'Offset', 4);
            statsRL135 = grayrlprops(glrlm135);
            feature(contador, contadorFeatures:contadorFeatures+10) = statsRL135; contadorFeatures=contadorFeatures+11;
        end     
            
    %----------------------------------------------------------------------------------------------------------
    % 4. Deteção de figuras geométricas
    %----------------------------------------------------------------------------------------------------------
        %Linhas = edge (ROI);
        
        

    %----------------------------------------------------------------------------------------------------------
    % 5. Teste de classificação (Predictors/ Targets) Classes
    %----------------------------------------------------------------------------------------------------------
        
        feature(contador, 296:299) = [y, y+sizeROI, x, x+sizeROI];
        feature(contador, 300) = verifica_se_tem_mina(img_binaria(y:y+sizeROI, x:x+sizeROI));
       
        contador = contador+1;

    end
end
toc;

%----------------------------------------------------------------------------------------------------------
% Funções Auxiliares
%----------------------------------------------------------------------------------------------------------



function devolve=verifica_se_tem_mina(zona_da_imagem)
    percentagem_pixeis_um = sum(zona_da_imagem(:)>0.5) / (size(zona_da_imagem,1) * size(zona_da_imagem,2));
    if percentagem_pixeis_um > 0.5
        devolve = 1;
    else
        devolve = 0;
    end
end

%Cálculo Simetria (Skewness)
function SIM = calculaSimetria (vectorGray, Prob, Med, Var)
    term1 = Prob.*(vectorGray-Med).^3;
    term2 = sqrt(Var);
    SIM = term2^(-3)*sum(term1);
end

function valor=lacunaridade(ROI)
% implementar a facunaridade)
valor = 1;
end
%=====================================
