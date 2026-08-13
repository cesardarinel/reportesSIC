/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acap.com.buro.constantes;

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

    public static final StringBuffer INSERTAR_TARJETAS_CASTIGADAS_VIGENTE = new StringBuffer("insert into @TA_LIB.CICLA736DB "
            + "SELECT                               'I' ||','||           cast(REPLACE(D.CLNUID,'-','') as char(12))||','||            cast((B.CLINO1||B.CLIAP1||B.CLIAP2) as char(40))||','||           cast(REPLACE(D.CLNUID,'-','') as char(11))||','||           cast('' as char(15))||','||           cast('' as char(60))||','||          cast('' as char(30))||','||          cast('' as char(9) )||','||         cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=4 and cldoc =b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=1 and cldoc =b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=2 and cldoc =b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast('' as char(10))||','||         cast('' as char(10))||','||   cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=1 and  xx.cldoc=b.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=2 and  xx.cldoc=b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=3 and  xx.cldoc=b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast(ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=4 and   xx.cldoc=b.cldoc   FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||     cast('' as char(40))||','||       cast((case when c.EMTANRTA2=' ' then  c.EMTANRTA else c.EMTANRTA2 end)as char(20))||','||           cast('' as char(16))||','||          cast((case when c.EMTANRTA2=' ' then  c.EMTANRTA else c.EMTANRTA2 end)as char(16))||','||    (case when a.distip=24 then  'R' else 'U' end) ||','||           cast('' as char(5))||','||           cast('T' as char(1))||','||         cast(digits(CAACOC)||digits(CAMCOC)||digits(CADCOC) as char(8))||','||         cast('' as char(8))||','||      cast('' as char(8))||','||    cast('000000000000000' as char(12))||','||          cast('000000000000000' as char(12))||','||    cast('000000000000000' as char(12))||','||      cast('000000000000000' as char(12))||','||         cast('000000000000000' as char(12))||','||        cast('000000000000000' as char(12))||','||         cast('000000000000000' as char(3))||','||      cast('Castigada' as char(40))||','||          cast('A' as char(1))||','||       cast('000000000000000' as char(12))||','||               cast('000000000000000' as char(12))||','||            cast('000000000000000' as char(12))||','||              cast('000000000000000' as char(12))||','||               cast('000000000000000' as char(12))||','||                 cast('000000000000000' as char(12))||','||       cast('000000000000000' as char(11)) "
            + "FROM cartacdat.cacredhist a, "
            + "v5clidat.clpein b, "
            + "cartacdat.CALGMIT0 c, "
            + "v5clidat.clmcte d,  "
            + " cartacdat.caccsfem e WHERE a.cldoc=b.cldoc and   "
            + "a.distip='DISTIPREMPLAZAR'  and       "
            + "a.canucr=c.canucr and a.cacstc<>60 and a.caacan=0 and  a.cldoc=d.cldoc and C.EMTANRTA= E.EMTANRTA      "
            + "and clnuid not in (select cedula from cartacdat.cedulablo) and a.caacan=0 "
            + " and date(a.ANOHIS||'-'||a.MESHIS||'-'||a.DIAHIS)=date('FECHAREMPLAZAR')  "
            + "order by c.EMTANRTA");

    public static final StringBuffer INSERTAR_TARJETAS_CASTIGADAS_CANCELADAS = new StringBuffer("insert into @TA_LIB.CICLA736DB "
            + "SELECT                               'I' ||','||           cast(REPLACE(D.CLNUID,'-','') as char(12))||','||            cast((B.CLINO1||B.CLIAP1||B.CLIAP2) as char(40))||','||           cast(REPLACE(D.CLNUID,'-','') as char(11))||','||           cast('' as char(15))||','||           cast('' as char(60))||','||          cast('' as char(30))||','||          cast('' as char(9) )||','||         cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=4 and cldoc =b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=1 and cldoc =b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast(IFNULL((select replace(CLDSDI,'-','') from v5clidat.cldedi03 where  CLCOSI=2 and cldoc =b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(10))||','||           cast('' as char(10))||','||         cast('' as char(10))||','||   cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx where xx.CLDIRC=1 and  xx.cldoc=b.cldoc  FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=2 and  xx.cldoc=b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=3 and  xx.cldoc=b.cldoc FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast(ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx  where xx.CLDIRC=4 and   xx.cldoc=b.cldoc   FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||     cast('' as char(40))||','||       cast((case when c.EMTANRTA2=' ' then  c.EMTANRTA else c.EMTANRTA2 end)as char(20))||','||           cast('' as char(16))||','||          cast((case when c.EMTANRTA2=' ' then  c.EMTANRTA else c.EMTANRTA2 end)as char(16))||','||    (case when a.distip=24 then  'R' else 'U' end) ||','||           cast('' as char(5))||','||           cast('T' as char(1))||','||         cast(digits(CAACOC)||digits(CAMCOC)||digits(CADCOC) as char(8))||','||         cast('' as char(8))||','||      cast('' as char(8))||','||    cast('000000000000000' as char(12))||','||          cast('000000000000000' as char(12))||','||    cast('000000000000000' as char(12))||','||      cast('000000000000000' as char(12))||','||         cast('000000000000000' as char(12))||','||        cast('000000000000000' as char(12))||','||         cast('000000000000000' as char(3))||','||      cast('CANCELADA' as char(40))||','||          cast('C' as char(1))||','||       cast('000000000000000' as char(12))||','||               cast('000000000000000' as char(12))||','||            cast('000000000000000' as char(12))||','||              cast('000000000000000' as char(12))||','||               cast('000000000000000' as char(12))||','||                 cast('000000000000000' as char(12))||','||       cast('000000000000000' as char(11)) "
            + "FROM cartacdat.cacredit a, v5clidat.clpein b,"
            + "cartacdat.CALGMIT0 c, "
            + "v5clidat.clmcte d, "
            + "cartacdat.caccsfem e WHERE a.cldoc=b.cldoc and "
            + "a.canucr=c.canucr and a.cacstc=60 and a.cldoc=d.cldoc and C.EMTANRTA= E.EMTANRTA               "
            + "and clnuid not in (select cedula from cartacdat.cedulablo) and a.caacan<>0  "
            + "and  a.distip='DISTIPREMPLAZAR'    "
            + "and date(a.caacan||'-'||a.camcan||'-'||a.cadcan)<=date('FECHAREMPLAZAR')   "
            + "and date(a.caacan||'-'||a.camcan||'-'||a.cadcan)>=(date('FECHAREMPLAZAR') - 3 MONTHS) order by c.EMTANRTA");

    public static StringBuffer DIRECCION = new StringBuffer("UPDATE @ta_lib.CICLA736DB  set f00001= substr(f00001,1,240)||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx,v5clidat.clmcte yy where xx.CLDIRC=1 and  xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,57,11) FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx ,v5clidat.clmcte yy where xx.CLDIRC=2 and  xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,57,11)FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast( ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx ,v5clidat.clmcte yy where xx.CLDIRC=3 and  xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,57,11)FETCH FIRST 1 ROWS ONLY),'') as char(40))||','||"
            + "cast(ifnull((select replace(cldire||cldir2||cldir3,',','') from v5clidat.cldicl12 xx ,v5clidat.clmcte yy where xx.CLDIRC=4 and   xx.cldoc=yy.cldoc and replace(yy.clnuid,'-','')=substr(f00001,57,11)  FETCH FIRST 1 ROWS ONLY),'') as char(40))||"
            + "substr(f00001,405,348)"
            + " where substr(f00001,242,2)=''");
}
