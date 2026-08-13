//*************************************************************************
//    * Nombre del Fuente....: PROCI15
//    * Tipo del Fuente......: RPGLESQL
//    * Libreria del Fuente..: CARTACSRC
//    * Libreria del Objeto..: CARTACPGM
//    * Programador..........: José Marcano
//    * Fecha................: 28-06-2019
//    * Tarea................: 2019-384
//    * Descripcion..........: CAMBIO FORMATO SOLICITADO POR LA EMPRESA
//    *                        TRANSUNION
//    *
//    * Fecha de Modificacion.: 02 de febrero del 2021              *
//    * Modificado por........: Gustavo Henriquez                   *
//    * Tarea.................: 2021-13                             *
//    * Motivo del Cambio.....: Compilar                            *
//    *
//    ****************************************************************
//    * Fecha de Modificacion.: 12 de marzo del 2024
//    * Modificado por........: Carlos Pérez
//    * Tarea.................: 2023-154
//    * Motivo del Cambio.....: Modificando campos para cumplir
//    *                         con la estructura de TRANSUNION
//    *
//    *****************************************************************
//    * Fecha de Modificacion.: 02 de enero de 2025
//    * Modificado por........: Carlos Pérez
//    * Tarea.................: 2024-224
//    * Motivo del Cambio.....: reparando cambio monto cuota cuando
//    *                         existe
//    *****************************************************************
//    * Fecha de Modificacion.: 29 de abril de 2025
//    * Modificado por........: Lewis Durán
//    * Tarea.................: 2025-106
//    * Motivo del Cambio.....: Corrigiendo campo de estatus para reest
//    *****************************************************************
//    *****************************************************************
//    * Fecha de Modificacion.: 19 de aagosto de 2025
//    * Modificado por........: Carlos Pérez
//    * Tarea.................: 2025-411
//    * Motivo del Cambio.....: Colocando descripción correcta
//    *                         reestructurados
//    *****************************************************************
//    * Fecha de Modificacion.: 17 de marzo 2026
//    * Modificado por........: Lewis Durán
//    * Tarea.................: 2022-461
//    * Motivo del Cambio.....: Corrigiendo estatus para cancelados
//    *                         después de fecha de corte.
//    *****************************************************************
//    * Fecha de Modificacion.: 7 de agosto 2026
//    * Modificado por........: cesar ortiz
//    * Tarea.................: 2026-289
//    * Motivo del Cambio.....: Eliminar los vencidos mayores a 48 meses desde
//    *                         la fecha de apertura y el ultimo pago
//    *****************************************************************
**free

ctl-opt dftactgrp(*no);

dcl-pi *n;
  empcod char(1);
  diapro char(2);
  mespro char(2);
  anopro char(4);
end-pi;

dcl-s anoProc packed(4);
dcl-s mesProc packed(2);
dcl-s diaProc packed(2);

Exec SQL SET OPTION COMMIT = *NONE,
                CLOSQLCSR = *ENDMOD;

anoProc = %dec(anopro:4:0);
mesProc = %dec(mespro:2:0);
diaProc = %dec(diapro:2:0);

Exec SQL
Insert into cartacdat.tabciclat (tipent,codcli,relacion,nombre,
razon_soc,cedula,numpas,siglas,rnc,residencia,oficina,movil,fax,email,otro,
calle_av,esquina,numero,edificio,urbaniza,sector, ciudad, provinci,
numcta,unidad,tipcta, forma, tipo_cuo, fec_aper, fecha_ven, tasa_ini,
monto_pres, mon_cuo, num_cuo, tasa_vigen, fecha_ultp, monto_ultp, balance,
monto_atr,cacod1,status,estado_cue,SAL_0130,SAL_3160,SAL_6190,SAL_91120,SAL_121,
SAL_151,SAL_181)
  Select tipent, trim(comenta), relacion,
      case
            When tipent='I' Then replace(nombre,',',' ')
            When tipent='E' Then ''
      end,
      case
            when tipent='I' Then ''
            When tipent='E' Then replace(nombre,',',' ')
      end,
      trim(replace(cednueva,'-','')), numpas,
      siglas, trim(replace(rnc,'-','')),
      ifnull((select ifnull(a.clnum,0)
       from v5clidat.cltel03 a
       where trim(a.cldoc) = trim(comenta)
       and a.cltipo = 1
       FETCH FIRST ROW ONLY),0), -- Tel Residencia
       ifnull((select ifnull(b.clnum,0)
       from v5clidat.cltel03 b
       where trim(b.cldoc) = trim(comenta)
       and b.cltipo = 2
       FETCH FIRST ROW ONLY),0),-- Tel Movil
       ifnull((select ifnull(c.clnum,0)
       from v5clidat.cltel03 c
       where trim(c.cldoc) = trim(comenta)
       and c.cltipo = 3
       FETCH FIRST ROW ONLY),0),-- Tel Oficina
       '', -- fax
       ifnull((Select cor.clmail
       from v5clidat.clcor cor
       where cor.cldoc = comenta and cor.estatu = 'A'
       Fetch First Row Only),''),-- Correo
       ifnull((select ifnull(d.clnum,0)
       from v5clidat.cltel03 d
       where trim(d.cldoc) = trim(comenta)
       and d.cltipo > 3
       FETCH FIRST ROW ONLY), 0) , --Otro
       ifnull((SELECT replace(dir.clvia,',',' ')
       FROM v5clidat.CLDI03 dir
       WHERE dir.CLDOC=comenta FETCH FIRST ROW ONLY),''),-- Calle/Avenida
       ifnull((SELECT replace(dir.clman, ',', ' ')
       FROM v5clidat.CLDI03 dir
       WHERE dir.CLDOC=comenta FETCH FIRST ROW ONLY),''), -- Esquina
       ifnull((SELECT replace(dir.clnum,',', ' ')
       FROM v5clidat.CLDI03 dir
       WHERE dir.CLDOC=comenta FETCH FIRST ROW ONLY),''), -- Numero
       ifnull((SELECT replace(dir.clres, ',', ' ')
       FROM v5clidat.CLDI03 dir
       WHERE dir.CLDOC=comenta FETCH FIRST ROW ONLY),''), -- Edificio
       ifnull((SELECT replace(dir.cldbarr, ',', ' ')
       FROM v5clidat.CLDI03 dir
       WHERE dir.CLDOC=comenta FETCH FIRST ROW ONLY),''), -- Urbaniza
       ifnull((select replace(clnsect, ',', ' ')
                    from v5clidat.clsector
                    where clpadi = (SELECT dir.clpadi
                             FROM v5clidat.CLDI03 dir
                             WHERE dir.CLDOC=comenta
                                FETCH FIRST ROW ONLY)
                    and clprov = (SELECT dir.clprov
                           FROM v5clidat.CLDI03 dir
                           WHERE dir.CLDOC=comenta
                           FETCH FIRST ROW ONLY )
                    and clmun = (SELECT dir.clmun
                          FROM v5clidat.CLDI03 dir
                          WHERE dir.CLDOC=comenta
                          FETCH FIRST ROW ONLY)
                    and cldmu = (SELECT dir.cldmu
                          FROM v5clidat.CLDI03 dir
                          WHERE dir.CLDOC=comenta
                          FETCH FIRST ROW ONLY)
                    and clsector = ifnull((SELECT dir.clsector
                                                  FROM v5clidat.CLDI03 dir
                                                  WHERE dir.CLDOC=comenta
                                                  FETCH FIRST ROW ONLY),0)
            FETCH FIRST ROW ONLY),''), --Sector
       ifnull((select replace(cllug2, ',', ' ')
       from v5clidat.clgeo2
       where clpaco = (SELECT dir.clpadi
                       FROM v5clidat.CLDI03 dir
                       WHERE dir.CLDOC=comenta
                       FETCH FIRST ROW ONLY)
       and nige01 = (SELECT dir.clprov
                     FROM v5clidat.CLDI03 dir
                     WHERE dir.CLDOC=comenta
                     FETCH FIRST ROW ONLY )
       and nige02 = (SELECT dir.clmun
                     FROM v5clidat.CLDI03 dir
                     WHERE dir.CLDOC=comenta
                     FETCH FIRST ROW ONLY)
       FETCH FIRST ROW ONLY),''), -- Ciudad
    ifnull((select replace(cllug1,',',' ')
       from v5clidat.clgeo1
       where clpaco = (SELECT dir.clpadi
                       FROM v5clidat.CLDI03 dir
                       WHERE dir.CLDOC=comenta
                       FETCH FIRST ROW ONLY)
       and nige01 = (SELECT dir.clprov
                     FROM v5clidat.CLDI03 dir
                     WHERE dir.CLDOC=comenta
                     FETCH FIRST ROW ONLY )
     FETCH FIRST ROW ONLY),''), -- Provincia
     numcta,unidad,tipcta,
     ifnull((select case when b.cadfre = 'AL VENCIMIENTO                '
                  Then 'MENSUAL' else b.cadfre end
     from cartacdat.cacompag a
     inner join cartacdat.CAFREA01 b ON
                a.CACFRE = b.cacfre
     where empcod = '1' and
     canucr = numcta
     and (CAANCP IS NOT NULL
        and CAMECP IS NOT NULL
        and CADICP IS NOT NULL
        and TO_DATE(CAANCP||'-'||CAMECP||'-'||CADICP,'YYYY-MM-DD')
                > CURRENT_DATE)
     FETCH FIRST ROW ONLY), 'MENSUAL'), -- Forma Pago
     'Fija', -- Tipo Cuota
     fec_aper,
     ifnull((select case
              when length(cast(camvec as varchar(2))) = 2
                   and length(cast(cadvec as varchar(2))) = 2
              then caavec||''||camvec||''||cadvec
              when length(cast(camvec as varchar(2))) = 1
                   and length(cast(cadvec as varchar(2))) = 2
              then caavec||'0'||camvec||''||cadvec
              when length(cast(camvec as varchar(2))) = 1
                   and length(cast(cadvec as varchar(2))) = 1
              then caavec||'0'||camvec||'0'||cadvec end
       from cartacdat.cacredit
       where empcod = '1'  and trim(canucr) = trim(numcta)
       FETCH FIRST ROW ONLY),''), -- Fecha Vencimiento
    cast((select cahis6
          from cartacdat.cahisptm
          where empcod = '1'
          and canucr = numcta
          and CAHIS6 <> 0
          order by caartr asc, camrtr asc, cadrtr asc
        FETCH FIRST ROW ONLY) as Numeric(4,2)), -- Tasa Inicial
    char(cast((select camonc
       from cartacdat.cacredit
       where empcod = '1' and trim(canucr) = trim(numcta)
       FETCH FIRST ROW ONLY) as int)), -- Monto Prestamo
    cast(MON_CUO as int),
    NUM_CUO,
    cast((select catino+caindi
       from cartacdat.cacredit
       where empcod = '1' and trim(canucr) = trim(numcta)
       FETCH FIRST ROW ONLY) as Numeric (4,2)), -- Tasa Vigente
    fecha_ult,
    cast(ifnull((select PGTOMO
        from cartacdat.capagos
        where canucr = numcta
        order by canudo desc
        FETCH FIRST ROW ONLY),0) as int), -- Monto Ultimo Pago
    cast(balance as int),
    cast(MONTO_ATR as int),
    CACOD1, -- Cantidad Cuotas Atrasadas
    (select case
                when b.prpecn = 'S' then
                (case
                    when cacstc = 15 then 'REESTRUCTURADO'
                    when cacstc = 16 then 'REEST. MORA'
                    When cacstc = 17 then 'REEST. VENCIDO'
                    else ori.status
                end)
                when b.prpecn <> 'S' then
                (case
                    when cacstc = 15 and castad = 15 then 'REESTRUCTURADO'
                    when cacstc = 15 and castad = 16 then 'REEST. MORA'
                    when cacstc = 15 and castad = 17 then 'REEST. VENCIDO'
                    when cacstc = 16 and castad in (15,16) then 'REEST. MORA'
                    when cacstc = 16 and castad = 17 then 'REEST. VENCIDO'
                    when cacstc = 17 then 'REEST. VENCIDO'
                    else ori.status
                end)
            end
     from cartacdat.cacredit a
     inner join cartacdat.caproduc b
     on a.caprod = b.tippro and a.casubp = b.subpro
     where a.empcod = '1' and a.empcod = b.empcod
     and trim(canucr) = trim(numcta)
     FETCH FIRST ROW ONLY), --Status
    (select case
              when cacstc = 60 then 'C'
              when cacstc != 60 then 'A' end
     from cartacdat.cacredit
     where empcod = '1' and trim(canucr) = trim(numcta)
     FETCH FIRST ROW ONLY), -- Estado Cuenta
    cast(SAL_0129 as int),
    cast(SAL_3059 as int),
    cast(SAL_6089 as int),
    cast(SAL_90119 as int),
    cast(SAL_120 as int),
    cast(SAL_150 as int),
    cast(SAL_180 as int)
    from cartacdat.tabcicla ori;

// Actualizando estatus para cancelados luego de corte
Exec SQL
    UPDATE CARTACDAT.TABCICLAT SET ESTADO_CUE = 'A' WHERE TRIM(NUMCTA) IN (
    SELECT TRIM(CANUCR) FROM CARTACDAT.TABCICLA A
    INNER JOIN CARTACDAT.CACREDIT B ON TRIM(CANUCR) = TRIM(NUMCTA)
    WHERE EMPCOD = :EMPCOD AND CACSTC = 60
    AND CAACAN*10000+CAMCAN*100+CADCAN > :ANOPROC*10000+:MESPROC*100+:DIAPROC
    );

// Elimina prestamos con balance vencido con 48 o mas meses desde el ultimo pago
Exec SQL
    DELETE FROM CARTACDAT.TABCICLAT
    WHERE TRIM(TIPCTA) NOT LIKE '%TARJETA%'
      AND (CASE WHEN TRIM(MONTO_ATR) = '' THEN 0
                ELSE DECIMAL(TRIM(MONTO_ATR)) END) > 0
      AND CASE WHEN TRIM(FECHA_ULTP) = '' THEN 999
               ELSE (:ANOPROC*12+:MESPRO) - (INT(SUBSTR(TRIM(FECHA_ULTP),1,4))*12
                                           + INT(SUBSTR(TRIM(FECHA_ULTP),5,2)))
          END >= 48;

// Elimina prestamos con balance vencido, plazo menor o igual a 48, con 48 o mas
// meses desde la fecha de apertura
Exec SQL
    DELETE FROM CARTACDAT.TABCICLAT
    WHERE TRIM(TIPCTA) NOT LIKE '%TARJETA%'
      AND (CASE WHEN TRIM(MONTO_ATR) = '' THEN 0
                ELSE DECIMAL(TRIM(MONTO_ATR)) END) > 0
      AND (CASE WHEN TRIM(NUM_CUO) = '' THEN 999 ELSE INT(TRIM(NUM_CUO)) END) <= 48
      AND CASE WHEN TRIM(FEC_APER) = '' THEN 999
               ELSE (:ANOPROC*12+:MESPRO) - (INT(SUBSTR(TRIM(FEC_APER),1,4))*12
                                           + INT(SUBSTR(TRIM(FEC_APER),5,2)))
          END >= 48;

// Elimina prestamos con balance vencido con 48 o mas meses desde el ultimo pago
// (TABDATAC)
Exec SQL
    DELETE FROM CARTACDAT.TABDATAC
    WHERE TRIM(TIPCTA) NOT LIKE '%TARJETA%'
      AND MONTO_ATR > 0
      AND CASE WHEN TRIM(FECHA_ULT) = '' THEN 999
               ELSE (:ANOPROC*12+:MESPRO) - (INT(SUBSTR(REPLACE(TRIM(FECHA_ULT),'-',''),1,4))*12
                                           + INT(SUBSTR(REPLACE(TRIM(FECHA_ULT),'-',''),5,2)))
          END >= 48;

// Elimina prestamos con balance vencido, plazo menor o igual a 48, con 48 o mas
// meses desde la fecha de apertura (TABDATAC)
Exec SQL
    DELETE FROM CARTACDAT.TABDATAC
    WHERE TRIM(TIPCTA) NOT LIKE '%TARJETA%'
      AND MONTO_ATR > 0
      AND PLAZO <= 48
      AND CASE WHEN TRIM(FEC_APER) = '' THEN 999
               ELSE (:ANOPROC*12+:MESPRO) - (INT(SUBSTR(REPLACE(TRIM(FEC_APER),'-',''),1,4))*12
                                           + INT(SUBSTR(REPLACE(TRIM(FEC_APER),'-',''),5,2)))
          END >= 48;

*InLr = *on;
return;
