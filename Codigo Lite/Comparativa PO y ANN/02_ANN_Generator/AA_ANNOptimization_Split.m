clc;
clear;

%% Variables
ndatos=2000; %Numero de datos que se usaran en la simu, si se quieren todos ponga 0 o negativo
trainFcn = 'trainlm'; %Tipo de entrenamiento, para mas help nntrain
layers = 10; %Numero de neuronas (puede ser un vector si se quieren varias capas)
minTrain=70;
maxTrain=94;

%% Import Data
try
    VI_table=readmatrix('../01_Caracterizacion/data/VItable.csv');
    Results_table=readmatrix('../01_Caracterizacion/data/VmpResulttable.csv');
    Ir_table=readmatrix('../01_Caracterizacion/data/Irtable.csv');
    T_table=readmatrix('../01_Caracterizacion/data/Ttable.csv');
catch
    fprintf(2,'No se encontraron datos.\n');
    return
end

Data= [VI_table, Ir_table , T_table, Results_table];
if ndatos>1
    r=unique(round((size(Data,1)-1).*rand(ndatos,1) + 1));
    while ndatos > numel(r)
        r(end+1)=round((size(Data,1)-1)*rand + 1);
        r=unique(r);
    end
    x= Data(r,1:4)';
    y= Data(r,5)';
else
x= Data(:,1:4)';
y= Data(:,5)';
end

clear Ir_table Results_table T_table VI_table Data r ndatos
%% Search best layer

bestRegression=0;
bestErr=1000;
ibestRegression=1;
ibestErr=1;
for i= minTrain:maxTrain

%defining the architecture of the Ann
hiddenLayerSize=layers;

net =fitnet(hiddenLayerSize,trainFcn); 

net.divideParam.trainRatio = i;
net.divideParam.valRatio = 100-i-5;
net.divideParam.testRatio = 5;

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
end
% gensim(net);
clear testRatio trainRatio valRatio trainFcn hiddenLayerSize bestErr bestRegression
clear x y yValTrue yVal yTrainTrue yTrain yTest yTestTrue yAll i tr
%% Resultados
figure(1)
plot(minTrain:maxTrain, rmse_train(minTrain:maxTrain)); hold on;
plot(minTrain:maxTrain, rmse_test(minTrain:maxTrain)); hold on;
plot(minTrain:maxTrain, rmse_val(minTrain:maxTrain)); hold off;
filename=strcat('..\04_Resultados\Imagenes\Error_split','.png');
saveas(gcf,filename);

figure(2)
plot(minTrain:maxTrain, regresion(minTrain:maxTrain));
filename=strcat('..\04_Resultados\Imagenes\Error_regresion_split','.png');
saveas(gcf,filename);


fprintf('\nResultados bestErr:\n');
fprintf('Numero Simulacion: %d\n', ibestErr);
fprintf('Resultado de error de Train: %f\n',rmse_train(ibestErr));
fprintf('Resultado de error de Val: %f\n',rmse_val(ibestErr));
fprintf('Resultado de error de Test: %f\n',rmse_test(ibestErr));
fprintf('Resultado de regresion: %f\n',regresion(ibestErr));


fprintf('\nResultados bestRegression:\n');
fprintf('Numero Simulacion: %d\n', ibestRegression);
fprintf('Resultado de error de Train: %f\n',rmse_train(ibestRegression));
fprintf('Resultado de error de Val: %f\n',rmse_val(ibestRegression));
fprintf('Resultado de error de Test: %f\n',rmse_test(ibestRegression));
fprintf('Resultado de regresion: %f\n',regresion(ibestRegression));


fprintf('\nSi los resultados le gustan use el comando para generar un archivo de simulink\n');
fprintf('gensim(net)\n');

