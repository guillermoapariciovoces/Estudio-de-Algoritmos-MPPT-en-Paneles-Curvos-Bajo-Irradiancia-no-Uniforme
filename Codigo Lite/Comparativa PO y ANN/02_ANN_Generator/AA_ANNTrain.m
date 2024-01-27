%clc;
clear;

%% Variables
ndatos=2000; %Numero de datos que se usaran en la simu, si se quieren todos ponga 0 o negativo
trainFcn = 'trainlm'; %Tipo de entrenamiento, para mas help nntrain
hiddenLayerSize = 8; %Numero de neuronas (puede ser un vector si se quieren varias capas)
%variables para el entrenamiento de la ANN 
trainRatio = 70/100;
valRatio = 15/100;
testRatio = 15/100;

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
%% Create a Fitting Network

net = fitnet(hiddenLayerSize,trainFcn);

net.divideParam.trainRatio = trainRatio;
net.divideParam.valRatio = valRatio;
net.divideParam.testRatio = testRatio;

clear testRatio trainRatio valRatio trainFcn hiddenLayerSize
%% Train the Network
[net,tr] = train(net,x,y);

%% Test the Network
yAll = net(x);
%e = gsubtract(t,y);
regression=regression(y,yAll);


yTrain = net(x(:,tr.trainInd));
yTrainTrue = y(tr.trainInd);
yVal =net(x(:, tr.valInd));
yValTrue=y(tr.valInd);
yTest = net(x(:,tr.testInd));
yTestTrue = y(tr.testInd);

errTrain=sqrt(mean((yTrain -yTrainTrue).^2));
errVal=sqrt(mean((yVal- yValTrue).^2));
errTest=sqrt(mean((yTest -yTestTrue).^2));
fprintf('Resultados de error:\n');
fprintf('Resultado de error de Train: %f\n',errTrain);
fprintf('Resultado de error de Val: %f\n',errVal);
fprintf('Resultado de error de Test: %f\n',errTest);
fprintf('Resultado de regesion: %f\n',regression);


%clear Ir_table Results_table T_table VI_table yTestRet ytest xtest yTrain yTrainTrue yVal yValTrue x y

save MPPT net