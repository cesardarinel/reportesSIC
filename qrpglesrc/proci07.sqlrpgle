      ****************************************************************
     HDEBUG
     hdatfmt(*eur) datedit(*dmy)
      *  Nombre Fuente..:  aho1005                                  *
      *  Tipo de Fuente.:  Programa Fuente RPG                       *
      *  Libreria.......:  juan                                      *
      *                                                              *
      *  Programador....:  Andres segundo Tavarez.                   *
      *  Fecha..........:  17 sept  del 2001                         *
      *  Hora...........:  19:07                                     *
      *  Lugar..........:  ACAP                                      *
      *                                                              *
      *  Modificado por.......: César Darinel Ortiz
      *  Descripción..........: Actualizar estatus y balance
      *  Fecha Modificación...: 02 de marzo del 2022
      *  Requerimiento........: 2022-81
      *
      *  Fecha de Modificacion.: 12 de junio de 2019                 *
      *  Modificado por........: José Marcano                        *
      *  Tarea.................: 2019-291                            *
      *  Motivo del Cambio.....: Compilar                            *
      *                                                              *
      *  Descripcion....:  Genera la Planilla                        *
      * ultimos cambios
      * Fecha                  Descripcion
      * 22/02/2007             Incluir caso de codeudor
      *                                                              *
      * Modificado por .....: Andres Segundo Tavarez
      * DESCRIPCION.........: Solo compilado por error de nivel
      * Fecha...............: 14 de abr del 2020
      * LUGAR...............: ACAP
      * REQUERIMIENTO.......: 2020-219
      *                                                              *
      * Fecha de Modificacion.: 02 de febrero del 2021              *
      * Modificado por........: Gustavo Henriquez                   *
      * Tarea.................: 2021-13                             *
      * Motivo del Cambio.....: Compilar                            *
      *
      *
      *                                                              *
      ****************************************************************
     Ftabcicla01ip a e           k Disk
      ****************************************************************
     c     *entry        plist
     c                   parm                    diaxx            02
     c                   parm                    mesxx            02
     c                   parm                    anoxx            04
     c*-------------------------------------------------------------------------
     c                   move      numcta        prestamos        15
     c                   call      'PROCI06'
     C                   parm                    diaxx
     C                   parm                    mesxx
     C                   parm                    anoxx
     C                   parm                    comenta
     C                   parm                    prestamos
     c*-------------------------------------------------------------------------
