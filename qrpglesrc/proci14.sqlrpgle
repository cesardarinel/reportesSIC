**free
        //-------------------------------------------------------------------------
        //  Nombre del Fuente....: PROCI14
        //  Tipo del Fuente......: qrpglesrc
        //  Libreria del Fuente..: CARTACSRC
        //  Libreria del Objeto..: CARTACPGM
        //  Programador..........: Cesar Darinel Ortiz
        //  Fecha................: 12-01-2017
        //  Descripcion..........: Genera datos que se envian al Cicla    *
        //  Descripcion..........: Actualiza las tabla con la fecha de vencimiento
        //                         y el numero de cuotas,CARTACDAT/TABDATAC

        // Modificado por.......: Andres segundo Tavarez
        // Descripción..........: Actualizar el campos status cancelados por adjudi
        // Fecha Modificación...: 07 de febrero del 2017
        // Requerimiento........: 2017-63

        // Modificado por.......: Andres segundo Tavarez
        // Descripción..........: poner with nc al select
        // Fecha Modificación...: 07 de agosto  del 2017
        // Requerimiento........: 2017-484
        //---------------------------------------------------------------------
        //   REALIZADO POR.......: CESAR DARINEL ORTIZ
        //   DESCRIPCION.........: valido los ajudicados no cancelados para no agre
        //   Fecha...............: 21 de feb del 2018
        //   LUGAR...............: ACAP
        //   REQUERIMIENTO.......: 2018-105

        //  Nombre Fuente.......: PROCI14
        //   REALIZADO POR.......: CESAR DARINEL ORTIZ
        //   DESCRIPCION.........: Adjustar el monto atrazo de los castigados
        //   Fecha...............: 23/05/2017
        //   LUGAR...............: ACAP
        //   REQUERIMIENTO.......: 2017-417

        //   REALIZADO POR.......: CESAR DARINEL ORTIZ
        //   DESCRIPCION.........: Eliminar Montos de cancelados
        //   Fecha...............: 19 de mayo 2017
        //   LUGAR...............: ACAP
        //   REQUERIMIENTO.......: 2017-338


        //   REALIZADO POR.......: CESAR DARINEL ORTIZ
        //   DESCRIPCION.........: valido los ajudicados no cancelados para no agre
        //   Fecha...............: 21 de feb del 2018
        //   LUGAR...............: ACAP
        //   REQUERIMIENTO.......: 2018-105
        //  Tipo de Fuente......: Qrpglesrc
        //  Libreria............: Cartacsrc
        //  Descripcion.........: Actualiza las tabla con la fecha de vencimiento
        //                        y el numero de cuotas,CARTACDAT/TABDATAC
        //  Realizado por.......: Cesar Darinel Ortiz
        //  Fecha Realización...: 12 enero 2017
        //  Lugar...............: ACAP
        //  Requerimiento........: 2017-57

        //   REALIZADO POR.......: CESAR DARINEL ORTIZ
        //   DESCRIPCION.........: Agregar la tabla caadjudi
        //   Fecha...............: 17 de feb del 2017
        //   LUGAR...............: ACAP
        //   REQUERIMIENTO.......: 2017-138

        //   REALIZADO POR.......: CESAR DARINEL ORTIZ
        //   DESCRIPCION.........: Eliminar pasaportes de los reportes
        //   Fecha...............: 11 de abril 2017
        //   LUGAR...............: ACAP
        //   REQUERIMIENTO.......: 2017-286

        //  Fecha de Modificacion.: 12 de junio de 2019
        //  Modificado por........: José Marcano
        //  Tarea.................: 2019-291
        //  Motivo del Cambio.....: Poner el plazo en el que fue otorgado el presta
        //                          en meses

        //  Fecha de Modificacion.: 03 de febrero de 2021
        //  Modificado por........: Gustavo Henriquez
        //  Tarea.................: 2021-13
        //  Motivo del Cambio.....: Cambiar informacion de columnas reporte TRANSUN

        //---------------------------------------------------------------------
        // *************************************************************************
        //  Fecha de Modificacion.: 01 de mayo de 2024
        //  Modificado por........: Carlos Pérez
        //  Tarea.................: 2024-187
        //  Motivo del Cambio.....: Modificando actualización de monto de cuota
        //                          erróneo
        //  *************************************************************************
        //  Fecha de Modificacion.: 9 de octubre de 2024
        //  Modificado por........: Carlos Pérez
        //  Tarea.................: 2024-224
        //  Motivo del Cambio.....: reparando cambio monto cuota cuando existe
        //  *************************************************************************
        //  Fecha de Modificacion.: 8 de Enero de 2026
        //  Modificado por........: Carlos Pérez
        //  Tarea.................: 2025-773
        //  Motivo del Cambio.....: reparando cuotas en 0 y con data erronea
        //                          Eliminando actualización del Mon_cuo
        //  *************************************************************************

// entrada de datos
dcl-pi *n;
 empcod char(1);
 d char(2);
 m char(2);
 a char(4);
end-pi;

//---------------------------------------------------------------------
// proceso : para actualizar los estatus de los prestamos cancelados por ad
//---------------------------------------------------------------------
EXEC SQL
update CARTACDAT/TABDATAC A SET A.status='LEGAL' WHERE
NUMCTA IN
(SELECT a.canucr
FROM cartacdat.CAADJUDI a,cartacdat.cacredhist  b
WHERE ESTATUS='A' and a.canucr=b.canucr
and B.CAACAN=0 and anohis=:a and diahis=:d and meshis=:m)
WITH NC;

EXEC SQL
update CARTACDAT/TABCICLA A SET A.status='LEGAL' WHERE
NUMCTA IN
(SELECT a.canucr
FROM cartacdat.CAADJUDI a,cartacdat.cacredhist  b
WHERE ESTATUS='A' and a.canucr=b.canucr
and B.CAACAN=0 and anohis=:a and diahis=:d and meshis=:m)
WITH NC;

//---------------------------------------------------------------------
// EliminoPas: Elimino pasaportes de los reportes
// solo reportamos personas con cedula
//---------------------------------------------------------------------;
EXEC SQL
DELETE FROM CARTACDAT.TABDATAC WHERE NUMPAS <>' '
or TIPENT=''
WITH NC;
EXEC SQL
DELETE FROM CARTACDAT.TABCICLA WHERE NUMPAS <>' '
or TIPENT=''
WITH NC;

//****************Prestamos quedan con montos y estan cancelados

EXEC SQL
UPDATE CARTACDAT/TABCICLA A SET BALANCE = 0, MONTO_ATR = 0,
SAL_0129 = 0, SAL_3059 = 0, SAL_6089 = 0, SAL_90119 = 0, SAL_120
= 0, SAL_150 = 0, SAL_180 = 0 WHERE status='CANCELADO' WITH NC;


EXEC SQL
UPDATE CARTACDAT/TABDATAC A SET BALANCE = 0, MONTO_ULTI = 0,
MONTO_ATR = 0, SAL_0129 = 0, SAL_3059 = 0, SAL_6089 = 0,
SAL_90119 = 0, SAL_120 = 0, SAL_150 = 0, SAL_180 = 0 WHERE
status='CANCELADO' WITH NC;

//****************Prestamos Castgados con montos raros limpio castigos

EXEC SQL
UPDATE CARTACDAT/TABCICLA SET MONTO_ATR = BALANCE, SAL_0129 = 0,
SAL_3059 = 0, SAL_6089 = 0, SAL_90119 = 0, SAL_120 = 0, SAL_150 =
0, SAL_180 = BALANCE WHERE status='CASTIGADOS'
with nc;

EXEC SQL
UPDATE CARTACDAT/TABDATAC SET MONTO_ATR = BALANCE, SAL_0129 = 0,
SAL_3059 = 0, SAL_6089 = 0, SAL_90119 = 0, SAL_120 = 0, SAL_150 =
0, SAL_180 = BALANCE WHERE status='CASTIGADOS'
with nc;

//****************Busca el plazo del prestamo

EXEC SQL
UPDATE CARTACDAT/TABCICLA A SET CACOD1 = (SELECT
CASE WHEN FACTOR = 'A' THEN CACOD1*12
WHEN FACTOR = 'M' THEN CACOD1
WHEN FACTOR = 'D' THEN FLOOR(CACOD1/30) END
FROM CARTACDAT/CACREDIT WHERE CANUCR = A.NUMCTA)
WITH NC;
//*******Actualizacion de la columna NUM_CUO********************

EXEC SQL
UPDATE CARTACDAT/TABCICLA SET CACOD1 = NUM_CUO
WITH NC;

EXEC SQL
UPDATE CARTACDAT/TABCICLA A SET NUM_CUO = (SELECT
CASE WHEN FACTOR = 'A' THEN CACOD1*12
WHEN FACTOR = 'M' THEN CACOD1
WHEN FACTOR = 'D' THEN FLOOR(CACOD1/30) END
FROM CARTACDAT/CACREDIT WHERE CANUCR = A.NUMCTA)
WITH NC;

//*************** inserto la ultima fecha pagada *********************
EXEC SQL
update cartacdat.TABDATAC set fecha_ult=
ifnull((select PGAEMI||digits(PGMEMI)||digits(PGDEMI) from
cartacdat.capagos where canucr=NUMCTA
order by CANUDO desc FETCH FIRST 1 row only),'')   where
fecha_ult='';

EXEC SQL
update cartacdat.TABCICLA set fecha_ult=
ifnull((select PGAEMI||digits(PGMEMI)||digits(PGDEMI) from
cartacdat.capagos where canucr=NUMCTA
order by CANUDO desc FETCH FIRST 1 row only),'')   where
fecha_ult='';


*Inlr = *On;
return;
