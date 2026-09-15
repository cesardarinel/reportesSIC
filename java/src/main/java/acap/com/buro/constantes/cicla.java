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
public class cicla {

    public static final StringBuffer ELIMINO_TARJETAS_TECNOCOM_PESO = new StringBuffer(" delete @ta_lib.CICLA736DB WHERE substr(F00001,447,16)                "
            + " ||substr(F00001,502,1) in (select EMTANRTA || (CASE WHEN             "
            + " substr(canucr, 1,2)='24' THEN 'R' ELSE 'U' end) from                 "
            + " cartacdat.calgmit0) or substr(F00001,447,16) ||substr(F00001,502,1)  "
            + " in (select EMTANRTA2 || (CASE WHEN substr(canucr, 1,2)='24' THEN     "
            + " 'R' ELSE 'U' end) from cartacdat.calgmit0) or substr(F00001,57,11)   "
            + " in (select substr(cedula,01,03)||substr(cedula,05,07)||              "
            + " substr(cedula,13,01) from cartacdat.CEDULABLO )                      ");

    public static final StringBuffer ELIMINO_TARJETAS_TECNOCOM_DOLAR = new StringBuffer(" delete @ta_lib.CICLA736DB WHERE substr(F00001,447,16)                "
            + " ||substr(F00001,502,1) in (select EMTANRTA || (CASE WHEN             "
            + " substr(canucr, 1,2)='25' THEN 'R' ELSE 'U' end) from                 "
            + " cartacdat.calgmit0) or substr(F00001,447,16) ||substr(F00001,502,1)  "
            + " in (select EMTANRTA2 || (CASE WHEN substr(canucr, 1,2)='25' THEN     "
            + " 'R' ELSE 'U' end) from cartacdat.calgmit0) or substr(F00001,57,11)   "
            + " in (select substr(cedula,01,03)||substr(cedula,05,07)||              "
            + " substr(cedula,13,01) from cartacdat.CEDULABLO )                      ");

    public static final StringBuffer ACTUALIZO_STATUS = new StringBuffer("UPDATE @ta_lib.CICLA736DB  set F00001= substr(F00001,1,620)|| 'Normal                                  '  ||substr(F00001,661,120)  where substr(F00001,621,40)=''");

    public static final StringBuffer ELIMINA_PASAPORTES = new StringBuffer("delete from                     @ta_lib.CICLA736DB   where      substr(F00001,57,11)  in     (select  digits(EMTANIDE)  from @ta_lib.CCSFEMTA   where EMTATIID='P')"
            + "or  substr(F00001,447,16) in   (SELECT EMTANRTA FROM @ta_lib.CCSFEMTA   WHERE EMTACIFA='')   ");

    public static String insertarTarjetasCastigadasVigentes (String fechareporte, String distip) {
        String [] fechaSeparada = fechareporte.split("-");
        String year = fechaSeparada[0];
        String month = fechaSeparada[1];
        String day = fechaSeparada[2];

        return "insert into @TA_LIB.CICLA736DB "
                + "SELECT                               'I' ||','||           cast(REPLACE(D.CLNUID,'-','') as char(12))||','||            cast((a.crnomb) as char(40))||','||           cast(REPLACE(D.CLNUID,'-','') as char(11))||','||           cast('' as char(15))||','||           cast('' as char(60))||','||          cast('' as char(30))||','||          cast('' as char(9) )||','||         cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=4 and cldoc =a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=1 and cldoc =a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=2 and cldoc =a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast('' as char(10))||','||         cast('' as char(10))||','||   cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=1 and  xx.cldoc=a.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=2 and  xx.cldoc=a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=3 and  xx.cldoc=a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + "cast(ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=4 and   xx.cldoc=a.cldoc   FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||     cast('' as char(40))||','||       cast((case when c.EMTANRTA2=' ' then  c.EMTANRTA else c.EMTANRTA2 end)as char(20))||','||           cast('' as char(16))||','||          cast((case when c.EMTANRTA2=' ' then  c.EMTANRTA else c.EMTANRTA2 end)as char(16))||','||    (case when a.distip=24 then  'R' else 'U' end) ||','||           cast('' as char(5))||','||           cast('T' as char(1))||','||         cast(digits(CAACOC)||digits(CAMCOC)||digits(CADCOC) as char(8))||','||         cast('' as char(8))||','||      cast('' as char(8))||','||    cast('000000000000000' as char(12))||','||          cast('000000000000000' as char(12))||','||    cast('000000000000000' as char(12))||','||      cast('000000000000000' as char(12))||','||         cast('000000000000000' as char(12))||','||        cast('000000000000000' as char(12))||','||         cast('000000000000000' as char(3))||','||      cast('Castigada' as char(40))||','||          cast('A' as char(1))||','||       cast('000000000000000' as char(12))||','||               cast('000000000000000' as char(12))||','||            cast('000000000000000' as char(12))||','||              cast('000000000000000' as char(12))||','||               cast('000000000000000' as char(12))||','||                 cast('000000000000000' as char(12))||','||       cast('000000000000000' as char(11)) "
                + "FROM cartacdat.cacredhist a, "
                + "cartacdat.CALGMIT0 c, "
                + "v5clidat.clmcte d,  "
                + " cartacdat.caccsfem e WHERE "
                + "a.distip=" + distip + " and       "
                + "a.canucr=c.canucr and a.cacstc<>60 and a.caacan=0 and  a.cldoc=d.cldoc and C.EMTANRTA= E.EMTANRTA      "
                + "and clnuid not in (select cedula from cartacdat.cedulablo) and a.caacan=0 "
                + "and a.ANOHIS=" + year + " and a.MESHIS=" + month + " AND a.DIAHIS=" + day + " "
                + "order by c.EMTANRTA";
    }

    public static String insertarTarjetasCastigadasCanceladas (String fechaReporte, String distip) {
        String fechaSinGuiones = fechaReporte.replace("-", "");

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate fecha = LocalDate.parse(fechaReporte, formatter);
        String fechaSinGuionesMenos3Meses = fecha.minusMonths(3).format(formatter).replace("-", "");

        return "insert into @TA_LIB.CICLA736DB "
                + "SELECT                               'I' ||','||           cast(REPLACE(D.CLNUID,'-','') as char(12))||','||            cast((a.crnomb) as char(40))||','||           cast(REPLACE(D.CLNUID,'-','') as char(11))||','||           cast('' as char(15))||','||           cast('' as char(60))||','||          cast('' as char(30))||','||          cast('' as char(9) )||','||         cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=4 and cldoc =a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=1 and cldoc =a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=2 and cldoc =a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast('' as char(10))||','||         cast('' as char(10))||','||   cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=1 and  xx.cldoc=a.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=2 and  xx.cldoc=a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=3 and  xx.cldoc=a.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
                + "cast(ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=4 and   xx.cldoc=a.cldoc   FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||     cast('' as char(40))||','||       cast((case when c.EMTANRTA2=' ' then  c.EMTANRTA else c.EMTANRTA2 end)as char(20))||','||           cast('' as char(16))||','||          cast((case when c.EMTANRTA2=' ' then  c.EMTANRTA else c.EMTANRTA2 end)as char(16))||','||    (case when a.distip=24 then  'R' else 'U' end) ||','||           cast('' as char(5))||','||           cast('T' as char(1))||','||         cast(digits(CAACOC)||digits(CAMCOC)||digits(CADCOC) as char(8))||','||         cast('' as char(8))||','||      cast('' as char(8))||','||    cast('000000000000000' as char(12))||','||          cast('000000000000000' as char(12))||','||    cast('000000000000000' as char(12))||','||      cast('000000000000000' as char(12))||','||         cast('000000000000000' as char(12))||','||        cast('000000000000000' as char(12))||','||         cast('000000000000000' as char(3))||','||      cast('CANCELADA' as char(40))||','||          cast('C' as char(1))||','||       cast('000000000000000' as char(12))||','||               cast('000000000000000' as char(12))||','||            cast('000000000000000' as char(12))||','||              cast('000000000000000' as char(12))||','||               cast('000000000000000' as char(12))||','||                 cast('000000000000000' as char(12))||','||       cast('000000000000000' as char(11)) "
                + "FROM cartacdat.cacredit a, "
                + "cartacdat.CALGMIT0 c, "
                + "v5clidat.clmcte d, "
                + "cartacdat.caccsfem e WHERE "
                + "a.canucr=c.canucr and a.cacstc=60 and a.cldoc=d.cldoc and C.EMTANRTA= E.EMTANRTA               "
                + "and clnuid not in (select cedula from cartacdat.cedulablo) and a.caacan<>0  "
                + "and  a.distip=" + distip + " "
                + "and a.canucr=c.canucr and a.caacan*10000+a.camcan*100+a.cadcan between " + fechaSinGuionesMenos3Meses + " and " + fechaSinGuiones + " "
                + "order by c.EMTANRTA";
    }

    public static StringBuffer DIRECCION = new StringBuffer("UPDATE @ta_lib.CICLA736DB  set f00001= substr(f00001,1,240)||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx,v5clidat.clmcte yy where xx.CLDIRC=1 and  xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,57,11) FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx ,v5clidat.clmcte yy where xx.CLDIRC=2 and  xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,57,11)FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx ,v5clidat.clmcte yy where xx.CLDIRC=3 and  xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,57,11)FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast(ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx ,v5clidat.clmcte yy where xx.CLDIRC=4 and   xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,57,11)  FETCH FIRST 1 ROWS ONLY),'') as char(40))||"
            + "substr(f00001,405,348)"
            + " where substr(f00001,242,2)=''");

    public static StringBuffer ACTUALIZAR_TARJETA_POR_CUENTA = new StringBuffer(" UPDATE @TA_LIB.CICLA736DB SET " +
            " F00001 = replace(substr(F00001,0,447), 'Ã', 'Ñ')||ifnull((select CUENTA FROM @TA_LIB.TARTJCTE WHERE PAN=replace(trim(substr(F00001,447,16)), ',', '')), ifnull((select CUENTA FROM @TA_LIB.TARTJCTE WHERE PAN=replace(trim(substr(F00001,447,17)), ',', '')),'            '))||substr(F00001,466,758) ");

    // Solicitud 2026-289: eliminar creditos diferidos con balance vencido por mas
    // de 48 meses desde el ultimo pago (o desde la apertura si no hubo pagos),
    // sobre el archivo plano CICLA736DB.
    //
    // VALIDACION DE POSICIONES (misma técnica que ELIMINA_PASAPORTES):
    //  - ELIMINA_PASAPORTES usa substr(F00001,57,11)=cedula y substr(F00001,447,16)=cuenta/tarjeta.
    //    Reconstruyendo el INSERT de castigadas (cast(... as char(N)) + ',' como separador,
    //    acumulado 1-indexed) se obtiene:
    //      57,11  = CEDULA (coincide con pasaportes -> ancla válida)
    //      447,20 = NUMCTA | 485,16 = PAN | 502,1 = moneda R/U | 504,5 = filler
    //      510,1  = tipo 'T' (tarjeta) | 512,8 = FEC_APER | 521,8 = FEC_VEN/ULT
    //      539,12 = primer monto (MONTO_ATR) | 621,40 = STATUS
    //    Por eso el código anterior con 504 / 533 / 515 / 506 estaba desplazado -6
    //    y leía delimitadores ',' dentro del campo -> DECIMAL/INT fallaba (SQL -413).
    //  - Excluir tarjetas: TRIM(substr(F00001,510,1)) <> 'T'.
    //    Igual que ELIMINA_PASAPORTES, las castigadas recién insertadas traen 'T',
    //    por lo que quedan excluidas automáticamente (no se borran castigados-tarjeta).
    //  - MONTO_ATR: pos 539,12. Se tolera ',' o '|' por si la fila aún no pasó por
    //    limpieza, y se ignora si contiene letras/espacios (TRANSLATE -> 0, no error).
    //  - FECHA_ULTP: pos 521,8 (YYYYMMDD). '00000000'/blanco/no-numérico = sin pago.
    //  - FEC_APER: pos 512,8 (YYYYMMDD), fallback cuando no hubo pagos.
    //  Referencia RPG (PROCI15): mismo filtro pero sobre tabla estructurada TABCICLAT
    //  (TRIM(TIPCTA) NOT LIKE '%TARJETA%', MONTO_ATR>0, FECHA_ULTP/FEC_APER YYYYMMDD).
    //  Para estar seguro del filtrado, antes de ejecutar el DELETE correr el SELECT
    //  de validación de abajo (obtenerValidadorVencidosCicla) y comparar conteos.
    public static StringBuffer ELIMINA_VENCIDOS_48 = new StringBuffer("DELETE FROM @TA_LIB.CICLA736DB "
            + " WHERE TRIM(substr(F00001,510,1)) <> 'T' "
            + " AND (CASE WHEN TRIM(REPLACE(REPLACE(substr(F00001,539,12),',',''),'|','')) = '' THEN 0 "
            + " WHEN TRIM(TRANSLATE(TRIM(REPLACE(REPLACE(substr(F00001,539,12),',',''),'|','')),' ','0123456789')) <> '' THEN 0 "
            + " ELSE DECIMAL(TRIM(REPLACE(REPLACE(substr(F00001,539,12),',',''),'|',''))) END) > 0 "
            + " AND ( (CASE WHEN TRIM(substr(F00001,521,8)) = '' OR TRIM(substr(F00001,521,8)) = '00000000' THEN -999 "
            + " WHEN TRIM(TRANSLATE(TRIM(substr(F00001,521,8)),' ','0123456789')) <> '' THEN -999 "
            + " ELSE (:ANOPROC*12+:MESPRO) - (INT(SUBSTR(TRIM(substr(F00001,521,8)),1,4))*12 "
            + " + INT(SUBSTR(TRIM(substr(F00001,521,8)),5,2))) END) > 48 "
            + " OR ( (TRIM(substr(F00001,521,8)) = '' OR TRIM(substr(F00001,521,8)) = '00000000' "
            + " OR TRIM(TRANSLATE(TRIM(substr(F00001,521,8)),' ','0123456789')) <> '') "
            + " AND TRIM(substr(F00001,512,8)) <> '' AND TRIM(substr(F00001,512,8)) <> '00000000' "
            + " AND TRIM(TRANSLATE(TRIM(substr(F00001,512,8)),' ','0123456789')) = '' "
            + " AND (CASE WHEN TRIM(substr(F00001,512,8)) = '' OR TRIM(substr(F00001,512,8)) = '00000000' THEN -999 "
            + " WHEN TRIM(TRANSLATE(TRIM(substr(F00001,512,8)),' ','0123456789')) <> '' THEN -999 "
            + " ELSE (:ANOPROC*12+:MESPRO) - (INT(SUBSTR(TRIM(substr(F00001,512,8)),1,4))*12 "
            + " + INT(SUBSTR(TRIM(substr(F00001,512,8)),5,2))) END) > 48) ) ");
}
