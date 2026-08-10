     h*%%TS  SD  20090602  142241  ACAP1254    REL-V5R4M0  5722-WDS
     h****************************************************************
     h*  Nombre Fuente......: PROCI10                                *
     h*  Tipo de Fuente.....: rpgle                                  *
     h*  Libreria...........: CARTACPGM                              *
     h*  Descripcion........: Adiciona campos faltantes a TABCICLA.  *
     h*  Realizado por......: Romert Diaz                            *
     h*  Fecha realizacion..: 05/01/2011                             *
     h*  Lugar..............: ACAP                                   *
     h*  Modificado por.....:                                        *
     h*  Motivo modificacion:                                        *
     h*  Fecha modificacion.:                                        *
      *
      *
      * Modificado por.......: Cesar Darinel Ortiz
      * Descripción..........: Compilar por que se modifico la tabla tabdatac
      * Fecha Modificación...: 22 de febrero del 2016
      * Requerimiento........: 2017-57
     h****************************************************************
     hdebug
     hdatfmt(*iso) datedit(*ymd) Timfmt(*Hms)
     hOption(*Nodebugio:*Srcstmt)
      **
     ftabdatac  uf   e           K Disk
     fcacredit  if   e           K Disk
     fcatippro  if   e           K Disk
     fcahisptm  if   e           K Disk
     d
     d                 ds
     d  numcta                 1     40
     d @numpre                 1     15
     d
     d                 ds
     d  fecultp                1      8  0 inz(0)
     d  caartr                 1      4  0
     d  camrtr                 5      6  0
     d  cadrtr                 7      8  0
     d
     d                sds
     d  Trabajo               91    170
     d  terminal             244    253
     d  username             254    263
     d  hora                 282    287
      *
      ** **************************************************************
      *--  Bloque principal del programa
      ** **************************************************************
     c
     c     *entry        plist
     c                   parm                    diapar            2
     c                   parm                    mespar            2
     c                   parm                    anopar            4
      *
     c     kprod         klist
     c                   kfld                    empcod
     c                   kfld                    caprod
     c
     c     kprex         klist
     c                   kfld                    @empcod
     c                   kfld                    @numpre
     c
     c                   move      '1'           @empcod           1
     c                   move      diapar        diarec            2 0
     c                   move      mespar        mesrec            2 0
     c                   move      anopar        anorec            4 0
     c
     c                   eval      *in80 = '0'
     c*    *loval        setll     tabcicla01
     c                   dou       *in80 = '1'
     c                   read      tabdatac                               80
     c                   if        *in80 = '0'
     c
     c                   z-add     0             caprod
     c     kprex         chain     cacredit                           22
     c                   if        *in22 = '0'
     c
     c* Descripción tipo cliente:
     c                   move      *blanks       tipdes
     c     kprod         chain     catippro                           22
     c                   movel     tipdes        tipoc
     c* Plazo:
     c                   if        factor = 'D'
     c                   eval      plazox = cacod1 / 30
     c                   else
     c                   if        factor = 'A'
     c                   eval      plazox = cacod1 * 12
     c                   else
     c                   z-add     cacod1        plazox
     c                   endif
     c                   endif
     c
     c* Tasa interes:
     c                   z-add     catino        tasai
     c                   add       caindi        tasai
     c
     c                   exsr      bus_ult_pag
     c
     c                   update    REGDATA
     c
     c                   endif
     c
     c                   endif
     c                   enddo
     c
     c                   Eval      *inlr = '1'
     c                   return
     c
      *-------------------------------------------------------------
      * bus_ult_pag ** Busca ultima fecha de pago previo fec_corte
      *-------------------------------------------------------------
     c     bus_ult_pag   begsr
     c
     c     khisptm_f     klist
     c                   kfld                    empcod
     c                   kfld                    canucr
     c                   kfld                    anorec
     c                   kfld                    mesrec
     c                   kfld                    diarec
     c
     c     khisptm       klist
     c                   kfld                    empcod
     c                   kfld                    canucr
     c
     c                   z-add     0             moulpa
     c                   move      *blanks       feulpa
     c                   eval      *in82 = '0'
     c     khisptm_f     Setgt     cahisptm
     c     *in82         Doueq     '1'
     c     khisptm       readpe    cahisptm                               82
     c                   if        *in82 = '0'
     c
     c                   if        catipo = 'AMT' or
     c                             catipo = 'PAG'
     c                   movel     fecultp       feulpa
     c                   z-add     catota        moulpa
     c                   eval      *in82 = '1'
     c                   endif
     c
     c                   endif
     c                   enddo
     c
     c                   Endsr
