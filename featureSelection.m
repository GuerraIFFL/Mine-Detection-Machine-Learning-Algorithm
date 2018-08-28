function [fs, history] = featureSelection(dataTrainNorm)
X=dataTrainNorm(:,1:264);
y=dataTrainNorm(:,265);
% XT=X([1:638,913:1550],:);
% Xt=X([639:912,1551:1824],:);
% yT=y([1:638,913:1550]);
% yt=y([639:912,1551:1824]);



c = cvpartition(y,'k',10);
opts = statset('display','iter');
fun = @(XT,yT,Xt,yt) sum(yt ~= classify(Xt,XT,yT,'linear'));

[fs,history] = sequentialfs(fun,X,y,'cv',c,'options',opts,'direction','forward');

end


%featureOpt=feature(:,fs)
%featureOpt(:,13)=feature(:,300)