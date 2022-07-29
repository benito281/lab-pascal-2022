program NO_RULES_SRL;
uses crt;

type
    fecha = record
        anio : integer;
        mes : integer;
        dia : 4..6;
    end;

    hora = record
        hora: 8..14;
        min: 0..59;
        seg : 0..59;
    end;

    lan_traffic = record
        prot_Red :  1..3;
        prot_Transp : 1..2;
        puerto_Origen : longint; //(1..65535)
        puerto_Dest : longint; //(1..65535)
        horario : hora;
        dia : fecha;
        ipOrigen : string[15];
        ipDestino :  string[15];
    end;

    trafficParametro = file of lan_traffic; 

var 
    regTraffic : lan_traffic;
    traffic : trafficParametro;
    redweb, redftp, redSmtp, trweb, trftp, trSmtp, totweb, totftp, totsmtp, totred, totrans, totgeneralpaquetes: integer;
    guardored : 1..3;
	guardotransp : 1..2;

procedure Inicializar(VAR arch_local: trafficParametro);
    begin
                assign(arch_local, 'no_rules.dat');
                //Control de acciones sobre el archivo
                {$I-}				
                    reset(arch_local);				
                {$I+}
                //Verifico estado de la accion ejecutada
                if IOResult <> 0 then
                    writeln('No se pudo abrir el archivo... ERROR');
                
                redweb := 0;
                redftp := 0;
                redSmtp := 0;
                trweb := 0;
                trftp := 0;
                trSmtp := 0;
                totweb := 0;
                totftp := 0;
                totsmtp := 0;
                totred := 0;
                totrans := 0;
                totgeneralpaquetes := 0;
    end;

procedure corte_transp();
    begin
        writeln('Protocolo Transporte: ', guardotransp);
        writeln('Puerto Destino Web: ', trweb);
        writeln('Puerto Destino Ftp: ', trftp);
        writeln('Puerto Destino Smtp: ', trsmtp);
        writeln('Paquetes enviados al protocolo ',guardotransp,' : ', totrans);

        redweb := redweb + trweb;
        redftp := redftp + trftp;
        redsmtp := redsmtp + trsmtp;
        totred := totred + totrans;

        trweb := 0;
        trftp := 0;
        trsmtp := 0;
        totrans := 0;

        guardotransp := regTraffic.prot_Transp;
    end;

procedure corte_red();
     begin 
        corte_transp();
        writeln('Protocolo Red: ', guardored);
        writeln('Puerto Destino Web :', redweb);
        writeln('Puerto Destino Ftp :', redftp);
        writeln('Puerto Destino Smtp :', redsmtp);
        writeln('Paquetes enviados al protocolo de red: ', guardored, ':', totrans);
        
        totweb := totweb + redweb;
        totftp := totftp + redftp;
        totsmtp := totsmtp + redsmtp;
        totgeneralpaquetes := totgeneralpaquetes + totred;
        redweb := 0;
        redftp := 0 ;
        redsmtp := 0; 
        totred := 0;
        guardored := regtraffic.prot_red;
    end;



procedure InicializarArchivoParaVerAnalisis(var arch_local : trafficParametro);
    begin
                assign(arch_local, 'no_rules.dat');
                //Control de acciones sobre el archivo
                {$I-}				
                    reset(arch_local);				
                {$I+}
                //Verifico estado de la accion ejecutada
                if IOResult <> 0 then
                    writeln('No se pudo abrir el archivo... ERROR');         
    end;


begin
    Inicializar(traffic);
    while not EOF(traffic) do 
        begin
             read(traffic, regTraffic);
             guardored := regTraffic.prot_Red;
             guardotransp := regTraffic.prot_Transp;
             
             if regTraffic.prot_Red <> guardored then
                begin
                    corte_red;
                end
             else
                begin
                    if regTraffic.Prot_Transp <> guardotransp  then
                        corte_transp;
                end;

             case regTraffic.puerto_Dest of
                80 : trWeb := trWeb + 1; 
                21 : trFtp := trFtp + 1;  
                25 : trsmtp := trsmtp + 1;
             end;
             totrans := totrans + 1;
        end;
            
        writeln('Total de paquetes enviados a Web ', totweb);
        writeln('Total de paquetes enviados a Ftp ', totftp);
        writeln('Total de paquetes enviados a smtp ', totsmtp);
        writeln('Total de paquetes enviados a red ', totrans); //Para verificar
        writeln('Total general de paquetes enviados:', totgeneralpaquetes);
    close(traffic);

    //Procedimiento para ver los registros de paquetes con posibilidad de analisis de ataque
    InicializarArchivoParaVerAnalisis(traffic);
    writeln('Posibilidad de analisis de ataque');

    while not EOF(traffic) do
        begin
            read(traffic, regTraffic);
              if (regTraffic.puerto_Origen = 80) or (regTraffic.puerto_Origen = 21) or (regTraffic.puerto_Origen = 25) then
                begin    
                  writeln(regTraffic.prot_Red, ' | ', regTraffic.prot_Transp, ' | ', regTraffic.puerto_Origen, ' | ', regTraffic.puerto_Dest, ' | ', regTraffic.horario.hora, ':', regTraffic.horario.min, ':', regTraffic.horario.seg, ' | ', regTraffic.dia.dia, '/', regTraffic.dia.mes, '/', regTraffic.dia.anio, ' | ', regTraffic.ipOrigen, ' | ', regTraffic.ipDestino);  
                end;
        end;
    close(traffic);
    readln; 
end.
