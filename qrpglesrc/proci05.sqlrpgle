      *-------------------------------------------------------------------------
      *  Nombre Fuente.......: PROCI05
      *  Tipo de Fuente......: Qrpglesrc
      *  Libreria............: Cartacsrc
      *  Descripcion.........: Genera la data del cicla
      *
      *  Realizado por.......: Andres segundo Tavarez.
      *  Fecha RealizaciÃ³n...: 17 sept  del 2001
      *  Lugar...............: ACAP
      *
      *  Fecha de Modificacion.: 12 de junio de 2019
      *  Modificado por........: JosÃ© Marcano
      *  Tarea.................: 2019-291
      *  Motivo del Cambio.....: Compilar
      *
      **********************************************************************************
      * ultimos cambios
      *   REALIZADO POR.......: CESAR DARINEL ORTIZ
      *   DESCRIPCION.........: Agregar la tabla caadjudi
      *   Fecha ModificaciÃ³n...: 12 de Feb del 2017
      *   LUGAR...............: ACAP
      *   REQUERIMIENTO.......: 2017-138
      * Modificado por.......: Cesar Darinel Ortiz
      * DescripciÃ³n..........: Cambiar montos prestamos compartidos
      * Fecha ModificaciÃ³n...: 2016-11-28
      * Requerimiento........: 2016-1043
      *
      *   REALIZADO POR.......: CESAR DARINEL ORTIZ
      *   DESCRIPCION.........: valido los ajudicados no cancelados para no agregarlos
      *   Fecha...............: 21 de feb del 2018
      *   LUGAR...............: ACAP
      *   REQUERIMIENTO.......: 2018-105
      *
      *
      * Modificado por.......: Cesar Darinel Ortiz
      * DescripciÃ³n..........: Agregar los estatus PROCI13
      * Fecha ModificaciÃ³n...: 2016-08-18
      * Requerimiento........: 2016-512
      *
      * Modificado por.......: Cesar Darinel Ortiz
      * DescripciÃ³n..........: Se convirtio a RPGLE y acepta 13 meses
      * Fecha ModificaciÃ³n...: 05 de febrero del 2016
      *
      * Modificado por.......: Lilian Garcia
      * Fecha ModificaciÃ³n...: 25 de Marzo de 2019
      * Requerimiento........: 2019-76
      * DescripciÃ³n..........: Guardar la cuota completa
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
      *
      *---------------------------------------------------------------------
      *******************************************************************
      *  Fecha de Modificacion: 11 de septiembre 2024
      *  Modificado por.......: Carlos Pérez
      *  Tarea................: 2024-217
      *  Motivo del Cambio....: Agregando los 05 (prestamos garantizados)
      *                         a los reportes de TU y DC
      *******************************************************************
      *  Fecha de Modificacion: 17 de marzo 2026
      *  Modificado por.......: Lewis Durán
      *  Tarea................: 2022-461
      *  Motivo del Cambio....: No incluir préstamos cancelados después
      *                         de fecha de corte.
      *******************************************************************
     HDEBUG
     hdatfmt(*eur) datedit(*dmy)
     Fcacred17  if a e           k Disk
     Fclmcte01  if a e           k Disk
     Fclpein    if a e           k Disk
     Fcacredit  if a e           k Disk    rename(rccredit:rccre)
     Fcaadjudi  if a e           k Disk    prefix(x)
     Fcaproduc  if   e           k Disk
     Fcldicl    if a e           k Disk
     Fccsfemta1 if a e           k Disk
     Fcacode04  if a e           k Disk
     Fclpeju    if   e           k Disk    prefix(x)
     f
     Ftabcicla  UF a E           K Disk
     F
     D meses           S              1    Dim(13)
     d
     dmesesx           s              2  0 dim(12) CTDATA PERRCD(12)
     d
      *---------------------------------------------------------------------
      *Entrada @dia @mes @aÃ±o @mese
      *---------------------------------------------------------------------
     c     *entry        plist
     c                   parm                    diaxx            02
     c                   parm                    mesxx            02
     c                   parm                    anoxx            04
     c                   parm                    meses
     c
     c*Definicion de claves
     c     clavcte       klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     c
     c     clavtar       klist
     c                   kfld                    campo11          11 0
     c
     c     clavcacod     klist
     c                   kfld                    empresa           1
     c                   kfld                    canucr
     c
     c     CLAsu1        klist
     c                   kfld                    empresa
     c                   kfld                    caprod
     c                   kfld                    casubp
     c     clavdire      klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     c                   kfld                    numsec            2 0
     c
     c     clavcte100    klist
     c                   kfld                    cldoc
     c
     c     clavcacan     klist
     c                   kfld                    empresa
     c                   kfld                    distip
     c
     c     clavcacre     klist
     c                   kfld                    empresa           1
     c                   kfld                    anoxx2            4 0
     c                   kfld                    mesx
     c
     c                   move      anoxx         ano__             4 0
     c                   move      mesxx         mes__             2 0
     c                   move      diaxx         dia__             2 0
     c
     c* modulo principal
     c*                                                                     ----
     c* Trabajamos con los 13 meses ya que en enero se toma diciembre
     c* del ano anterior.
     c                   move      anoxx         anoxx2
     c     1             do        13            ii                2 0
     c                   if        meses(ii)='X'
     c
     c                   z-add     ii            mesx
     c                   move      ii            mesyy             2
     c
     c* controlado para el mes de enero, use ano anterior
     c                   if        mesx=13
     c                   move      mesesx(12)    diayy             2
     c                   sub       1             anoxx2            4 0
     c                   move      anoxx2        anoxx
     c                   move      12            mesx
     c                   move      mesx          mesyy
     c                   move      '1'           pri               1
     c                   else
     c                   move      mesesx(ii)    diayy             2
     c                   endif
     c
     c                   exsr      inicio
     c                   exsr      detalles
     c                   endif
     c                   enddo
     c
     c                   move      '0'           *In45
     c                   move      *Zeros        fechacan_         8 0
     c     empcod        setll     caadjudi
     c     empcod        reade     caadjudi                               45
     c     *in45         doweq     '0'
     c
     c                   z-add     0             indi_             1 0
     c                   movel     xcanucr       canucr
     c     clavcacod     chain     cacredit
     c                   eval      fechacan_=caacan*10000+camcan*100+cadcan
     c                   if        fechacan_ > fechapro
     c                   z-add     1             indi_
     c                   endif
     c                   if        ano__=xCACANC and
     c                                   xCACNNC=mes__ and indi_ = 0
     c                   exsr      leecasaldia
     c                   endif
     c
     c     empcod        reade     caadjudi                               45
     c                   enddo
     c
     c                   seton                                        lr
     c*-------------------------------------------------------------------------
     c* inicio: inicio del proceso, y las fechas que se utilizan
     c*-------------------------------------------------------------------------
     c     inicio        begsr
     c                   seton                                        99
     c                   move      *blanks       comando          50
     c                   move      1             empresa
     c                   move      mesyy         mesx              2 0
     c                   move      diayy         diax              2 0
     c                   move      *blanks       feclimite        10
     c                   move      *Zeros        fechapro          8 0
     c
     c
     c                   eval      feclimite=anoxx+mesyy+diaxx
     c                   eval      fechapro=ano__*10000+mes__*100+dia__
     c                   endsr
     c*-------------------------------------------------------------------------
     c* detalles: Leer los datos del cacredit
     c*-------------------------------------------------------------------------
     c     detalles      begsr
     c
     c                   setoff                                       80
     c                   move      *blanks       canucr
     C     clavcacre     SETLL     cacred17
     C     *IN80         DOWEQ     '0'
     C     clavcacre     reade     cacred17                               80
     c
     c                   movel     canucr        ds                2 0
     c                   move      *Zeros        fechacan          8 0
     c                   eval      fechacan=caacan*10000+camcan*100+cadcan
     c
     c                   if        *in80 or distip=8 or casubp=16
     c                                   or ds=08
     c                                   or distip=24 or distip=25
     c                                   or fechacan > fechapro
     c                   iter
     c                   endif
     c
     c* fecha de aprobacion
     c                   move      CAAcoc        campo4            4
     c                   move      CAMcoc        campo2            2
     c                   move      caDcoc        campo22           2
     c                   eval      fec_aper=campo4+campo2+campo22
     c
     c                   exsr      leeclmcte                                    lee   cl
     c                   exsr      lee_tarjeta
     C                   MOVE      *BLANKS       CAMPO6            6
     C                   EVAL      CAMPO6=campo4+campo2
     c                   if        casubp=15
     c                   move      'S'           existe
     c                   endif
     c
     c                   if        campo6<'200203'  and existe='n'
     c                   iter
     c                   endif
     c
     c                   if        feclimite>fec_aper or casubp=15
     c                   exsr      leecasaldia
     c                   endif
     c
     c                   enddo
     c
     c
     c                   endsr
     c*-------------------------------------------------------------------------
     c* leeclmcte: Localizando los datos del cliente
     c*-------------------------------------------------------------------------
     c     leeclmcte     begsr
     c     clavcte       chain     clmcte01
     c                   if        %found()
     c                   move      *blanks       campox           11
     C                   SELECT
     C     cltida        WHENEQ    'C'
     C                   MOVEL     'I'           tipent
     c                   evalr     campox=%subst(clnuid:1:3)+%subst(clnuid:5:7)
     c                                               +  %subst(clnuid:13:1)
     C                   MOVEL     CLNUID        CEDNUEVA
     c     clavcte       chain     clpein
     c                   exsr      lee_clpein
     c
     C     cltida        WHENEQ    'P'
     C                   MOVEL     'I'           tipent
     C                   MOVEL     CLNUID        NUMPAS
     c                   exsr      lee_clpein
     c
     C     cltida        WHENEQ    'R'
     C                   MOVEL     'E'           tipent
     c                   eval      nombre=clnomb
     C                   MOVEL     CLNUID        RNC
     c                   evalr     campox=%subst(clnuid:1:1)+%subst(clnuid:3:2)
     c                                               +  %subst(clnuid:6:5)
     c                                               +  %subst(clnuid:12:1)
     c                   clear                   siglas
     c                   clear                   CLNUID
     c     clavcte       chain     clpeju
     c                   if        %found()
     c                   movel     xclsigl       siglas
     c                   endif
     C                   ENDSL
     c                   endif
     c                   endsr
     c*-------------------------------------------------------------------------
     c* lee_clpein: Localizando los datos del cliente si es persona
     c*-------------------------------------------------------------------------
     c     lee_clpein    begsr
     c     clavcte       chain     clpein
     c                   eval      nombre=%trim(clino1)+' '+%trim(clino2) +','+
     c                                     %trim(cliap1)+' '+%trim(cliap2)
     c                   endsr
     c*-------------------------------------------------------------------------
     c* leecasaldia: localizando los datos del prestamos en el casaldia
     c*-------------------------------------------------------------------------
     c     leecasaldia   begsr
     c     CLAsu1        chain     caproduc
     c                   exsr      mover_campos
     c                   exsr      lee_codeud
     C                   endsr
     c*---------------------------------------------------------------------
     c* mover_campos:  completando los datos de la tabla del cicla
     c*-------------------------------------------------------------------------
     c     mover_campos  begsr
     c                   movel     canucr        numcta
     c                   z-add     cacavi        balance
     C                   MOVE      CLISEX        SEXO
     C                   MOVEL     CLNACI        NACIONA
     C                   MOVE      CLESCI        EST_CIVIL
     C                   MOVE      CLANNA        TEMPO4            4
     C                   MOVE      CLMENA        TEMPO2            2
     C                   MOVE      CLDINA        TEMPO22           2
     C                   Z-ADD     CLNUDE        NUM_DEP
     C                   EVAL      FECHA_NA=TEMPO4+TEMPO2+TEMPO22
     c
     c                   move      *blanks       fecha_ult
     c                   if        caacaN<>0
     c                   move      caacaN        campo4
     c                   move      camcaN        campo2
     c                   move      cadcaN        campo22
     c                   eval      fecha_ult=campo4+campo2+campo22
     c                   endif
     c
     c                   z-add     0             monto_atr
     c
     c                   if        PRPECN<>'S'
     c                   clear                   casain
     c                   endif
     c
     c* Localizando el monto de la cuota del mes
     c                   call      'CAMONPAG'
     c                   parm                    empresa
     c                   parm                    canucr
     c                   parm      0.00          moncap           13 2
     c                   parm      0.00          monint           13 2
     c                   parm      0.00          monmor           13 2
     c                   parm      0.00          monseg           13 2
     c                   eval      mon_cuo = moncap+monint+monseg
     c
     c                   z-add     camone        limite_cre                     para dej
     c                   z-add     camone        credi_anto                     igual al
     c*                  z-add     casain        mon_cuo                        principi
     c                   z-add     0             num_cuo
     c                   movel     cldoc         comenta
     c
     c                   exsr      lee_direc
     c                   exsr      lee_otros
     c
     C                   EXSR      LEE_CONYU
     c
     c                   movel     comenta       cldoc
     c                   eval      unidad ='RD$'
     c***pregunto si es compartido y veo que porciento nos toca
     c                   if        casubp=15 or casubp=16
     c*Reporte de Prestamos Compartidos
     c                   call      'INFOR81'
     c                   parm                    empcod
     c                   parm                    canucr
     c                   parm                    porci             7 2
      *
     c                   if        porci<>0
     c                   eval      mon_cuo=mon_cuo * ((100-porci)/100)
     c                   eval      credi_anto=credi_anto * ((100-porci)/100)
     c                   eval      limite_cre=limite_cre * ((100-porci)/100)
     c                   eval      monto_atr=monto_atr * ((100-porci)/100)
     c                   eval      BALANCE =BALANCE  * ((100-porci)/100)
     c                   endif
     c                   endif
     c******
     c                   write     regcicl
     c
     C
     C                   endsr
     c*-------------------------------------------------------------------------
     c* lee_codeud:  Localizando los datos del codeudor
     c*-------------------------------------------------------------------------
     c     lee_codeud    begsr
     c     clavcacod     chain     cacode04
     c                   if        %found()
     c*Genera la tabla del cicla con lso datos de los codeudores
     c                   call      'PROCI02'
     C                   parm      diayy         diaxx12           2
     C                   parm      mesyy         mesyy12           2
     C                   parm      anoxx         anoxx12           4
     C                   parm                    canucr
     C                   parm                    candcd
     c                   parm      'Cancelado'   estatus           9
     c                   endif
     C
     c                   clear                   regcicl
     C                   endsr
     c*-------------------------------------------------------------------------
     c*lee_conyu: Localizando los datos del conyugue
     c*-------------------------------------------------------------------------
     C     lee_conyu     begsr
     c                   if        cldocc<>*blanks
     c                   move      cldocc        cldoc
     c     clavcte       chain     clmcte01
     c                   movel     clnomb        nombre_con
     C                   MOVEL     CLNUID        ced_con
     c                   endif
     C                   endsr
     c*-------------------------------------------------------------------------
     c* lee_tarjeta: Verificando los datos de la tarjeta
     c*-------------------------------------------------------------------------
     c     lee_tarjeta   begsr
     c                   move      'n'           existe            1
     c                   if        campox<>*blanks
     c                   move      campox        campo11
     c     clavtar       chain     ccsfemta1
     c                   if        %found()
     c                   move      's'           existe
     c                   endif
     c                   endif
     c
     c
     c                   if        existe='n'
     c                   move      ' '           exis
     c* Datos de la tarjeta
     c                   call      'PROCI09'
     c                   parm                    cldoc
     c                   parm                    canucr
     c                   parm                    exis              1
     c
     c                   if        exis='s'
     c                   move      's'           existe
     c                   endif
     c                   endif
     C                   endsr
     c*-------------------------------------------------------------------------
     c* lee_direc: Localizando  la direccion
     c*-------------------------------------------------------------------------
     c     lee_direc     begsr
     c* Localizando la direccion
     c                   call      'CAPR0102'
     c                   parm                    cldoc
     c                   parm                    direccio1       120
     c                   parm                    direccio2       120
     c                   parm                    direccio3       120
     c                   parm                    direccio4       120
     c                   parm                    direccio5       120
     c                   eval      direccionr=%trim(direccio1)+' '+
     c                                        %trim(direccio2)+' '+
     c                                        %trim(direccio3)+' '+
     c                                        %trim(direccio4)+' '+
     c                                        %trim(direccio5)+' '
     C
     C
     c                   move      *blanks       tel_casal
     c                   move      *blanks       tel_trab
     c* Busca los telefono del cliente
     c                   call      'CAPR0101'
     c                   parm                    cldoc
     c                   parm                    telefono1        12
     c                   parm                    telefono2        12
     c                   parm                    telefono3        12
     c                   parm                    telefono4        12
     c                   parm                    telefono5        12
     c
     c                   movel     telefono1     tel_casal
     c                   movel     telefono2     tel_trab
     c
     C                   endsr
     c*-------------------------------------------------------------------------
     c* lee_otros: Seleccionando los letreros del prpoducto
     c*-------------------------------------------------------------------------
     c     lee_otros     begsr
     c                   select
     c                   when      CAPROD=1
     c                   eval      tipcta='Creditos Comerciales'
     c                   when      CAPROD=2
     c                   eval      tipcta='Creditos Consumo'
     c                   when      CAPROD=3
     c                   eval      tipcta='Creditos Hipotecarios'
     c                   endsl
     C
     c                   eval      relacion='Deudor'
     c* LLamada al programa que escribe el status
     c                   call      'PROCI13'
     c                   parm      '1'           empcod            1
     c                   parm                    CAcstc
     c                   parm                    status
     c*                  eval      status='Cancelado'
     C                   endsr
     c*-------------------------------------------------------------------------
** meses  vector almacena la cantidad de dias del mes
312831303130313130313031
