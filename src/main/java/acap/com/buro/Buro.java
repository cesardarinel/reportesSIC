/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acap.com.buro;

import acap.com.buro.constantes.cicla;
import acap.com.buro.constantes.datacredito;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.Arrays;
import java.util.List;

public class Buro {

    private static final String EXTENCION = ".txt";
    private static final String RUTA = "C:\\DATA\\";
    private final String fechareporte;

    public Buro(String fechareporte) {
        this.fechareporte = fechareporte;
//        procesos();
    }

    private void generarArchivo(String select, String tipo) {
        try {
            Connection con = (new Repositorio()).conectarDB();
            try (FileOutputStream fw = new FileOutputStream(new File("C:\\DATA\\".concat(tipo)
                    .concat(this.fechareporte)
                    .concat(".txt")));
                    BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fw, StandardCharsets.UTF_8))) {
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(select);
                int numCols = rs.getMetaData().getColumnCount();
                while (rs.next()) {
                    for (int i = 1; i <= numCols; i++) {
                        List<String> fila;
                        if("CICLA".equalsIgnoreCase(tipo)){
                            String tarjeta2;
                            fila = Arrays.asList(rs.getString(i).split(","));

                            StringBuilder filaEscribir = new StringBuilder(fila.get(0));

                            if(fila.size() < 43){
                                tarjeta2 = fila.get(19).trim();

                                if(!tarjeta2.isEmpty()){
                                    fila.set(19,fila.get(19).substring(0,6) + "******" + fila.get(19).substring(12,16));
                                }
                            } else if (fila.size() > 43) {
                                tarjeta2 = fila.get(20).trim();

                                if(!tarjeta2.isEmpty()){
                                    fila.set(20,fila.get(20).substring(0,6) + "******" + fila.get(20).substring(12,16));
                                }
                                fila.set(21,fila.get(21).substring(0,6) + "******" + fila.get(21).substring(12,16));
                            } else {
                                tarjeta2 = fila.get(19).trim();

                                if(!tarjeta2.isEmpty()){
                                    fila.set(19,fila.get(19).substring(0,6) + "******" + fila.get(19).substring(12,16));
                                }
                                fila.set(20,fila.get(20).substring(0,6) + "******" + fila.get(20).substring(12,16));
                            }

                            for (int temp = 1; temp < fila.size(); temp++) {

                                filaEscribir.append(',').append(fila.get(temp));
                            }
                            bw.write(String.valueOf(filaEscribir));
                        } else {
                            bw.write(rs.getString(i).trim());
                        }
                    }
                    bw.newLine();
                }
            }
        } catch (IOException | java.sql.SQLException iOException) {
        }
    }

    public void exportarArchivoCicla() {
        String select = "SELECT * FROM @ta_lib.cicla736DB";
        generarArchivo(select, "CICLA");
    }

    public void eportarArchivoDatacredito() {
        String select = "SELECT * FROM @ta_lib.DATAC736DB";
        generarArchivo(select, "DATA");
    }

    private void procesos() {
        Repositorio actualizarDatabase = new Repositorio();
        //limpiar
        //Cicla
        actualizarDatabase.ejecutarSQL(cicla.ACTUALIZO_STATUS.toString());
        actualizarDatabase.ejecutarSQL(cicla.DIRECCION.toString());
        actualizarDatabase.ejecutarSQL(cicla.ELIMINO_TARJETAS_TECNOCOM_DOLAR.toString());
        actualizarDatabase.ejecutarSQL(cicla.ELIMINO_TARJETAS_TECNOCOM_PESO.toString());
        actualizarDatabase.ejecutarSQL(cicla.ELIMINA_PASAPORTES.toString());
        actualizarDatabase.ejecutarSQL(cicla.INSERTAR_TARJETAS_CASTIGADAS_VIGENTE
                .toString().replaceAll("FECHAREMPLAZAR", this.fechareporte).replaceAll("DISTIPREMPLAZAR", "24"));
        actualizarDatabase.ejecutarSQL(cicla.INSERTAR_TARJETAS_CASTIGADAS_VIGENTE
                .toString().replaceAll("FECHAREMPLAZAR", this.fechareporte).replaceAll("DISTIPREMPLAZAR", "25"));
        actualizarDatabase.ejecutarSQL(cicla.INSERTAR_TARJETAS_CASTIGADAS_CANCELADAS
                .toString().replaceAll("FECHAREMPLAZAR", this.fechareporte).replaceAll("DISTIPREMPLAZAR", "24"));
        actualizarDatabase.ejecutarSQL(cicla.INSERTAR_TARJETAS_CASTIGADAS_CANCELADAS
                .toString().replaceAll("FECHAREMPLAZAR", this.fechareporte).replaceAll("DISTIPREMPLAZAR", "25"));
        actualizarDatabase.ejecutarSQL(cicla.ACTUALIZAR_TARJETA_POR_CUENTA.toString());
        //DataCredito
        actualizarDatabase.ejecutarSQL(datacredito.DIRECCION.toString());
        actualizarDatabase.ejecutarSQL(datacredito.ELIMINO_TARJETAS_TECNOCOM.toString());
        actualizarDatabase.ejecutarSQL(datacredito.ELIMINA_PASAPORTES.toString());
        actualizarDatabase.ejecutarSQL(datacredito.INSERTAR_TARJETAS_CASTIGADAS_CANCELADAS.toString().replaceAll("FECHAREMPLAZAR", this.fechareporte));
        actualizarDatabase.ejecutarSQL(datacredito.INSERTAR_TARJETAS_CASTIGADAS_VIGENTE.toString().replaceAll("FECHAREMPLAZAR", this.fechareporte));
        actualizarDatabase.ejecutarSQL(datacredito.AGREGAR_TARJETAS_VIEJAS.toString());
        actualizarDatabase.ejecutarSQL(datacredito.ACTUALIZAR_COMA.toString());
        actualizarDatabase.ejecutarSQL(datacredito.ACTUALIZAR_TARJETA_POR_CUENTA.toString());
    }
}
