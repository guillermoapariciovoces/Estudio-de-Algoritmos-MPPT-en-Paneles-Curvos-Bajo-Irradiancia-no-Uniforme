%% Parámetros de configuración
clc;
clear;
niteraciones=1; % Número de iteraciones
Data=readtable(".\data\Datos_irradiacion.csv");

%% Carga de datos anteriores
try
    VI_table=readmatrix('./data/VItable.csv');
    Vmp_Result_table=readmatrix('./data/VmpResulttable.csv');
    Ir_table=readmatrix('./data/Irtable.csv');
    T_table=readmatrix('./data/Ttable.csv');
catch
    fprintf(2,'No se encontraron datos previos.\nCreando tablas de resultados...\n');
    VI_table=[];
    Vmp_Result_table=[];
    Ir_table=[];
    T_table=[];
end
Tabla_errores = [];
%% Bucle de recolección de datos
% Selección de mes/día/hora
r=unique(round((size(Data,1)-1).*rand(niteraciones,1) + 1));
while niteraciones > numel(r)
    r(end+1)=round((size(Data,1)-1)*rand + 1);
    r=unique(r);
end
%%
for i=1:niteraciones
    tic;
    fprintf('Iteración %d de %d\n\n',i,niteraciones);

    % Creación de parámetros de simulación
    Irmax=Data.Global(r(i));
    Irmin=Data.Difusa(r(i));
    Ir=Irmin+(Irmax-Irmin)*rand;
    T=Data.Ta(r(i));

    try
        sim('ModeloPV'); % Modelo de simulink

        % Vmp
        Vmp_Result_table_aux=zeros(size(V,1),1);
        Vmp_Result_table_aux(:,1)= Vmp;

        % V e I
        VI_table_aux=[V,I];

        % Ir
        Ir_table_aux=zeros(size(VI_table_aux,1),1);
        Ir_table_aux(:,1)=Ir;

        % T
        T_table_aux=zeros(size(VI_table_aux,1),1);
        T_table_aux(:,1)=T;

        % Unión de tablas
        Vmp_Result_table=[Vmp_Result_table;Vmp_Result_table_aux];
        Ir_table=[Ir_table;Ir_table_aux];
        T_table=[T_table;T_table_aux];
        VI_table=[VI_table;VI_table_aux];


    catch
        fprintf(2,'\nError en la simulación número %d, fallo en simulink\n',i);
        Table_errs = [Table_errs; i];
    end
    toc;

    if(~(size(VI_table,1) == size(Ir_table,1)))
        error('Table size not equal');
    end


    fprintf('\n------------------------------------------------------------\n\n');
end
clear Vmod_table_aux Imod_table_aux Vmp_Result_table_aux Ir_table_aux ...
    T_table_aux VI_table_aux V1 V2 V3 V4 V5 I1 I2 I3 I4 I5 V I Vmp Imp Ir ...
    T Ta Pmax Pglobal Irmax Irmin G Vglobal r n i Data niteraciones tout

%% Guardado de las tablas
writematrix(VI_table,'./data/VItable.csv');
writematrix(Vmp_Result_table,'./data/VmpResulttable.csv');
writematrix(Ir_table,'./data/Irtable.csv');
writematrix(T_table,'./data/Ttable.csv');


