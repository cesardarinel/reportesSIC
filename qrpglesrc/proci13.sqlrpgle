      *-------------------------------------------------------------------------
      *  Nombre Fuente.......: PROCI13
      *  Tipo de Fuente......: Qrpglesrc
      *  Libreria............: Cartacsrc
      *  Descripcion.........: Retorna los Status de los prestamos
      *
      *  Realizado por.......: Cesar Darinel Ortiz
      *  Fecha Realización...: 18/08/2016
      *  Lugar...............: ACAP
      *
      *  Modificado por.......: César Darinel Ortiz
      *  Descripción..........: Actualizar estatus y balance
      *  Fecha Modificación...: 02 de marzo del 2022
      *  Requerimiento........: 2022-81
      *
      * Modificado por.......:
      * Descripción..........:
      * Fecha Modificación...:
      *---------------------------------------------------------------------
     FCASTACRE  if   e           k Disk                                            *****
     c
     c
      *---------------------------------------------------------------------
      *entrada @empresa @codigo_estatus @Texto_Estatus
      *---------------------------------------------------------------------
     c     *entry        plist
     c                   parm                    empcod            1
     c                   parm                    Codigo            2 0
     c                   parm                    status           20
     c
     c     Codigo        chain     CASTACRE                                     ***
     c                   eval      status=CADSTC
     c
     c                   if        %trim(CADSTC)='*CANCELADOS*'
     c                   eval      status='CANCELADO'
     c                   endif
     c                   if        %trim(CADSTC)='VIGENTE'
     c                   eval      status='ACTIVO'
     c                   endif
     c                   if        %trim(CADSTC)='REEST. MORA'
     c                   eval      status='MORA'
     c                   endif
     c                   if        %trim(CADSTC)='VENCIDO'
     c                   eval      status='MORA'
     c                   endif
     c                   if        %trim(CADSTC)='EN COBRANZA JUDICIAL'
     c                   eval      status='LEGAL'
     c                   endif
     c                   if        %trim(CADSTC)='COBRAZ. JUDICIAL MORA'
     c                   eval      status='LEGAL'
     c                   endif
     c                   if        %trim(CADSTC)='COBRAZ. JUDICIAL VENCIDO'
     c                   eval      status='LEGAL'
     c                   endif
     c                   if        %trim(CADSTC)='EN COBRANZA JUDICIAL'
     c                   eval      status='LEGAL'
     c                   endif
     c                   move      '1'           *Inlr
     c*
     c*
     c*      0         VIGENTE
     c*      1         MORA
     c*     10         VENCIDO
     c*     15         REESTRUCTURADO
     c*     20         EN COBRANZA JUDICIAL
     c*     30         ADJUDICADO
     c*     40         CASTIGADOS
     c*     50         ** ANULADOS **
     c*     60         *CANCELADOS*
     c*     99         ** CREDITOS EN STAND BY **
     c*     16         REEST. MORA
     c*     17         REEST. VENCIDO
     c*     21         COBRAZ. JUDICIAL MORA
     c*     22         COBRAZ. JUDICIAL VENCIDO
     c*
