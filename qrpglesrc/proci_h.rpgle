      *******************************************************************
      *  Fecha de Modificacion: 17 de marzo 2026
      *  Modificado por.......: Lewis Durán
      *  Tarea................: 2022-461
      *  Motivo del Cambio....: Incluyendo PROCI15.
      *******************************************************************
**free

/IF NOT DEFINED(PROCI00)
    /define PROCI00

    // CL carga data a la QTEMP
    dcl-pr initQtemp extpgm('CA4CEN25P');
    end-pr;

    dcl-pr PROCI01 extpgm('PROCI01');
            diapro char(2);
            mespro char(2);
            anopro char(4);
    end-pr;

    dcl-pr PROCI07 extpgm('PROCI07');
            diapro char(2);
            mespro char(2);
            anopro char(4);
    end-pr;

    dcl-pr PROCI04 extpgm('PROCI04');
    end-pr;

     dcl-pr PROCI05 extpgm('PROCI05');
            diapro char(2);
            mespro char(2);
            anopro char(4);
            meses  char(12);
    end-pr;
    dcl-pr PROCI08 extpgm('PROCI08');
    end-pr;

    dcl-pr PROCI10 extpgm('PROCI10');
            diapro char(2);
            mespro char(2);
            anopro char(4);
    end-pr;

    dcl-pr PROCI14 extpgm('PROCI14');
            empcod char(1);
            diapro char(2);
            mespro char(2);
            anopro char(4);
    end-pr;

    dcl-pr PROCI15 extpgm('PROCI15');
            empcod char(1);
            diapro char(2);
            mespro char(2);
            anopro char(4);
    end-pr;

/endif
