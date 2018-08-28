function [iMulti, target] = multiImages
iMulti=imread('8mm_multi_1.png');                           %%1:3 Imagem Vísivel 3camadas
iMulti(:,:,4)=rgb2gray(imread('8mm_multi_2.png'));          %%4 Imagem Térmica
iMulti(:,:,5)=rgb2gray(imread('8mm_multi_3.png'));          %%5:7 Canais Multiespetrais
iMulti(:,:,6)=rgb2gray(imread('8mm_multi_4.png'));
iMulti(:,:,7)=rgb2gray(imread('8mm_multi_5.png'));
target = imread('target.png');

