      ****************************************************************
     HDEBUG
     hdatfmt(*eur) datedit(*dmy)
     F*  Nombre del Fuente....: proci12
     F*  Tipo del Fuente......: qrpglesrc
     F*  Libreria del Fuente..: CARTACSRC
     F*  Libreria del Objeto..: CARTACPGM
     F*  Programador..........: Andres Segundo Tavarez
     F*  Fecha................: 17-09-2001
     F*  Descripcion..........: Genera datos que se envian al Cicla    *
     F*
      * Modificado por.......: Andres segundo Tavarez
      * Descripción..........: Determinar el monto en atrasp monto_atr
      * Fecha Modificación...: 07 de febrero del 2017
      * Requerimiento........: 2017-63
     F*
      * Modificado por.......: Lilian Garcia
      * Fecha Modificación...: 25 de Marzo de 2019
      * Requerimiento........: 2019-76
      * Descripción..........: Guardar la cuota completa
      *
      * Modificado por .....: Andres Segundo Tavarez
      * DESCRIPCION.........: Solo compilado por error de nivel
      * Fecha...............: 14 de abr del 2020
      * LUGAR...............: ACAP
      * REQUERIMIENTO.......: 2020-219
      *
      *
      *---------------------------------------------------------------------
     F*
      * Modificado por.......: Andres segundo Tavarez
      * Descripción..........: Control lo compartido
      * Fecha Modificación...: 24 - 10 - 2017
      * Requerimiento........: 2017-792
      *---------------------------------------------------------------------
      *  Nombre Fuente..:  proci12                                  *
      *  Tipo de Fuente.:  Programa Fuente RPG                       *
      *  Libreria.......:  cartacsrc                                 *
      *                                                              *
      *  Programador....:  Andres segundo Tavarez.                   *
      *  Fecha..........:  23 Feb   del 2011                         *
      *  Hora...........:  19:07                                     *
      *  Lugar..........:  ACAP                                      *
      *                                                              *
      *  Descripcion....:  Genera la data del cicla, de los prestamos*
      *                    que dejaron de reportarse
      *
      * ultimos cambios
      * Fecha                  Descripcion
      * 17/01/2012             Parametros para cancelados            *
      *
      * 25/02/2015             Andres Segundo Tavarez
      *                        Ajustar la cuota de los aterminos
      *
      * 10/06/2015             Andres Segundo Tavarez
      *                        encadenar cacredhis para localicar el cancat
      *
      * 05/10/2015             Andres Segundo Tavarez
      *                        Eliminar los castigo
      *   REALIZADO POR.......: CESAR DARINEL ORTIZ
      *   DESCRIPCION.........: Agregar la tabla caadjudi
      *   Fecha...............:  17 Feb   del 2017                         *
      *   LUGAR...............: ACAP
      *   REQUERIMIENTO.......: 2017-138
      *
      * Fecha de Modificacion.: 12 de junio de 2019
      * Modificado por........: José Marcano
      * Tarea.................: 2019-291
      * Motivo del Cambio.....: Compilar
      *
      * Fecha de Modificacion.: 02 de febrero del 2021              *
      * Modificado por........: Gustavo Henriquez                   *
      * Tarea.................: 2021-13                             *
      * Motivo del Cambio.....: Compilar                            *
      *
      *
      ****************************************************************
      *******************************************************************
      *  Fecha de Modificacion: 11 de septiembre 2024
      *  Modificado por.......: Carlos Pérez
      *  Tarea................: 2024-217
      *  Motivo del Cambio....: Agregando los 05 (prestamos garantizados)
      *                         a los reportes de TU y DC
      *******************************************************************
     Fcasaldia  if   e           k Disk
     f
     Fcahisp34  if   e           k Disk    prefix(x)
     Fcacredhistif   e           k Disk    prefix(x)
     Fcaproduc  if   e           k Disk
     Fcacredit  if   e           k Disk
     Fclmcte01  if   e           k Disk
     Fcafympag  if   e           k Disk
     Fcafymp02  if   e           k Disk    rename(rcfympag:rcfym)
     Fclpein    if   e           k Disk
     F*ldicl    if   e           k Disk
     F*ldeDi    if   e           k Disk
     Fclpeju    if   e           k Disk
     Fcacantip  if   e           k Disk
     Fccsfemta1 if   e           k Disk
     Fcacodeud  if   e           k Disk
     f
     Ftabcicla  UF a E           K Disk
     Ftabcicla01UF a E           K Disk    rename (regcicl:regxc) prefix(x)
     F
     dfecha1           s               d
     dfecha2           s               d
     dvc               s             13  2 dim(7)
     d
     dmeses            s              2  0 dim(12) CTDATA PERRCD(12)
     d
      ****************************************************************
     c     *entry        plist
     c                   parm                    empcod
     c                   parm                    diaxx            02
     c                   parm                    mesxx            02
     c                   parm                    anoxx            04
     c                   parm                    canucr_pas       15
     c
     c     clavtem       klist
     c                   kfld                    empcod
     c                   kfld                    anox1
     c                   kfld                    mesx1
     c                   kfld                    diax1
     c                   kfld                    canucr
     c
     c     clavcahis     klist
     c                   kfld                    empcod
     c                   kfld                    canucr
     c                   kfld                    anoxxc            4 0
     c                   kfld                    mesxxc            2 0
     c                   kfld                    diaxxc            2 0
     c     clavcldide    klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     c
     c     clavcicla     klist
     c                   kfld                    cuenta           40
     c
     c* definicion de claves
     c     clavcte       klist
     c                   kfld                    blanco            1
     c                   kfld                    cldoc
     c
     c     clavcte_Es    klist
     c                   kfld                    blanco            1
     c                   kfld                    cldocc
     c
     c     CLAsu1        klist
     c                   kfld                    empresa
     c                   kfld                    caprod
     c                   kfld                    casubp
     c
     c     clavcacre_e   klist
     c                   kfld                    empresa           1
     c                   kfld                    canucr_pas
     c
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
     c     clavcacan     klist
     c                   kfld                    empresa
     c                   kfld                    distip
     c
     c     clavcacre     klist
     c                   kfld                    empresa           1
     c                   kfld                    canucr
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
     c*-------------------------------------------------------------------------
     c                   exsr      inicio
     c                   exsr      detalles
     c                   seton                                        lr
     c*-------------------------------------------------------------------------
     c* inicio del proceso
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
     c* sumando un dia a la fecha en proceso para localiza los registros al inicio del m
     c                   move      diax          diat              2
     c                   move      mesx          mest              2
     c                   move      anox          anot              4
     c                   move      *blanks       fec_08           10
     c                   eval      fec_08=diat+'.'+mest+'.'+anot
     c                   move      fec_08        fecha1
     c     fecha1        adddur    1:*d          fecha2
     c                   extrct    fecha2:*m     mesx1             2 0
     c                   extrct    fecha2:*Y     anox1             4 0
     c                   extrct    fecha2:*d     diax1             2 0
     c
     c                   endsr
     c*-------------------------------------------------------------------------
     c* leer los datos del cacredit
     c*-------------------------------------------------------------------------
     c     detalles      begsr
     c
     c                   setoff                                       80
     C     clavcacre_e   SETLL     cacredit
     C     *IN80         DOWEQ     '0'
     c     clavcacre_e   reade     cacredit                               80
     c
     c                   movel     canucr        ds                2 0
     c                   if        *in80 or distip=8 or casubp=16
     c                                   or ds=08
     c                                   or distip=24 or distip=25
     c                   iter
     c                   endif
     c
     c* para no salvar los registro que estan procesos anteriormente por otro arrastre
     c                   movel     canucr        cuenta
     c     clavcicla     chain     tabcicla01
     c                   if        %found()
     c                   iter
     c                   endif
     c                   eval      clasifi='A'
     c* fecha de aprobacion
     C*    CLAVCACRE     CHAIN     CAENTREG
     c                   move      CAAcoc        campo4            4
     c                   move      CAMcoc        campo2            2
     c                   move      caDcoc        campo22           2
     c                   eval      fec_aper=campo4+campo2+campo22
     c
     c                   exsr      leeclmcte                                    lee   cl
     c*                  exsr      lee_tarjeta
     C                   MOVE      *BLANKS       CAMPO6            6
     C                   EVAL      CAMPO6=campo4+campo2
     c                   if        campo6<'200203'  and existe='n'
     c** no se usa       iter
     c                   endif
     c
     c*                  if        cacavi<>0 and feclimite>fec_aper
     c*                  if        cacavi<>0
     c                   exsr      leecasaldia
     c*                  endif
     c
     c                   enddo
     c                   endsr
     c*-------------------------------------------------------------------------
     c* leer el maestro de cliente para localizar el nombre
     c*-------------------------------------------------------------------------
     c     leeclmcte     begsr
     c     clavcte       chain     clmcte01
     c                   if        %found()
     C                   MOVEL     CLNUID        CEDNUEVA
     c                   move      *blanks       campox           11
     C                   SELECT
     C     cltida        WHENEQ    'C'
     C                   MOVEL     'I'           tipent
     c                   evalr     campox=%subst(clnuid:1:3)+%subst(clnuid:5:7)
     c                                               +  %subst(clnuid:13:1)
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
     c     clavcte       chain     clpeju
     c                   if        %found()
     c                   movel     clsigl        siglas
     c                   endif
     C                   ENDSL
     c                   endif
     c                   endsr
     c*-------------------------------------------------------------------------
     c* Localizando el nombre cuando es persona
     c*-------------------------------------------------------------------------
     c     lee_clpein    begsr
     c     clavcte       chain     clpein
     c                   eval      nombre=%trim(clino1)+' '+%trim(clino2) +','+
     c                                     %trim(cliap1)+' '+%trim(cliap2)
     c                   endsr
     c*-------------------------------------------------------------------------
     c* localizando los datos del dia en el casaldia
     c*-------------------------------------------------------------------------
     c     leecasaldia   begsr
     c     clavsaldia    chain     casaldia
     c                   if        %found()
     c     CLAsu1        chain     caproduc
     c                   exsr      mover_campos
     c*****              exsr      lee_codeud
     c                   else
     c                   add       1             reg               4 0
     c                   endif
     C                   endsr
     c*-------------------------------------------------------------------------
     c* sub rutina para varios procesos
     c* modulo calcula la distr de los atr
     c*-------------------------------------------------------------------------
     c/copy cartacsrc/qrpglesrc,procis01
     c/copy cartacsrc/qrpglesrc,procis02
     c*copy cartacsrc/qrpglesrc,procis03
     c*-------------------------------------------------------------------------
     c* para localizar el balance y el atraso
     c*-------------------------------------------------------------------------
     c     lee_clacar    begsr
     C     CLAVTEM       CHAIN     cacredhist
     c                   if        %found()
     c                   z-add     xcacavi       sdia00
     c                   movel     canucr        tip               2
     c
     c                   z-add     xcaatra       mdia00
     c                   z-add     xcancat       cuoa00
     c                   endif
     c
     c                   if        xdistip=09
     c                   clear                   mdia00
     c                   clear                   cuoa00
     c                   endif
     c                   endsr
     c*-------------------------------------------------------------------------
     c* para mover los datos a variables temporales
     c*-------------------------------------------------------------------------
     c     mover_campos  begsr
     c* si es fin de mes lo, localizo en el caclacar
     c                   if        meses(mesx)=diax
     c                   exsr      lee_clacar
     c                   endif
     c
     c                   if        PRPECN<>'S'
     c                   clear                   casain
     c                   endif
     c
     c                   z-add     cuoa00        NUMSEC11
     c                   movel     canucr        numcta
     c                   z-add     sdia00        balance
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
     c                   z-add     mdia00        monto_atr
     c                   add       IAIA00        monto_atr
     c                   add       ODIA00        monto_atr
     c                   add       MAIA00        monto_atr
     c                   if        monto_atr<0
     c                   clear                   monto_atr
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
     c                   z-add     cuoa00        num_cuo
     c                   movel     cldoc         comenta
     c                   movel     cldoc         cldoc_ant        18
     c
     c                   if        num_cuo=0
     c                   z-add     0             monto_atr
     c                   endif
     c
     c                   exsr      lee_direc
     c                   exsr      lee_otros
     C                   EXSR      LEE_CONYU
     c                   exsr      distri
     c                   eval      unidad='RD$'
     C* PARA LO COMPARTIDO
     c**pregunto si es compartido y veo que porciento nos toca
     c                   if        casubp=15 or casubp=16
     c*Reporte de Prestamos Compartidos
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
     c
     c                   write     regcicl
     c
     c* para acumular los registros por clientes y al final determinar limite de credito
     c                   call      'PROCI03'
     c                   parm                    cldoc_ant
     c                   parm                    limite_cre
     C
     C                   endsr
     c*-------------------------------------------------------------------------
     c* localizando el codeudor
     c*-------------------------------------------------------------------------
     c     lee_codeud    begsr
     c     clavcacre     chain     cacodeud
     c                   if        %found()
     c* localizando el codeudor
     c                   call      'PROCI02'
     C                   parm                    diaxx
     C                   parm                    mesxx
     C                   parm                    anoxx
     C                   parm                    canucr
     C                   parm                    candcd
     C                   parm      'Activo  '    estatus           9
     c                   endif
     C
     c                   clear                   regcicl
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
     c                   move      cldoc_ant     cldoc
     C                   endsr
     c*-------------------------------------------------------------------------
     c* localizando los datos de la tarjeta
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
     c* retorna parametros del cicla
     c                   call      'PROCI09'
     c                   parm                    cldoc
     c                   parm                    canucr
     c                   parm                    exis              1
     c
     c                   if        exis='s'
     c                   move      's'           existe
     c                   endif
     c                   endif
     c
     c
     C                   endsr
     c*-------------------------------------------------------------------------
     c* localizando los datos de la direccion
     c*-------------------------------------------------------------------------
     c     lee_direc     begsr
     c*                  z-add     01            numsec
     c*    clavdire      chain     cldicl
     c*                  eval      direccionr=%trim(cldire)+' '+%trim(cldir2)+
     c*                                                     ' '+%trim(cldir3)
     c*
     c*                  z-add     02            numsec
     c*    clavdire      chain     cldicl
     c*
     c*                  move      *blanks       tel_casal
     c*                  move      *blanks       tel_trab
     C*
     c*                  setoff                                       56
     c*    clavcldide    setll     cldedi
     c*    *in56         doweq     '0'
     c*    clavcldide    reade     cldedi                                 56
     c*                  if        *in56
     c*                  iter
     c*                  endif
     c*
     c*                  select
     c*                  when      clcoid=9 and clcosi=1
     c*                  movel     cldsdi        tel_casal
     c*
     c*                  when      clcoid=9 and clcosi=4
     c*                  movel     cldsdi        tel_trab
     c*                  endsl
     c*
     c*                  enddo
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
     c* datos del telefono
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
     c* localizando los datos del producto para el encabezado
     c*-------------------------------------------------------------------------
     c     lee_otros     begsr
     c     clavcacan     chain     cacantip
     c                   move      disdes        tipcta
     c                   select
     c                   when      distip=01 or distip=14
     c                   eval      tipcta='Prestamo Hipotecario'
     c
     c                   when      distip=04
     c                   eval      tipcta='Prestamo Interino'
     c
     c                   when      distip=03
     c                   eval      tipcta='Prestamo Solares'
     c
     c                   when      distip=02 OR DISTIP=09 OR DISTIP=07
     c                   eval      tipcta='Prestamo Personales'
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
     c                   eval      status='Activo'
     C                   endsr
     c*-------------------------------------------------------------------------
     c* localizando los datos del archivo historico de pagos
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
     c*-------------------------------------------------------------------------
** meses  vector almacena la cantidad de dias del mes
312831303130313130313031
