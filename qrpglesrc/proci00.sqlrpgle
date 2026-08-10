
        // *************************************************************************
        //  Fecha de Modificacion.: 02 de mayo de 2024
        //  Modificado por........: Carlos Pérez
        //  Tarea.................: 2024-187
        //  Motivo del Cambio.....: Solo Compilar y agregado comentario a procedimiento
        //                          PROCI14
        //  *************************************************************************
        //  Fecha de Modificacion.: 17 de marzo 2026
        //  Modificado por........: Lewis Durán
        //  Tarea.................: 2022-461
        //  Motivo del Cambio.....: Agregar PROCI15 para pasar fecha como parámetro.
        //  *************************************************************************
**free

Dcl-F proci00fm WORKSTN;

/copy QRPGLESRC,PROCI_H

//busco usuario para guardar en el log
Dcl-DS *N  PSDS;
      USER Char(10) Pos(254);
END-DS;

        //---------------------------------------------------------------------
        //entrada @empresa @año @mes
        //---------------------------------------------------------------------
dcl-pi *n;
 empcod char(1);
 ini char(1);
end-pi;

dcl-s meses char(12);

dcl-s diapro char(2);
dcl-s mespro char(2);
dcl-s anopro char(4);

*in03=*off;
Dow *IN03 = *off;
      ini='0';
      EXFMT panta01;
      If *In03;
            LEAVE;
      Endif;

      IF MESX<>0 and DIAX<>0 and ANOX<>0;
            EXSR proceso;
            Dow *IN12 = '0';
                  EXFMT panta02;
                  IF *IN12;
                        ini='1';
                        *In03 = *On;
                        LEAVE;
                  ENDIF;
            ENDDO;
      ELSE;
            EXFMT error;
      ENDIF;

      If *In03;
            LEAVE;
      Endif;

ENDDO;
*Inlr = *On;
return;

//proceso : Encarga de llamar en secuencia a los programa que llena
//la tabla que se envia al cicla
//---------------------------------------------------------------------

BEGSR proceso;
      //guardar en el log tabcicla3, historico de los usuarios que usaron el app
      exec sql
      insert into tabcicla3(
            ANOX,MESX,DIAX,USUARI,ANOY,MESY,DIAY,ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SEP,OCT,NOV,DIC)
      values(:anox,:mesx,:diax,:user,year(now()),month(now()),day(now()),
      :ENE,:FEB,:MAR,:ABR,:MAY,:JUN,:JUL,:AGO,:SEP,:OCT,:NOV,:DIC);
      diapro=%editc(diax:'X');
      mespro=%editc(mesx:'X');
      anopro=%editc(anox:'X');
      // //Crear tabla general del cicla
      PROCI01(diapro:mespro:anopro);
      // //Crear tabla con prestamos de arrastre
      PROCI07(diapro:mespro:anopro);

      // //Determina credito mas alto
       PROCI04();
       meses = *blanks;
       meses=ene+feb+mar+abr+may+jun+jul+ago+sep+oct+nov+dic+dic2;

      // //Crea tabla con prestamos cancelados
       PROCI05(diapro:mespro:anopro:meses);
      // //Genera los datos de DataCredito
       PROCI08();
      // //Adiciona campos faltantes a la tabla:  "DATACREDITO"
       PROCI10(diapro:mespro:anopro);
      // //MARCANDO ESTUS DE LOS CANCELADOS POR ADJUDICACION
      // //proceso para actualizar data para la fecha correspondiente
       PROCI14(empcod:diapro:mespro:anopro);
      //Llena TABCICLAT con nuevo formato
       PROCI15(empcod:diapro:mespro:anopro);
ENDSR;
