program noRules;
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

    //Creo un tipo de dato para poder usar en los parametros
	archivo_noRules = file of lan_traffic;
    
    Procedure InicializarArchivo(VAR arch_local: archivo_noRules);
        begin
            assign(arch_local, 'no_rules.dat');
            //Control de acciones sobre el archivo
            {$I-}				
                rewrite(arch_local);				
            {$I+}
            //Verifico estado de la accion ejecutada
            if IOResult <> 0 then	  			  			
                    writeln('No se pudo abrir el archivo... ERROR');	  	
            
        end;
    var 
    reg: lan_traffic;
	arch: archivo_noRules; //Uso el tipo de dato definido
    opcion : char;
begin

 InicializarArchivo(arch);
 writeln('* Ingrese los datos del registro: *');
 writeln('');
 opcion := 's';
        while opcion <> 'n' do
            begin
                writeln('Ingrese el protocolo de red: ');
                writeln('1. IP');
                writeln('2. TCP');
                writeln('3. UDP');
                readln(reg.prot_Red);
                writeln('Ingrese el protocolo de transporte: ');
                writeln('1. IP');
                writeln('2. TCP');
                readln(reg.prot_Transp);
                writeln('Ingrese el puerto de origen: ');
                writeln('WEB: 80');
                writeln('FTP: 21');
                writeln('SMTP: 25');
                readln(reg.puerto_Origen);
                writeln('Ingrese el puerto de destino: ');
                writeln('WEB: 80');
                writeln('FTP: 21');
                writeln('SMTP: 25');
                readln(reg.puerto_Dest);
                writeln('Ingrese la hora desde las 8 a las 15 ');
                readln(reg.horario.hora);
                writeln('Ingrese los minutos: ');
                readln(reg.horario.min);
                writeln('Ingrese los segundos: ');
                readln(reg.horario.seg);
                writeln('Ingrese el dia del 04 al 06: ');
                readln(reg.dia.dia);
                writeln('Ingrese el mes de Julio: 07 ');
                readln(reg.dia.mes);
                writeln('Ingrese el anio: 2022');
                readln(reg.dia.anio);
                writeln('Ingrese la ip de origen: ');
                readln(reg.ipOrigen);
                writeln('Ingrese la ip de destino: ');
                readln(reg.ipDestino);
                write(arch, reg);
                ClrScr; //limpio pantalla
                writeln('Registro ingresado correctamente');
                writeln('Desea ingresar otro registro? (s/n)');
                readln(opcion);
            end;
            writeln('Proceso finalizado');

    close(arch);
    readln;
end.