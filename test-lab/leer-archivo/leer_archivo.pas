program leerRules;
uses crt;

type
	fecha = record
		anio: integer;
		mes: integer;
		dia : 4..6;
	end;
    hora = record
		hora: 8..15;
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

	archivo_noRules = file of lan_traffic;
    
    Procedure InicializarArchivo(VAR arch_local: archivo_noRules);
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
    var 
    reg: lan_traffic;
	arch: archivo_noRules; //Uso el tipo de dato definido
(* Here the main program block starts *)
begin
  InicializarArchivo(arch);
  writeln('Protocolo de red | Protocolo de transporte | Puerto origen | Puerto destino | Hora | Dia | IP origen | IP destino');
  while not eof(arch) do 
    begin
        read(arch, reg);
        writeln(reg.prot_Red, ' | ', reg.prot_Transp, ' | ', reg.puerto_Origen, ' | ', reg.puerto_Dest, ' | ', reg.horario.hora, ':', reg.horario.min, ':', reg.horario.seg, ' | ', reg.dia.dia, '/', reg.dia.mes, '/', reg.dia.anio, ' | ', reg.ipOrigen, ' | ', reg.ipDestino);
    end;
    close(arch);
  readkey;
  
end.