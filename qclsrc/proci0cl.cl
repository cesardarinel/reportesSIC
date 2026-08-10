/*------------------------------------------------------------------*/
/* Programa....:  PROCI0CL                                          */
/* DescripciÃ³n.:  Genera tablas para el cicla.                      */
/* Realizado Por: Segundo Tavares                                   */
/* Fecha de RealizaciÃ³n:    Ago. 03, 2007                           */
/* InstalaciÃ³n.........:      ACAP                                  */
/*                                                                  */
/* FECHA DE MODIFICACION.: 12 DE JUNIO DE 2019                      */
/* MODIFICADO POR........: JOSÃ MARCANO                             */
/* TAREA.................: 2019-291                                 */
/* MOTIVO DEL CAMBIO.....: COMPILAR                                 */
/*                                                                  */
/* FECHA DE MODIFICACION.: 01 DE JULIO DE 2019                      */
/* MODIFICADO POR........: JOSÃ MARCANO                             */
/* TAREA.................: 2019-384                                 */
/* MOTIVO DEL CAMBIO.....: CAMBIO DE ESTRUCTURA TRANSUNION          */
/*                                                                  */
/* MODIFICADO POR .....: ANDRES SEGUNDO TAVAREZ                     */
/* DESCRIPCION.........: SOLO COMPILADO POR ERROR DE NIVEL          */
/* FECHA...............: 14 DE ABR DEL 2020                         */
/* LUGAR...............: ACAP                                       */
/* REQUERIMIENTO.......: 2020-219                                   */
/*                                                                  */
/* FECHA DE MODIFICACION.: 02 DE FEBRERO DE 2021                    */
/* MODIFICADO POR........: GUSTAVO HENRIQUEZ                        */
/* TAREA.................: 2021-13                                  */
/* MOTIVO DEL CAMBIO.....: COMPILAR                                 */
/*------------------------------------------------------------------*/
/* FECHA DE MODIFICACION.: 17 de marzo 2026                         */
/* MODIFICADO POR........: Lewis Durán                              */
/* TAREA.................: 2022-461                                 */
/* MOTIVO DEL CAMBIO.....: Quitar llamada al Proci15, para poner    */
/*                         desde Proci00 y pasar fecha              */
/*------------------------------------------------------------------*/
  PGM
  DCL        VAR(&EMP)  TYPE(*CHAR) LEN(1)
  DCL        VAR(&ini)  TYPE(*LGL) LEN(1)
  CHGVAR VAR(&emp) VALUE('1')
  CLRPFM TABCICLA
  CLRPFM TABCICLA02
  CLRPFM TABDATAC
  CLRPFM TABCICLAT

  ADDLIBLE @TA_LIB
  MONMSG CPF0000

 /* GENERA TRANUNION Y DATACREDITO */
      CALL PROCI00 PARM(&EMP &ini)

     IF COND(&ini) then(do)
/* GENERA TABLA TEMPORAL PARA SACARLO CON LA ESTRUCTURA NUEVA PARA TABCICLA*/
/*   CALL PROCI15    */
     STRPCO   PCTA(*NO)
          MONMSG   MSGID(IWS4010)
          STRPCCMD PCCMD('C:\MIGRACI\TRANS_DATC.DTF') PAUSE(*NO)

     STRPCO   PCTA(*NO)
          MONMSG   MSGID(IWS4010)
          STRPCCMD PCCMD('C:\MIGRACI\TRANS_CICLA.DTF') PAUSE(*NO)
     enddo
ENDPGM
