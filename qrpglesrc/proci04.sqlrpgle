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
      *  Descripcion....:  Genera la Planilla                        *
      * ultimos cambios
      * Fecha                  Descripcion
      * 22/02/2007             Incluir caso de codeudor
      *                                                              *
      * Fecha de Modificacion.: 12 de junio de 2019                  *
      * Modificado por........: José Marcano                         *
      * Tarea.................: 2019-291                             *
      * Motivo del Cambio.....: Compilar                             *
      *
      * Fecha de Modificacion.: 02 de febrero del 2021               *
      * Modificado por........: Gustavo Henriquez                    *
      * Tarea.................: 2021-13                              *
      * Motivo del Cambio.....: Compilar                             *
      *
      ****************************************************************
     Ftabcicla03ip a e           k Disk
     Ftabcicla  uf a e           k Disk
      ****************************************************************
     c
     c     clavcicl      klist
     c                   kfld                    comenta18        18
     c
     c* modulo principal
     c*-------------------------------------------------------------------------
     c                   exsr      detalles
     c*-------------------------------------------------------------------------
     c     detalles      begsr
     c                   move      cldoc         comenta18
     c                   setoff                                       80
     C     clavcicl      SETLL     tabcicla
     c     clavcicl      reade     tabcicla                               80
     C     *IN80         DOWEQ     '0'
     c
     c**                 z-add     totmon        limite_cre (anulado a solicitud de Anny
     c* debe reportarse el monto del prestamo en lugar de la suma de todos sus montos
     c*
     c                   z-add     monmay        credi_anto
     c                   update    regcicl
     c
     c     clavcicl      reade     tabcicla                               80
     c                   enddo
     c                   endsr
     c*-------------------------------------------------------------------------
