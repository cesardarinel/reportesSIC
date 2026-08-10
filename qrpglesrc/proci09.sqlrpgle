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
      * 20/05/2009             retorna si el cliente aplica par el cicla
      *                                                              *
      ****************************************************************
     Ftabcicla2 if a e           k Disk
      ****************************************************************
     c     *entry        plist
     c                   parm                    cldoc            18
     c                   parm                    canucr           15
     c                   parm                    resulta          01
     C
     c* definicion de claves
     c     clav1         klist
     c                   kfld                    campo            18
     C
     c*-------------------------------------------------------------------------
     c                   move      ' '           resulta
     c                   movel     cldoc         campo
     c     clav1         chain     tabcicla2
     c                   if        %found()
     c                   move      accion        resulta
     c                   endif
     c
     c                   if        resulta=' '
     c                   move      *blanks       campo
     c                   movel     canucr        campo
     c     clav1         chain     tabcicla2
     c                   if        %found()
     c                   move      accion        resulta
     c                   endif
     c                   endif
     c                   if        resulta='S'
     c                   move      's'           resulta
     c                   endif
     c
     c                   if        estatu='I'
     c                   move      ' '           resulta
     c                   endif
     c
     c                   seton                                        lr
