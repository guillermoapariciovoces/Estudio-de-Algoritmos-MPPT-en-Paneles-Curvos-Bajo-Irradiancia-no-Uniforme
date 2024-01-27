clc
clear
tipos={'Oscilacion Dinamica','Oscilacion Gradual','Bajada continua','Variacion Abrupta', 'Variacion Escalones'}; 
ninputs=5; % Inputs maximos a utilizar

%% Simulación PO
for i=1:ninputs
    tic
    i
    input=tipos{i};
    selector=i; % Variable utilizada en Simulink
    filename=strcat('..\04_Resultados\PO\PO_',input);
    PO=sim('Modelo_PO'); % Modelo de Simulink
    save(filename,'PO'); % Guardado de los resultados 
    toc
end

%% Simulación ANN
for i=1:ninputs
    tic
    i
    input=tipos{i};
    selector=i; % Variable utilizada en Simulink
    filename=strcat('..\04_Resultados\ANN\ANN_',input);
    ANN=sim('Modelo_ANN'); % Modelo de Simulink
    save(filename,'ANN'); % Guardado de los resultados 
    toc
end

