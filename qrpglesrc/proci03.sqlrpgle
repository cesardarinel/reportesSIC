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
      ****************************************************************
     Ftabcicla02uf a e           k Disk
      ****************************************************************
     c     *entry        plist
     c                   parm                    cldoc            18
     c                   parm                    montos           15 2
     c
     c* definicion de claves
     c
     c     clavmon       klist
     c                   kfld                    cldoc
     c
     c* modulo principal
     c*-------------------------------------------------------------------------
     c                   exsr      detalles
     c                   seton                                        lr
     c*-------------------------------------------------------------------------
     c*-------------------------------------------------------------------------
     c* detalles
     c*-------------------------------------------------------------------------
     c     detalles      begsr
     C     clavmon       chain     tabcicla02
     c                   if        %found()
     c                   add       1             cantidad
     c                   add       montos        totmon
     c                   exsr      determ
     c                   update    regcicl02
     c                   else
     c                   z-add     1             cantidad
     c                   z-add     montos        totmon
     c                   z-add     montos        monmay
     c                   write     regcicl02
     c                   endif
     c
     c                   endsr
     c*-------------------------------------------------------------------------
     c     determ        begsr
     c                   if        montos > monmay
     c                   z-add     montos        monmay
     c                   endif
     c                   endsr
     c*-------------------------------------------------------------------------
