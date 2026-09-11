/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acap.com.buro.constantes;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author acap1831
 */
public class datacredito {

    public static final StringBuffer ELIMINO_TARJETAS_TECNOCOM = new StringBuffer("delete @ta_lib.DATAC736DB  where  substr(F00001, 14,16)"
            + " in(select EMTANRTA from cartacdat.calgmit0) or substr(F00001, 14,16)  in (select EMTANRTA2 from cartacdat.calgmit0) "
            + " or  substr(F00001,105,11) in (select substr(cedula,01,03)||substr(cedula,05,07)|| substr(cedula,13,01) "
            + " from cartacdat.CEDULABLO ) ");

    public static final StringBuffer ELIMINA_PASAPORTES = new StringBuffer("delete from  @ta_lib.DATAC736DB   where   substr(F00001,105,11) "
            + "in     (select  digits(EMTANIDE)  from @ta_lib.CCSFEMTA   where EMTATIID='P') or  substr(F00001,14,16)  in  "
            + "(SELECT EMTANRTA FROM @ta_lib.CCSFEMTA   WHERE EMTACIFA='')    ");

    public static final StringBuffer ACTUALIZAR_COMA = new StringBuffer("UPDATE @TA_LIB.DATAC736DB SET F00001=REPLACE(F00001,',', '|') ");

    public static final StringBuffer AGREGAR_TARJETAS_VIEJAS = new StringBuffer("UPDATE @TA_LIB.DATAC736DB SET "
            + " F00001= substr(F00001,1,742)||(select cast(panant as char(16))  from @TA_LIB.tartjcte1 WHERE PAN=substr(F00001, 14,16) )"
            + " where  substr(F00001, 14,16) in (select PAN from @TA_LIB.tartjcte1) ");

    public static String insertarTarjetasCastigadasVigente (String fecha) {
        String [] fechasSeparada = fecha.split("-");
        String year =  fechasSeparada[0];
        String month = fechasSeparada[1];
        String day = fechasSeparada[2];

        return "insert into @TA_LIB.DATAC736DB "
                + " SELECT  DISTINCT cast(trim(replace(D.CLNUID,'-','')) as char(12)) ||','||"
                + " e.EMTANRTA ||','||"
                + " case when B.CLIAP1 is not null then  "
                + " cast(B.CLIAP1 as char(20))||','||"
                + " cast(B.CLIAP2 as char(20))||','||"
                + " cast(B.CLINO1 as char(20))||','||"
                + " case when B.CLISEX='F' then 'M' else 'V' end ||','||"
                + " cast(digits(B.CLANNA)||digits(B.CLMENA) ||digits(B.CLDINA) as char(8)) else cast(H.CLRAZS as char(20))||',                    ,                    , ,        '  END||','||  "
                + " cast(REPLACE(D.CLNUID,'-','') as char(12))||','||"
                + " cast(REPLACE(D.CLNUID,'-','') as char(12))||','||"
                + " cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=1 and  xx.cldoc=d.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + " cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=2 and  xx.cldoc=d.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + " cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=3 and  xx.cldoc=d.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + " cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=4 and cldoc =d.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||          "
                + " cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=1 and cldoc =d.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           "
                + " cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=2 and cldoc =d.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           "
                + " cast('9400000000' as char(10))||','||"
                + " cast(e.EMTAFUA1 as char(8))||','||          "
                + " LPAD(cast(e.EMTALCR1 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTALCR2 as INTEGER),11,'0')||','||                "
                + " ifnull((select LPAD(cast((cacavi+cainme+cainac+casato+casaco) as INTEGER) ,11,'0') from cartacdat.cacredhist a,cartacdat.CALGMIT0 c  where "
                + " a.EMPCOD='1' AND a.ANOHIS=" + year + " and a.MESHIS=" + month + " AND a.DIAHIS=" + day + " and a.canucr=c.canucr AND C.EMPCOD='1' "
                + " and  c.EMTANRTA=e.EMTANRTA and distip=24 FETCH FIRST 1 ROWS ONLY), '00000000000' ) ||','||"
                + " ifnull((select LPAD(cast((cacavi+cainme+cainac+casato+casaco) as INTEGER) ,11,'0') from cartacdat.cacredhist a,cartacdat.CALGMIT0 c  where "
                + " a.EMPCOD='1' AND a.ANOHIS=" + year + " and a.MESHIS=" + month +  " AND a.DIAHIS=" + day + " and a.canucr=c.canucr AND C.EMPCOD='1' "
                + " and  c.EMTANRTA=e.EMTANRTA and distip=25 FETCH FIRST 1 ROWS ONLY), '00000000000' ) ||','|| "
                + " LPAD(cast(e.EMTAPMI1 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTAPMI2 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTASAC1 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTASAC2 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0301 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0302 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0601 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0602 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0901 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0902 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1201 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1202 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1501 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1502 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1801 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1802 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2101 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2102 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2401 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2402 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2701 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2702 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3001 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3002 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3301 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3302 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3601 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3602 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTAFUP1 as INTEGER),8,'0')||','|| "
                + " LPAD(cast(e.EMTAFUP2 as INTEGER),8,'0')||','||"
                + " LPAD(cast(e.EMTAUPA1 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTAUPA2 as INTEGER),11,'0')||','||"
                + " cast('' as char(9))||','|| "
                + " cast('' as char(16))"
                + " FROM cartacdat.caccsfem e "
                + " INNER JOIN v5clidat.clmcte d ON REPLACE(clnuid,'-','') = CASE WHEN EMTATIID = 'R' THEN SUBSTR(DIGITS(EMTANIDE), 3) ELSE DIGITS(EMTANIDE) END "
                + " LEFT JOIN v5clidat.clpein b ON b.cldoc=d.cldoc"
                + " LEFT JOIN v5clidat.clpeju H ON H.cldoc=d.cldoc"
                + " WHERE clnuid not in (select cedula from cartacdat.cedulablo) and  "
                + " e.EMTANRTA in (select c.EMTANRTA FROM cartacdat.cacredhist a,cartacdat.CALGMIT0 c  WHERE a.EMPCOD='1' AND a.ANOHIS=" + year + " and a.MESHIS=" + month + " AND a.DIAHIS=" + day + " and a.canucr=c.canucr AND C.EMPCOD='1' AND a.cacstc<>60  and a.caacan=0   group by EMTANRTA) ";
    }

    public static String insertarTarjetasCastigadasCanceladas (String fechareporte) {
        String [] fechaSeparada = fechareporte.split("-");
        String fechaSinGuiones = fechareporte.replace("-", "");

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate fecha = LocalDate.parse(fechareporte, formatter);
        String fechaSinGuionesMenos3Meses = fecha.minusMonths(3).format(formatter).replace("-", "");

        String year =  fechaSeparada[0];
        String month = fechaSeparada[1];
        String day = fechaSeparada[2];

        return "insert into @TA_LIB.DATAC736DB "
                + " SELECT  cast(trim(replace(D.CLNUID,'-','')) as char(12)) ||','||"
                + " e.EMTANRTA ||','||"
                + " case when B.CLIAP1 is not null then  "
                + " cast(B.CLIAP1 as char(20))||','||"
                + " cast(B.CLIAP2 as char(20))||','||"
                + " cast(B.CLINO1 as char(20))||','||"
                + " case when B.CLISEX='F' then 'M' else 'V' end ||','||"
                + " cast(digits(B.CLANNA)||digits(B.CLMENA) ||digits(B.CLDINA) as char(8)) else cast(H.CLRAZS as char(20))||',                    ,                    , ,        '  END||','||"
                + " cast(REPLACE(D.CLNUID,'-','') as char(12))||','||"
                + " cast(REPLACE(D.CLNUID,'-','') as char(12))||','||"
                + " cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=1 and  xx.cldoc=d.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + " cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=2 and  xx.cldoc=d.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + " cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=3 and  xx.cldoc=d.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + " cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=4 and cldoc =d.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||          "
                + " cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=1 and cldoc =d.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           "
                + " cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=2 and cldoc =d.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           "
                + " cast('CANCELADA ' as char(10))||','||"
                + " cast(e.EMTAFUA1 as char(8))||','||          "
                + " LPAD(cast(e.EMTALCR1 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTALCR2 as INTEGER),11,'0')||','||"
                + " '00000000000'  ||','||"
                + " '00000000000'  ||','||"
                + " LPAD(cast(e.EMTAPMI1 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTAPMI2 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTASAC1 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTASAC2 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0301 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0302 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0601 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0602 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0901 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA0902 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1201 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1202 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1501 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1502 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1801 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA1802 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2101 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2102 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2401 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2402 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2701 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA2702 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3001 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3002 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3301 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3302 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3601 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTA3602 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTAFUP1 as INTEGER),8,'0')||','|| "
                + " LPAD(cast(e.EMTAFUP2 as INTEGER),8,'0')||','||"
                + " LPAD(cast(e.EMTAUPA1 as INTEGER),11,'0')||','||"
                + " LPAD(cast(e.EMTAUPA2 as INTEGER),11,'0')||','||"
                + " cast('' as char(9))||','|| "
                + " cast('' as char(16))"
                + " FROM cartacdat.caccsfem e "
                + " INNER JOIN v5clidat.clmcte d ON REPLACE(clnuid,'-','') = CASE WHEN EMTATIID = 'R' THEN SUBSTR(DIGITS(EMTANIDE), 3) ELSE DIGITS(EMTANIDE) END "
                + " LEFT JOIN v5clidat.clpein b ON b.cldoc=d.cldoc"
                + " LEFT JOIN v5clidat.clpeju H ON H.cldoc=d.cldoc"
                + " WHERE clnuid not in (select cedula from cartacdat.cedulablo) "
                + " and e.EMTANRTA in (select c.EMTANRTA FROM cartacdat.cacredit a,cartacdat.CALGMIT0 c WHERE   a.caacan<>0   and a.cacstc=60  and a.canucr=c.canucr and a.caacan*10000+a.camcan*100+a.cadcan between " + fechaSinGuionesMenos3Meses + " and " + fechaSinGuiones
                + " and e.EMTANRTA not in (select c.EMTANRTA FROM cartacdat.cacredhist a,cartacdat.CALGMIT0 c  WHERE a.EMPCOD='1' AND a.ANOHIS=" + year + " and a.MESHIS=" + month + " AND a.DIAHIS=" + day + " and a.canucr=c.canucr AND C.EMPCOD='1' AND a.cacstc<>60  and a.caacan=0 ) group by EMTANRTA) ";
    }

    public static StringBuffer DIRECCION = new StringBuffer(" UPDATE @ta_lib.DATAC736DB  set"
            + " f00001= substr(f00001,1,129)||','|| cast( ifnull((select replace(cldire||cldir2||cldir3,',','') "
            + "from v5clidat.cldicl12 xx,v5clidat.clmcte yy where xx.CLDIRC=1 and  xx.cldoc=yy.cldoc "
            + "and replace(yy.clnuid,'-','')=substr(f00001,105,12) FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from "
            + "v5clidat.cldicl12 xx ,v5clidat.clmcte yy where xx.CLDIRC=2 and  xx.cldoc=yy.cldoc "
            + "and replace(yy.clnuid,'-','')=substr(f00001,105,12)FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast(ifnull((select replace(cldire||cldir2||cldir3,',','') from "
            + "v5clidat.cldicl12 xx ,v5clidat.clmcte yy where xx.CLDIRC=3 and   "
            + "xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,105,12)  FETCH FIRST 1 ROWS ONLY),'') as char(40))"
            + "||substr(f00001,253,507)  where substr(f00001,132,2)='' ");

    public static StringBuffer ACTUALIZAR_TARJETA_POR_CUENTA = new StringBuffer(" UPDATE @TA_LIB.DATAC736DB SET " +
            " F00001 = substr(F00001,0,12)||'|'||" +
            " ifnull((select CUENTA FROM @TA_LIB.TARTJCTE1 WHERE PAN=substr(F00001,14,16)), '            ')||substr(F00001,30,758)");

    // Solicitud 2026-289: eliminar creditos diferidos con balance vencido por mas
    // de 48 meses desde el ultimo pago (o desde la apertura si no hubo pagos),
    // sobre el archivo plano DATAC736DB (posiciones segun layout CA3TAR08/campos).
    // Suposiciones por validar:
    //  - Excluir tarjetas: TRIM(substr(F00001,14,16)) = '' (tarjetas tienen TARJETA_NO)
    //  - MONTO_ATR (monto atrasado): pos 379,11  (VENCIDO_RD)
    //  - FECHA_ULT (ultimo pago):    pos 691,8   (FULTPAG_RD, YYYYMMDD)
    //  - FEC_APER  (apertura):       pos 298,8   (APERTURA, YYYYMMDD)
    public static StringBuffer ELIMINA_VENCIDOS_48 = new StringBuffer("DELETE FROM @TA_LIB.DATAC736DB "
            + " WHERE TRIM(substr(F00001,14,16)) = '' "
            + " AND (CASE WHEN TRIM(substr(F00001,379,11)) = '' THEN 0 "
            + " ELSE DECIMAL(TRIM(substr(F00001,379,11))) END) > 0 "
            + " AND ( (TRIM(substr(F00001,691,8)) <> '' "
            + "     AND (:ANOPROC*12+:MESPRO) - (INT(SUBSTR(TRIM(substr(F00001,691,8)),1,4))*12 "
            + "         + INT(SUBSTR(TRIM(substr(F00001,691,8)),5,2))) > 48) "
            + "   OR (TRIM(substr(F00001,691,8)) = '' AND TRIM(substr(F00001,298,8)) <> '' "
            + "     AND (:ANOPROC*12+:MESPRO) - (INT(SUBSTR(TRIM(substr(F00001,298,8)),1,4))*12 "
            + "         + INT(SUBSTR(TRIM(substr(F00001,298,8)),5,2))) > 48) ) ");
}
