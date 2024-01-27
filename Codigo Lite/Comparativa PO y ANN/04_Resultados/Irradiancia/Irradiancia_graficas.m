clear
clc
%%
out=sim("Irradiancia.slx");
save out.mat
% load("out.mat")

%%
t=0:1e-3:60;
data(:,1)=out.Oscilacion_Dinamica;
data(:,2)=out.Oscilacion_Gradual;
data(:,3)=out.Bajada_continua;
data(:,4)=out.Variacion_Abrupta;
data(:,5)=out.Variacion_Escalones;
tipos={'Oscilacion Dinamica','Oscilacion Gradual','Bajada continua','Variacion Abrupta', 'Variacion Escalones'}; 
%%
for i=1:5
figure(i)
plot(t,data(:,i));
filename=strcat('..\Imagenes\Irr_',string(tipos(i)),'.png');
saveas(gcf,filename);
end
