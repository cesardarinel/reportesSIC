      ****************************************************************
     HDEBUG
     hdatfmt(*ISO) datedit(*ymd)
     F*  Nombre del Fuente....: proci01
     F*  Tipo del Fuente......: qrpglesrc
     F*  Libreria del Fuente..: CARTACSRC
     F*  Libreria del Objeto..: CARTACPGM
     F*  Programador..........: Andres Segundo Tavarez
     F*  Fecha................: 17-09-2001
     F*  Descripcion..........: Genera datos que se envian al Cicla    *
     F*
      * Modificado por.......: Cesar Darinel Ortiz
      * DescripciÃ³n..........: cambiar el estatus por el xcacstc
      * Fecha ModificaciÃ³n...: 15 de mayo del 2017
      * Requerimiento........: 2017-338
     F*
      * Modificado por.......: Andres segundo Tavarez
      * DescripciÃ³n..........: Determinar el monto en atrasp monto_atr
      * Fecha ModificaciÃ³n...: 07 de febrero del 2017
      * Requerimiento........: 2017-63
     F*
      * Modificado por.......: Andres segundo Tavarez
      * DescripciÃ³n..........: Controlar el atraso de los prestasmos a termino
      * Fecha ModificaciÃ³n...: 13 de marzo   del 2017
      * Requerimiento........: 2017-242
     F*
      * Modificado por.......: Andres segundo Tavarez
      * DescripciÃ³n..........: Control los compartido solo reportar la proporcion
      * Fecha ModificaciÃ³n...: 24 - 10 -  2017
      * Requerimiento........: 2017-792
     F*
      * Modificado por.......: Lilian Garcia
      * Fecha ModificaciÃ³n...: 25 de Marzo de 2019
      * Requerimiento........: 2019-76
      * DescripciÃ³n..........: Guardar la cuota completa
      *
      * Fecha de Modificacion.: 12 de junio de 2019
      * Modificado por........: JosÃ© Marcano
      * Tarea.................: 2019-291
      * Motivo del Cambio.....: Compilar
      *
      * Fecha de Modificacion.: 02 de febrero del 2021
      * Modificado por........: Gustavo Henriquez
      * Tarea.................: 2021-13
      * Motivo del Cambio.....: Compilar
      *
      * Fecha de Modificacion.: 08 de Abril de 2025
      * Modificado por........: José Marcano
      * Tarea.................: 2025-123
      * Motivo del Cambio.....: Agregar ultralinea sin saldos
      *
     F***************************************************************************
      *  Nombre Fuente..:  proci01                                  *
      *  Tipo de Fuente.:  Programa Fuente RPG                       *
      *  Libreria.......:  cartacsrc                                 *
      *                                                              *
      *  Programador....:  Andres segundo Tavarez.                   *
      *  Fecha..........:  17 sept  del 2001                         *
      *  Hora...........:  09:07                                     *
      *  Lugar..........:  ACAP                                      *
      *                                                              *
      *  Descripcion....:  Genera datos que se envian al Cicla    *
      *
      *
      *---------------------------------------------------------------------
      *
      * ultimos cambios
      **********************************************************************
      *   REALIZADO POR.......: CESAR DARINEL ORTIZ
      *   DESCRIPCION.........: Agregar la tabla caadjudi
      *   Fecha...............:  17 Feb  del 2017                         *
      *   LUGAR...............: ACAP
      *   REQUERIMIENTO.......: 2017-138
      * Modificado por.......: Cesar Darinel Ortiz
      * DescripciÃ³n..........: Cambiar montos prestamos compartidos
      * Fecha ModificaciÃ³n...: 2016-11-28
      * Requerimiento........: 2016-1043
      *
      * Modificado por.......: Cesar Darinel Ortiz
      * DescripciÃ³n..........: Agregar los estatus PROCI13
      * Fecha ModificaciÃ³n...: 2016-08-18
      * Requerimiento........: 2016-512
      *
      * Fecha                  Descripcion
      * 22/02/2007             Incluir caso de codeudor
      *                                                              *
      *                        Andres Segundo TAvarez
      *                        15-03-2010
      *                        Controlar que no se reporten los prestamos
      *                        de la prvisora a terminos casubp=16
      *
      * 18/03/2010             Eliminar del reporte los prestamos
      *                        de feria castigados
      *                        ds=08
      *
      * 30/03/2010             Por Instrucciones de Anny Betemit, dejar
      *                        pasar o incluir todos los prestamos de la
      *                        previsora
      *
      * 11/06/2012             Andres Segundo Tavarez
      *                        Seleccionar direccion y telefono des modulo
      *                        capr01
      *
      * 25/02/2015             Andres Segundo Tavarez
      *                        Ajustar la cuota de los aterminos
      * 09/07/2015             Cesar Darinel Ortiz
      *                        No incluir cedula cuando cuando el cliente
      *                        tiene RNC
      *
      * 05/10/2015             Andres Segundo Tavarez
      *                        Eliminar los castigo
      *
      * Modificado por .....: Andres Segundo Tavarez
      * DESCRIPCION.........: Solo compilado por error de nivel
      * Fecha...............: 14 de abr del 2020
      * LUGAR...............: ACAP
      * REQUERIMIENTO.......: 2020-219
      *
      * Modificado por .....: Andres Segundo Tavarez
      * DESCRIPCION.........: No reportar caso estats 55
      * Fecha...............: 16 de nov del 2023
      * LUGAR...............: ACAP
      * REQUERIMIENTO.......: 2023-570
      *
      *
      ****************************************************************
      *******************************************************************
      *  Fecha de Modificacion: 11 de septiembre 2024
      *  Modificado por.......: Carlos Pérez
      *  Tarea................: 2024-217
      *  Motivo del Cambio....: Agregando los 05 (prestamos garantizados
      *                         a los reportes de TU y DC
      **********************************************************************
      *  Fecha de Modificacion: 29 de abril del 2025
      *  Modificado por.......: Lewis Durán
      *  Tarea................: 2025-106
      *  Motivo del Cambio....: Corrigiendo morosidad de prestamos a término
      *******************************************************************
      *  Fecha de Modificacion: 08 de diciembre 2025
      *  Modificado por.......: Carlos Pérez
      *  Tarea................: 2025-595
      *  Motivo del Cambio....: cambiando monto de cuota para que tome el
      *                         actual y no el futuro
      **********************************************************************
      *  Fecha de Modificacion: 23 de diciembre 2025
      *  Modificado por.......: Carlos Pérez
      *  Tarea................: 2025-773
      *  Motivo del Cambio....: arreglando monto de cuotas que aparecen en
      *                         cero para el corte a generar
      **********************************************************************
      *  Fecha de Modificacion: 12 de marzo 2026
      *  Modificado por.......: Lewis Durán
      *  Tarea................: 2022-461
      *  Motivo del Cambio....: Incluir créditos que no estaban cancelados
      *                         en la fecha de corte que se está generando.
      **********************************************************************
      *
     Fcasaldia  if   e           k Disk
     f
     Fcacredhistif   e           k Disk    prefix(x)
     Fcacredit  if   e           k Disk
     Fcahisp34  if   e           k Disk    prefix(x)
     Fclmcte01  if   e           k Disk
     Fcafympag  if   e           k Disk
     Fclpein    if   e           k Disk
     Fclpeju    if   e           k Disk
     Fcaproduc  if   e           k Disk
     F*ldeDi    if   e           k Disk
     Fcacantip  if   e           k Disk
     Fccsfemta1 if   e           k Disk
     Fcacodeud  if   e           k Disk
     f
     Ftabcicla  UF a E           K Disk
     F
     dfecha1           s               d
     dfecha2           s               d
     dvc               s             13  2 dim(7)
     d
     dmeses            s              2  0 dim(12) CTDATA PERRCD(12)
     d
     D fecven          Ds                  Inz                                  FECHA ve
     D  caavec                 1      4  0
     D  Gu0001y                5      5    Inz('-')
     D  camvec                 6      7  0
     D  Gu0002y                8      8    Inz('-')
     D  cadvec                 9     10  0
     d
     d* para la fecha del dia de hoy
     D fechoy          Ds                  Inz                                  FECHA ve
     D  cadvan                 1      4  0
     D  Gu1                    5      5    Inz('-')
     D  cadvme                 6      7  0
     D  Gu2                    8      8    Inz('-')
     D  cadvdi                 9     10  0
      ****************************************************************
     c     *entry        plist
     c                   parm                    diaxx            02
     c                   parm                    mesxx            02
     c                   parm                    anoxx            04
     c
     c     clavtem       klist
     c                   kfld                    empcod
     c                   kfld                    anox
     c                   kfld                    mesx
     c                   kfld                    diax
     c                   kfld                    canucr
     c
     c     clavcahis     klist
     c                   kfld                    empcod
     c                   kfld                    canucr
     c                   kfld                    anoxxc            4 0
     c                   kfld                    mesxxc            2 0
     c                   kfld                    diaxxc            2 0
     c
     c     clav_         klist
     c                   kfld                    empcod
     c                   kfld                    canucr
     c                   kfld                    ano___            4 0
     c                   kfld                    mes___            2 0
     c                   kfld                    dia___            2 0
     c* definicion de claves
     c     clavcte       klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     c
     c     clavcte_es    klist
     c                   kfld                    blanco            1
     c                   kfld                    cldocc
     c     clavtar       klist
     c                   kfld                    campo11          11 0
     c
     c     clavdire      klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     c                   kfld                    numsec            2 0
     c
     c     clavcte100    klist
     c                   kfld                    cldoc
     c
     c     clavcldide    klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     c
     c     clavcacan     klist
     c                   kfld                    empresa
     c                   kfld                    distip
     c
     c     clavcacre     klist
     c                   kfld                    empresa           1
     c                   kfld                    canucr
     c
     c     clavca        klist
     c                   kfld                    empresa           1
     c
     c     CLAsu1        klist
     c                   kfld                    empresa
     c                   kfld                    caprod
     c                   kfld                    casubp
     c
     c     clavconta     klist
     c                   kfld                    canucr
     c                   kfld                    transa            3
     c                   kfld                    anox
     c                   kfld                    mesx
     c                   kfld                    diax
     c
     c     clavcacod     klist
     c                   kfld                    canucr
     c
     c     clavjudi      klist
     c                   kfld                    empresa           1
     c                   kfld                    castlg
     c
     c     clavsaldia    klist
     c                   kfld                    empresa
     c                   kfld                    canucr
     c                   kfld                    anox
     c                   kfld                    mesx
     c                   kfld                    diax
     c
     c* modulo principal
     c
     c                   exsr      inicio
     c                   exsr      detalles
     c
     c* para los cancelados por adjudicacion
     c                   call      'PROCI40'
     c                   parm                    diaxx            02
     c                   parm                    mesxx            02
     c                   parm                    anoxx            04
     c                   seton                                        lr
     c*-------------------------------------------------------------------------
     c* inicio del proceso, paea los datos generales
     c*-------------------------------------------------------------------------
     c     inicio        begsr
     c                   seton                                        99
     c                   move      *blanks       comando          50
     c                   move      1             empresa
     c                   move      anoxx         anox              4 0
     c                   move      mesxx         mesx              2 0
     c                   move      diaxx         diax              2 0
     c                   move      *blanks       feclimite        10
     c                   eval      feclimite=anoxx+mesxx+diaxx
     c                   move      *Zeros        fecpro            8 0
     c                   eval      fecpro=anox*10000+mesx*100+diax
     c* sumando un dia a la fecha en proceso para localiza los registros al inicio del m
     c                   move      diax          diat              2
     c                   move      mesx          mest              2
     c                   move      anox          anot              4
     c                   move      *blanks       fec_08           10
     c                   eval      fec_08=anot+'-'+mest+'-'+diat
     c                   move      fec_08        fecha1
     c*    fecha1        adddur    1:*d          fecha2
     c                   extrct    fecha1:*m     mesx1             2 0
     c                   extrct    fecha1:*Y     anox1             4 0
     c                   extrct    fecha1:*d     diax1             2 0
     c
     c* para la fecha del dia y determinar si esta vencido
     c                   move      diaxx         cadvdi
     c                   move      mesxx         cadvme
     c                   move      anoxx         cadvan
     c                   endsr
     c
     c*-------------------------------------------------------------------------
     c* leer los datos del cacredit
     c*-------------------------------------------------------------------------
     c     detalles      begsr
     c
     c                   setoff                                       80
     c                   move      *blanks       canucr
     C     clavca        SETLL     cacredit
     c     clavca        reade     cacredit                               80
     C     *IN80         DOWEQ     '0'
     c                   z-add     0             indi              1 0
     c
     c                   movel     canucr        ds                2 0
     c                   if        *in80 or distip=8 or
     c                              (cacavi=0 and distip<>27)
     c                                   or casubp=16 or ds=08
     c                                   or distip=24 or distip=25
     c                   z-add     1             indi
     c                   endif
     c
     c* lograr que no salga en el reporte los estatus 55, usado para Suspens
     c                   if        cacstc>40
     c                   z-add     1             indi
      * Validar estatus del credito en fecha de corte.
     C                   if        cacstc=60
     c                   move      *Zeros        feccan            8 0
     c                   eval      feccan=caacan*10000+camcan*100+cadcan
     c                   if        feccan>fecpro
      *
     C                   CALL      'PROCI41'
     C                   parm                    empcod
     C                   parm                    canucr
     C                   parm                    anox
     C                   parm                    mesx
     C                   parm                    diax
     c                   parm                    capcorte         13 2
     c                   if        capcorte>0
     c                   z-add     0             indi
     c                   move      capcorte      cacavi
     c                   endif
     c                   endif
     C                   endif
      *
     c                   endif
     c
     c                   if        indi=0
     c                   exsr      detallex
     c                   endif
     c
     c     clavca        reade     cacredit                               80
     c
     c                   enddo
     c                   endsr
     c*------------------------------------------------------------------
     c* completando los datos del cicla, leer cliente y tarjeta
     c*------------------------------------------------------------------
     c     detallex      begsr
     c* por seguridad
     c                   clear                   regcicl
     c
     c* fecha de aprobacion
     C*    CLAVCACRE     CHAIN     CAENTREG
     c                   move      CAAcoc        campo4            4
     c                   move      CAMcoc        campo2            2
     c                   move      caDcoc        campo22           2
     c                   eval      fec_aper=campo4+campo2+campo22
     c
     c                   exsr      leeclmcte                                    lee   cl
     c                   exsr      lee_tarjeta
     C                   MOVE      *BLANKS       CAMPO6            6
     C                   EVAL      CAMPO6=campo4+campo2
     c                   z-add     0             indi
     c                   if        campo6<'200203'  and existe='n'
     c                   z-add     1             indi
     c                   endif
     c
     c
     c                   if        (cacavi<>0 and feclimite>=fec_aper
     c                                                        and indi=0)
     c                             or casubp=15 or distip=27
     c                   exsr      leecasaldia
     c                   endif
     c
     c                   endsr
     c*-------------------------------------------------------------------------
     c* localizando los datos del cliente
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
     c                   movel     clsigl        siglas
     c                   endif
     c
     C                   ENDSL
     c                   endif
     c                   endsr
     c*-------------------------------------------------------------------------
     c* localizando los datos del cliente si es persona
     c*-------------------------------------------------------------------------
     c     lee_clpein    begsr
     c     clavcte       chain     clpein
     c                   eval      nombre=%trim(clino1)+' '+%trim(clino2) +','+
     c                                     %trim(cliap1)+' '+%trim(cliap2)
     c                   endsr
     c*-------------------------------------------------------------------------
     c* localizando los datos del prestamos en el casaldia
     c*-------------------------------------------------------------------------
     c     leecasaldia   begsr
     c     clavsaldia    chain     casaldia
     c                   if        %found() or DISTIP=27
     c     CLAsu1        chain     caproduc
     c                   exsr      mover_campos
     c                   endif
     C                   endsr
     c*-------------------------------------------------------------------------
     c* modulos completivos, localizando el caclacar, ahora cacredhsit
     c*-------------------------------------------------------------------------
     c* modulo calcula la distr de los atr
     c*-------------------------------------------------------------------------
     c* modulos completivos, localizando el caclacar
     c*-------------------------------------------------------------------------
     c* modulo calcula la distr de los atr
      ****************************************************************
     c*-------------------------------------------------------------------------
     c     distri        begsr
     c                   z-add     camonc        limite_cre
     c* re-emplazando la istruccion localizada en proci04 (a solicitud de anny 1
     c* debe reportarse el monto del prestamo en lugar de la suma de todos los m
     c
     c
     C                   SELECT
     C                   WHEN      NUMSEC11=1
     c                   z-add     MONTO_ATR     sal_0129
     C
     C                   WHEN      NUMSEC11=2
     c                   z-add     MONTO_ATR     sal_3059
     C
     C                   WHEN      NUMSEC11=3
     c                   z-add     MONTO_ATR     sal_6089
     C
     C                   WHEN      NUMSEC11=4
     c                   z-add     MONTO_ATR     sal_90119
     C
     C                   WHEN      NUMSEC11=5
     c                   z-add     MONTO_ATR     sal_120
     C
     C                   WHEN      NUMSEC11=6
     c                   z-add     MONTO_ATR     sal_150
     C
     C                   OTHER
     c                   z-add     MONTO_ATR     sal_180
     C                   ENDSL
     C                   endsr
     c*-------------------------------------------------------------------------
      ****************************************************************
      *  Programador....:  Andres segundo Tavarez.                   *
      * LOCALIZA LA CANTIDAD CUOTAS ATRASADAS DE UN PRESTAMOS
      *  Fecha..........:  17 sept  del 2001                         *
      ****************************************************************
     c     lee_cancuo    begsr
     c                   eval      NUMSEC11=%int(xcadimc/30)
     c                   endsr
     c*-------------------------------------------------------------------------
     c*/copy cartacsrc/qrpglesrc,procis03                                       cantidad
     c*-------------------------------------------------------------------------
     c* mover los campos temporales a los datos de la tabla
     c*-------------------------------------------------------------------------
     c     mover_campos  begsr
     c* si es fin de mes lo, localizo en el caclacar
     c                   exsr      lee_clacar
     c
     c                   eval      NUMSEC11=%int(xcadimc/30)
     c
     c                   if        XCACAVI>0 or XDISTIP=27
     c                   exsr      mover_c
     c                   exsr      lee_codeud
     c                   endif
     c                   endsr
     c*-------------------------------------------------------------------------
     c* para localizar el balance y el atraso
     c*-------------------------------------------------------------------------
     c     lee_clacar    begsr
     C     CLAVTEM       CHAIN     cacredhist
     c                   if        %found()
     c                   movel     canucr        tip               2
     c
     c                   z-add     xcaatra       mdia00
     c                   endif
     c
     c                   if        xdistip=09
     c                   clear                   mdia00
     c                   endif
     c
     c* LLamada al programa que escribe el status
     c                   call      'PROCI13'
     c                   parm      '1'           empcod            1
     c                   parm                    xCAcstc
     c                   parm                    status
     c
     c                   endsr
     c*-----------------------------------------------------
     c* completando los datos de la tabla del cicla
     c*-----------------------------------------------------
     c     mover_c       begsr
     c                   movel     canucr        numcta
     c                   z-add     XCACAVI       balance
     C                   MOVE      CLISEX        SEXO
     C                   MOVEL     CLNACI        NACIONA
     C                   MOVE      CLESCI        EST_CIVIL
     C                   MOVE      CLANNA        TEMPO4            4
     C                   MOVE      CLMENA        TEMPO2            2
     C                   MOVE      CLDINA        TEMPO22           2
     C                   Z-ADD     CLNUDE        NUM_DEP
     C                   EVAL      FECHA_NA=TEMPO4+TEMPO2+TEMPO22
     c
     c                   if        caaupc<>0
     c                   move      caaupc        campo4
     c                   move      camupc        campo2
     c                   move      cadupc        campo22
     c                   eval      fecha_ult=campo4+campo2+campo22
     c                   exsr      che_fecha
     c                   endif
     c
     c                   eval      num_cuo=%int(xcadimc/30)
     c* si es a termino, no cuota
     c                   if        PRPECN<>'S'
     c                   clear                   casain
     c
     c                   exsr      valida_ter
     c                   endif
     c
     c* para determina el monto total de atraso
     c                   eval      monto_atr=XCAATRA+XCAINAC
     c                             +XCASATO+XCASACO
     c                   if        monto_atr<=0
     c                   clear                   monto_atr
     c                   clear                   num_cuo
     c                   endif
     c
     c
      *************************************************
      *Busco la Cuota a vencimiento
      *************************************************
     c                   move      'VEN'         tippag            3
     c                   move      anoxx         anopag            4 0
     c                   move      mesxx         mespag            2 0
     c                   move      diaxx         diapag            2 0
     c
     c                   call      'CA4MONCU'
     c                   parm                    empcod
     c                   parm                    canucr
     c                   parm                    anopag
     c                   parm                    mespag
     c                   parm                    diapag
     c                   parm                    tippag
     c                   parm                    mon_cuo
     c
     c                   if        mon_cuo = 0
     c* Localizando el monto de la cuota del mes
     c                   call      'CAMONPAG'
     c                   parm                    empresa
     c                   parm                    canucr
     c                   parm      0.00          moncap           13 2
     c                   parm      0.00          monint           13 2
     c                   parm      0.00          monmor           13 2
     c                   parm      0.00          monseg           13 2
     c
     c                   eval      mon_cuo = moncap+monint+monseg
     c                   endif
     c
     c                   z-add     camone        limite_cre                     para dej
     c                   z-add     camone        credi_anto                     igual al
     c                   if        num_cuo=0 or distip=09
     c                   z-add     0             monto_atr
     c                   endif
     c
     c                   movel     cldoc         comenta
     c                   move      canucr        prestamos        15
     c
     c                   exsr      lee_direc
     c                   exsr      lee_otros
     c                   move      cldoc         cldoc_ant        18
     C                   EXSR      LEE_CONYU
     c                   exsr      distri
     C
     C* PARA LO COMPARTIDO
     c**pregunto si es compartido y veo que porciento nos toca
     c                   if        casubp=15 or casubp=16
     c*Reporte de prestamos compartidos
     c                   call      'INFOR81'
     c                   parm                    empcod
     c                   parm                    canucr
     c                   parm                    porci             7 2
     C
     c                   if        porci<>0
     c                   eval      mon_cuo=mon_cuo * ((100-porci)/100)
     c                   eval      credi_anto=credi_anto * ((100-porci)/100)
     c                   eval      limite_cre=limite_cre * ((100-porci)/100)
     c                   eval      monto_atr=monto_atr * ((100-porci)/100)
     c                   eval      BALANCE =BALANCE  * ((100-porci)/100)
     c                   endif
     c                   endif
     C
     c                   eval      unidad='RD$'
      *
     c***
     c                   write     regcicl
     c
     c* para acumular los registros por clientes y al final determinar limite de credito
     c                   call      'PROCI03'
     c                   parm                    cldoc_ant
     c                   parm                    limite_cre
     C
     C                   endsr
     c*-------------------------------------------------------------------------
     c* validando los a terminos por fecha de vencimento
     c*-------------------------------------------------------------------------
     c     valida_ter    begsr
     c* par determina si esta vencido
     c                   if        caavec<>0
     c     *Iso          Test(D)                 fechoy                 80
     c     *Iso          Test(D)                 fecven                 81
     c                   if        not *in80 and not *In81
     c                   move      fechoy        fecha1
     c                   move      fecven        fecha2
     c                   if        fecha2<fecha1
     c                   z-add     cacavi        mdia00
     c                   endif
     c
     c                   endif
     c                   endif
     c
     c* si no esta vencido el caatra igual  a 0.00
     c                   if        fecha2>=fecha1
     c                   clear                   mdia00
     c                   endif
     c
     c                   if        xCASTAD>xCAcstc
     c                   call      'PROCI13'
     c                   parm      '1'           empcod            1
     c                   parm                    xCASTAD
     c                   parm                    status
     c
     c                   eval      NUMSEC11=%int(xcadimi/30)
     c                   eval      num_cuo=%int(xcadimi/30)
     c                   endif
     C                   endsr
     c*-------------------------------------------------------------------------
     c*-------------------------------------------------------------------------
     c* localizando los datos del codeudor
     c*-------------------------------------------------------------------------
     c     lee_codeud    begsr
     c     clavcacre     chain     cacodeud
     c                   if        %found()
     c*Genera la tabla del cicla Co-deudor
     c                   call      'PROCI02'
     C                   parm      diaxx         diaxx12           2
     C                   parm      mesxx         mesxx12           2
     C                   parm      anoxx         anoxx12           4
     C                   parm                    canucr
     C                   parm                    candcd
     C                   parm      'Activo'      estatus           9
     c                   endif
     C
     C                   endsr
     c*-------------------------------------------------------------------------
     c* localizando los datos del conyugue
     c*-------------------------------------------------------------------------
     C     lee_conyu     begsr
     c                   if        cldocc<>*blanks
     c     clavcte_es    chain     clmcte01
     c                   movel     clnomb        nombre_con
     C                   MOVEL     CLNUID        ced_con
     c                   endif
     C                   endsr
     c*-------------------------------------------------------------------------
     c* verificando los datos de la tarjeta
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
     c                   if        existe='n'
     c                   move      ' '           exis
     c* datos de la tarjeta
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
     c* localizando  la direccion
     c*-------------------------------------------------------------------------
     c     lee_direc     begsr
     c
     c* localizando la direccion
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
     c
     c*Retorna el telefono
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
     c* localizando el telefono
     C
     c
     C                   endsr
     c*-------------------------------------------------------------------------
     c* seleccionando los letreros del prpoducto
     c*-------------------------------------------------------------------------
     c     lee_otros     begsr
     c     clavcacan     chain     cacantip
     c                   movel     disdes        tipcta
     c
     c                   select
     c                   when      distip=01 or distip=14
     c                   eval      tipcta='Prestamo Hipotecario'
     c
     c                   when      distip=04
     c                   eval      tipcta='Prestamo Interino'
     c
     c                   when      distip=03
     c                   eval      tipcta='Prestamo Solar'
     c
     c                   when      distip=02 OR DISTIP=09 OR DISTIP=07
     c                   eval      tipcta='Prestamo Personal'
     c
     c                   when      distip=05
     c                   eval      tipcta='Prestamo Garantizado'
     c
     c                   endsl
     c
     c                   select
     c                   when      CAPROD=1
     c                   eval      tipcta='Creditos Comerciales'
     c                   when      CAPROD=2
     c                   eval      tipcta='Creditos Consumo'
     c                   when      CAPROD=3
     c                   eval      tipcta='Creditos Hipotecarios'
     c                   endsl
     c
     c                   eval      relacion='Deudor'
     C                   endsr
     c*-------------------------------------------------------------------------
     c* determina l fecha del ultimo pago del cliente
     c*-------------------------------------------------------------------------
     c     che_fecha     begsr
     c                   if        fecha_ult>feclimite
     c                   setoff                                       61
     c     diax          add       01            diaxxc
     c                   move      anoxx         anoxxc
     c                   move      mesxx         mesxxc
     c     clavcahis     setll     cahisp34
     c     *in61         doweq     '0'
     c                   readp     cahisp34
     c                   if        *in61 or  canucr<>xcanucr
     c                   seton                                        61
     c                   iter
     c                   endif
     c
     c                   if        xcatipo<>'PAG' and xcatipo<> 'AMT' and
     c                             xcatipo<>'NCR' and xcatipo<> 'NDE' and
     c                             xcatipo<>'APE' and xcatipo<> 'ENT'
     c                   iter
     c                   endif
     c
     c                   move      xcaartr       anotra            4
     c                   move      xcamrtr       mestra            2
     c                   move      xcadrtr       diatra            2
     c                   move      *blanks       fectra           10
     c                   eval      fectra=anotra+mestra+diatra
     c                   if        fectra<=feclimite
     c                   move      fectra        fecha_ult
     c                   seton                                        61
     c                   endif
     c                   enddo
     c                   endif
     C                   endsr
** meses  vector almacena la cantidad de dias del mes
312831303130313130313031
