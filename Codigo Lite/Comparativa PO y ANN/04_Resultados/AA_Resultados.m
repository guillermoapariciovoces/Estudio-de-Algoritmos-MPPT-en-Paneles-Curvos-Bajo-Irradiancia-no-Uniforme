clc
clear

%%  Variables
sample_time=1e-3;
tipos={'Oscilacion Dinamica','Oscilacion Gradual','Bajada continua','Variacion Abrupta', 'Variacion Escalones'}; 
auxEPO=0;
auxEANN=0;

t=(5*sample_time):sample_time:60;

%% Plot potencia
for i=1:5
filename=strcat('.\PO\PO_',string(tipos(i)));
load(filename);

filename=strcat('.\ANN\ANN_',string(tipos(i)));
load(filename);

PO_E(i)=PO.E(end)/3600;
fprintf('Energia PO en %s: %.3f Wh\n',string(tipos(i)),(PO.E(end)/3600));

ANN_E(i)=ANN.E(end)/3600;
fprintf('Energia ANN en %s: %.3f Wh\n\n',string(tipos(i)),(ANN.E(end)/3600));

auxEPO=auxEPO+PO.E(end)/3600;
auxEANN=auxEANN+ANN.E(end)/3600;

plotname='Potencia';
figure(i);
plot(t,PO.P(6:1:end)); hold on
plot(t,ANN.P(6:1:end)); hold off
title(plotname);
xlabel('t(s)');
ylabel('P(W)');
filename=strcat('.\Imagenes\',string(tipos(i)),'_Potencia','.png');
saveas(gcf,filename);

% plotname='Tensión, ANN';
% figure(1);
% plot(t,V(:));
% title(plotname);
% xlabel('t(s)');
% ylabel('V(V)');
% filename=strcat('.\Imagenes\ANN_',string(tipos(i)),'_Tension','.png');
% saveas(gcf,filename);
% 
% plotname='Intensidad, ANN';
% figure(2);
% plot(t,I(:));
% title(plotname);
% xlabel('t(s)');
% ylabel('I(A)');
% filename=strcat('.\Imagenes\ANN_',string(tipos(i)),'_Intensidad','.png');
% saveas(gcf,filename);

end

%% Energy bar

x = categorical(tipos);
y=[PO_E;ANN_E]';
h=bar(x,[PO_E;ANN_E]','FaceColor','flat');
title('Comparativa')
xlabel('Entradas')
ylabel('Energía generada (Wh)')
set(h, {'DisplayName'}, {'P&O' 'ANN'}')
filename=strcat('.\Imagenes\','Comparativa','.png');
legend();
saveas(gcf,filename);

fprintf('Energia PO total: %.3f Wh\n',auxEPO);
fprintf('Energia ANN total: %.3f Wh\n\n',auxEANN);




