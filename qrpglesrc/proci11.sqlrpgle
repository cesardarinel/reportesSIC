      ****************************************************************
     HDEBUG
     hdatfmt(*eur) datedit(*dmy)
      *  Nombre Fuente..:  proci11                                  *
      *  Tipo de Fuente.:  Programa Fuente RPG                       *
      *  Libreria.......:  cartacsrc                                 *
      *                                                              *
      *  Programador....:  Andres segundo Tavarez.                   *
      *  Fecha..........:  23 Feb   del 2011                         *
      *  Hora...........:  19:07                                     *
      *  Lugar..........:  ACAP                                      *
      *                                                              *
      *  Descripcion....:  Determinar prestamos dejados de reportar  *
      *                    El archivo catabci, se creq con runqry, con
      *                    las condiciones de incluir  los prestamos
      *                    que fueron reportados en el antes y ahora no
      *                    se estan reportado, para que no se queden
      *                    enganchados
      *                                                              *
      * ultimos cambios
      * Fecha                  Descripcion
      * 17/01/2012             Parametros para cancelados            *
      *
      * Fecha de Modificacion.: 12 de junio de 2019
      * Modificado por........: José Marcano
      * Tarea.................: 2019-291
      * Motivo del Cambio.....: Compilar
      *
      * Modificado por .....: Andres Segundo Tavarez
      * DESCRIPCION.........: Solo compilado por error de nivel
      * Fecha...............: 14 de abr del 2020
      * LUGAR...............: ACAP
      * REQUERIMIENTO.......: 2020-219
      *
      *
      ****************************************************************
     Fcatabci   ip   e           k Disk    rename(catabci:catabci2)
     Ftabcicla04o  a E           K Disk
     Fcacredit  iF   E           K Disk
      ****************************************************************
     c     *entry        plist
     c                   parm                    empcod
     c                   parm                    dia               2
     c                   parm                    mes               2
     c                   parm                    ano               4
     C
     c* definicion de claves
     c     clav1         klist
     c                   kfld                    numcta
     c                   kfld                    relacion
     c
     c     clav2         klist
     c                   kfld                    empcod
     c                   kfld                    canucr
     C
     c                   exsr      lee_cacre
     c
     c     lee_cacre     begsr
     C                   MOVEL     NUMCTA        CANUCR
     c     clav2         chain     cacredit
     c                   if        cacavi=0
     c                   eval      status='Cancelado'
     c                   move      *blanks       fecha_ult
     c                   move      caacaN        campo4            4
     c                   move      camcaN        campo2            2
     c                   move      cadcaN        campo22           2
     c                   eval      fecha_ult=campo4+campo2+campo22
     c                   z-add     0             num_cuo
     c                   z-add     0             BALANCE
     c                   z-add     0             MONTO_ATR
     c                   z-add     0             SAL_0129
     c                   z-add     0             SAL_3059
     c                   z-add     0             SAL_6089
     c                   z-add     0             SAL_90119
     c                   z-add     0             SAL_120
     c                   z-add     0             SAL_150
     c                   z-add     0             SAL_180
     c                   write     REGCICL
     c                   else
     c                   call      'PROCI12'
     c                   parm                    empcod
     c                   parm      dia           diaz              2
     c                   parm      mes           mesz              2
     c                   parm      ano           anoz              4
     c                   parm                    canucr
     c                   endif
     c                   endsr
     c*-------------------------------------------------------------------------
