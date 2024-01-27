if exist('I','var') && exist('V','var')
    %figure(1)
    %clf
    n=find(I>=0);
    n=n(end);
    Vglobal=V(1:n);
    Iglobal=I(1:n);
    
    Pglobal=Vglobal.*Iglobal;
    n=find(Pglobal==max(Pglobal));
    Pmax=Pglobal(n);
    Vmp=Vglobal(n);
    Imp=Iglobal(n);


    subplot(211)
    plot(Vglobal, Iglobal,Vmp,Imp,'or')
    ylabel('Current (A)')
    title(sprintf('Global I-V & P-V characteristics\n'))


    subplot(212)
    plot(Vglobal, Pglobal,Vmp,Pmax,'or')
    ylabel('Power (W)')
    xlabel('Voltage (V)')
    clear Iglobal Vglobal
end

