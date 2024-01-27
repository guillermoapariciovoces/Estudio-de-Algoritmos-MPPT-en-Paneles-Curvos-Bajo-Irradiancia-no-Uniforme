%clc;
clear;
%% Variables
trainFcn = 'trainlm'; %Tipo de entrenamiento, para mas help nntrain
maxLayer = 20; %Numero de neuronas (puede ser un vector si se quieren varias capas)
minLayer=5;
%variables para el entrenamiento de la ANN
trainRatio = 75/100;
valRatio = 20/100;
testRatio = 5/100;


%% Data import
Data=[];
allMeas=dir("Data\*.dat");
numMeas=size(allMeas,1);
tic
for i=1:numMeas
    dir=allMeas(i);
    dir.name=strcat('Data\',dir.name);
    opts = detectImportOptions(dir.name);
    opts.DataLines=[2 Inf];
    auxMeas=readmatrix(dir.name,opts);
    auxVmp=str2double(regexprep(auxMeas(7,2),',','.'));
    auxT=0;
    switch string(auxMeas(2,1))
        case 'RR1000'
            auxR= 1000;
        case 'RR2000'
            auxR= 2000;
        case 'RR3000'
            auxR= 3000;
        case 'RRFLAT'
            auxR= -1;
    end

    for j=11:14
        auxT= auxT+str2double(regexprep(auxMeas(2,j),',','.'));
    end
    for j=1:45
        auxData(:,j)=[str2double(regexprep(auxMeas((j+10),1),',','.')) str2double(regexprep(auxMeas((j+10),2),',','.')) auxT auxR auxVmp]';
    end
    Data=[Data;auxData'];
end
toc
fprintf('Se han importado los datos\n');


%% Search best layer
x= Data(:,1:4)';
y= Data(:,5)';

bestRegression=0;
bestErr=1000;
ibestRegression=maxLayer;
ibestErr=maxLayer;
for i= minLayer:maxLayer
    tic
    %defining the architecture of the Ann
    hiddenLayerSize=i;
    net =fitnet(hiddenLayerSize,trainFcn);

    net.divideParam.trainRatio = trainRatio;
    net.divideParam.valRatio = valRatio;
    net.divideParam.testRatio = testRatio;

    % training net
    [net, tr]= train(net, x, y);

    % determine the error of the Ann
    yTrain = net(x(:,tr.trainInd));
    yTrainTrue = y(tr.trainInd);
    yVal =net(x(:, tr.valInd));
    yValTrue=y(tr.valInd);
    yTest = net(x(:,tr.testInd));
    yTestTrue = y(tr.testInd);
    yAll = net(x);

    regresion(i)=regression(y,yAll);
    rmse_train(i) =sqrt(mean((yTrain-yTrainTrue).^2));
    rmse_val(i)= sqrt(mean((yVal-yValTrue).^2));
    rmse_test(i)= sqrt(mean((yTest-yTestTrue).^2));
    rmse_train_rel(i)=sqrt(mean(((yTrain-yTrainTrue)/yTrainTrue).^2));
    total_rmse(i)=rmse_test(i)+rmse_val(i)+rmse_train(i);

    if bestRegression<regresion(i)
        ibestRegression=i;
        bestRegression=regresion(i);
        save bestRegression net
    end
    if bestErr>total_rmse(i)
        ibestErr=i;
        bestErr=total_rmse(i);
        save bestErr net
        % gensim(net);
    end
    toc
end
% gensim(net);
clear testRatio trainRatio valRatio trainFcn hiddenLayerSize bestErr bestRegression
clear x y yValTrue yVal yTrainTrue yTrain yTest yTestTrue yAll i total_rmse tr
%% Resultados

figure(1)
plot(minLayer:maxLayer, rmse_train(minLayer:maxLayer)); hold on;
plot(minLayer:maxLayer, rmse_test(minLayer:maxLayer)); hold on;
plot(minLayer:maxLayer, rmse_val(minLayer:maxLayer)); hold off;
filename=strcat('.\Imagenes\Error','.png');
saveas(gcf,filename);

% figure(3)
% plot(minLayer:maxLayer, rmse_train_rel(minLayer:maxLayer));
% filename=strcat('.\Imagenes\Error_Rel','.png');
% saveas(gcf,filename);

figure(2)
plot(minLayer:maxLayer, regresion(minLayer:maxLayer));
filename=strcat('.\Imagenes\regresion','.png');
saveas(gcf,filename);
    
fprintf('\nResultados bestErr:\n');
fprintf('Numero Simulacion: %d\n', ibestErr);
fprintf('Resultado de error de Train: %f\n',rmse_train(ibestErr));
fprintf('Resultado de error de Val: %f\n',rmse_val(ibestErr));
fprintf('Resultado de error de Test: %f\n',rmse_test(ibestErr));
fprintf('Resultado de regresion: %f\n',regresion(ibestErr));
fprintf('Resultado de error total: %f\n',rmse_train_rel(ibestErr));

fprintf('\nResultados bestRegression:\n');
fprintf('Numero Simulacion: %d\n', ibestRegression);
fprintf('Resultado de error de Train: %f\n',rmse_train(ibestRegression));
fprintf('Resultado de error de Val: %f\n',rmse_val(ibestRegression));
fprintf('Resultado de error de Test: %f\n',rmse_test(ibestRegression));
fprintf('Resultado de regresion: %f\n',regresion(ibestRegression));
fprintf('Resultado de error total: %f\n',rmse_train_rel(ibestRegression));


