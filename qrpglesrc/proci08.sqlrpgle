      ****************************************************************
     HDEBUG
     hdatfmt(*eur) datedit(*dmy)
     F*  Nombre del Fuente....: proci08
     F*  Tipo del Fuente......: qrpglesrc
     F*  Libreria del Fuente..: CARTACSRC
     F*  Libreria del Objeto..: CARTACPGM
     F*  Programador..........: Andres Segundo Tavarez
     F*  Fecha................: 17-09-2001
     F*  Descripcion..........: Genera datos que se envian al Cicla    *
     F*
      * Modificado por.......: Andres segundo Tavarez
      * DescripciÃ³n..........: Determinar el monto en atrasp monto_atr
      * Fecha ModificaciÃ³n...: 07 de febrero del 2017
      * Requerimiento........: 2017-63
      *---------------------------------------------------------------------
      *  Nombre Fuente..:  proci08                                  *
      *  Tipo de Fuente.:  Programa Fuente RPG                       *
      *  Libreria.......:  cartacsrc                                 *
      *                                                              *
      *  Programador....:  Andres segundo Tavarez.                   *
      *  Fecha..........:  17 sept  del 2001                         *
      *  Hora...........:  19:07                                     *
      *  Lugar..........:  ACAP                                      *
      *                                                              *
      *  Descripcion....:  Genera la Planilla                        *
      * ultimos cambios
      * Fecha                  Descripcion
      * 22/02/2007             generando datos para los buro
      *                                                              *
      * Modificado por.......: Cesar Darinel Ortiz
      * DescripciÃ³n..........: Compilar por que se modifico la tabla tabdatac
      * Fecha ModificaciÃ³n...: 12 de enero del 2017
      * Requerimiento........: 2017-57
      *   REALIZADO POR.......: CESAR DARINEL ORTIZ
      *   DESCRIPCION.........: Agregar la tabla caadjudi
      *   Fecha ModificaciÃ³n...: 12 de Feb del 2017
      *   LUGAR...............: ACAP
      *   REQUERIMIENTO.......: 2017-138
      *
      * Fecha de Modificacion.: 12 de junio de 2019
      * Modificado por........: JosÃ© Marcano
      * Tarea.................: 2019-291
      * Motivo del Cambio.....: Compilar
      *
      * Modificado por .....: Andres Segundo Tavarez
      * DESCRIPCION.........: Solo compilado por error de nivel
      * Fecha...............: 14 de abr del 2020
      * LUGAR...............: ACAP
      * REQUERIMIENTO.......: 2020-219
      *
      * Fecha de Modificacion.: 02 de febrero del 2021              *
      * Modificado por........: Gustavo Henriquez                   *
      * Tarea.................: 2021-13                             *
      * Motivo del Cambio.....: Compilar                            *
      *
      ****************************************************************
     Ftabcicla01ip a e           k Disk
     FCLDICL12  iF a e           k Disk
     Fclmcte    if a E           K Disk
     Fclpein    if a E           K Disk
     Fclprof    if a E           K Disk
     Fclocup    if a E           K Disk
     Fcacredit  if a E           K Disk
     Ftabdatac  UF a E           K Disk
      ****************************************************************
     D Fecha_          Ds                  Inz
     D  caavec                 1      4  0
     D  camvec                 5      6  0
     D  cadvec                 7      8  0
     Iregdata
     I              NUM_CUO                     NUMCUO
     C
     c* definicion de claves
     c     clavcte       klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     C
     c     clavCLDI      klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     c                   kfld                    TIPODIR           2 0
     c
     c     clavprof      klist
     c                   kfld                    CLprco                         Profesio
     c
     c     clavprof1     klist
     c                   kfld                    CLOCCO                         Ocupacio
     c
     c     clavcacre     klist
     c                   kfld                    empresa1          1
     c                   kfld                    canucr
     c*
     c                   move      comenta       cldoc
     c                   eval      unidad='RD$'
     c* Deberia ser
     c                   select
     c                   when      numsec11<=1
     c                   eval      esta01='N'
     c                   eval      esta02='Normal'
     c
     c                   when      numsec11>=2 and numsec11 <=3
     c                   eval      esta01='M'
     c                   eval      esta02='Mora'
     c
     c                   when      numsec11>=4
     c                   eval      esta01='V'
     c                   eval      esta02='Vencido'
     c
     c                   when      numsec11>=5
     c                   eval      esta01='L'
     c                   eval      esta02='LEGAL               '
     c                   endsl
     c
     c                   eval      forma_pago='M'
     c
     c                   exsr      lee_cte
     c
     C                   write     regdata
     c*-------------------------------------------------------------------------
      * ciclo que lee las cuentas a tratar por un cliente
     c*-------------------------------------------------------------------------
     c     lee_cte       begsr
     c* fecha de ingreso
     c     clavcte       chain     clmcte
     c                   move      clanal        ano               4
     c                   move      clmeal        mes               2
     c                   move      cldial        dia               2
     c                   eval      fecing=ano+'-'+mes+'-'+dia
     c
     c* fecha de nacimiento
     c     clavcte       chain     clpein
     c                   move      clanna        ano
     c                   move      clmena        mes
     c                   move      cldina        dia
     c                   eval      fecnac=ano+'-'+mes+'-'+dia
     C                   eval      empresa=CLEMDT                               empresa
     c
     C* localizando la direccion del trabajo
     C                   MOVE      02            TIPODIR
     C                   MOVE      *BLANKS       DIRECCIO_T
     c     clavCLDI      chain     CLDICL12
     C                   IF        %FOUND()
     C                   EVAL      DIRECCIO_T=%TRIM(CLDIRE)+%TRIM(CLDIR2)+
     C                                        %TRIM(CLDIR3)
     c                   eval      tel_trab=cltel1
     c                   endif
     c
     c* Localizando la profesion
     c     clavprof      chain     clprof
     c                   if        %found()
     c                   eval      profesion=CLPRDE
     c                   endif
     c
     c* Localizando la Ocupasion
     c     clavprof1     chain     clocup
     c                   if        %found()
     c                   eval      ocupacion=CLocde
     c                   endif
     c
     c* localizando la tasa del prestamos (no se reporta  en el cicla)
     c                   move      1             empresa1
     c                   movel     numcta        canucr
     c     clavcacre     chain     cacredit
     c                   eval      tasa=catino+caindi
     c
     c                   move      fecha_        FECVEN
     c                   if        FACTOR='M'
     c                   eval      numcuo=CACOD1
     c                   elseif    FACTOR='D'
     c                   eval      numcuo=CACOD1/30
     c                   elseif    FACTOR='A'
     c                   eval      numcuo=CACOD1*12
     c                   endif
     c
     c                   endsr
