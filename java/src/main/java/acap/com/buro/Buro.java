/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acap.com.buro;

import acap.com.buro.constantes.cicla;
import acap.com.buro.constantes.datacredito;

import javax.swing.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class Buro {

    private static final String EXTENCION = ".txt";
    private static final String RUTA = "C:\\DATA\\";
    private static final Logger LOGGER = Logger.getLogger(Buro.class.getName());
    private static final String MASK = "******";
    private final String fechareporte;

    public Buro(String fechareporte) {
        this.fechareporte = fechareporte;
        procesos();
    }

    private void generarArchivoDataCredito(String select) {
        try (Connection con = new Repositorio().conectarDB();
                FileOutputStream fos = new FileOutputStream(new File(RUTA + "DATA" + fechareporte + EXTENCION));
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(fos, StandardCharsets.UTF_8));
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(select)) {

            int columnCount = rs.getMetaData().getColumnCount();

            while (rs.next()) {
                boolean ignoredRow = false;

                for (int i = 1; i <= columnCount; i++) {
                    String dataWithComa = rs.getString(i).replace("|", ",");
                    List<String> rowValues = new ArrayList<>(Arrays.asList(dataWithComa.split(",")));

                    // Si el campo 2 (Cuenta) empezando desde 1 está vacío se excluye la fila
                    if (rowValues.get(1).trim().isEmpty()) {
                        ignoredRow = true;
                        break;
                    }

                    // Se le agrega un valor de más para cumplir con la estructura de 55 campos
                    if (rowValues.size() < 55) {
                        if (rowValues.get(rowValues.size() - 1).trim().isEmpty()) {
                            rowValues.add("                ");
                        } else {
                            rowValues.add(rowValues.get(rowValues.size() - 1));
                            rowValues.set(rowValues.size() - 2, "          ");
                        }
                    }

                    // Enmascarar tarjeta (defensivo: ignora valores cortos/vacíos)
                    int lastPosition = rowValues.size() - 1;
                    if (!rowValues.get(lastPosition).trim().isEmpty()) {
                        rowValues.set(lastPosition, enmascararPan(rowValues.get(lastPosition)));
                    }

                    String updatedData = String.join("|", rowValues).trim();
                    writer.write(updatedData);
                }

                // Si una fila se ignora, no se hace salto de línea
                if (!ignoredRow) {
                    writer.newLine();
                }
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, null, e);
            JOptionPane.showMessageDialog(null, "Ocurrió un error generando el archivo de DataCredito: " + e.getMessage());
        }
    }

    private void generarArchivoCicla(String select) {
        final int batchSize = 100;

        try (Connection con = new Repositorio().conectarDB();
                FileOutputStream fos = new FileOutputStream(new File(RUTA + "CICLA" + fechareporte + EXTENCION));
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(fos, StandardCharsets.UTF_8));
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(select)) {

            int columnCount = rs.getMetaData().getColumnCount();
            List<List<String>> batchRows = new ArrayList<>();
            List<String> panList = new ArrayList<>();
            int rowCount = 0;

            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    List<String> rowValues = Arrays.asList(rs.getString(i).split(","));
                    batchRows.add(rowValues);

                    int panIndex = rowValues.size() > 43 ? 19 : 18;
                    String pan = rowValues.get(panIndex).trim();
                    panList.add(pan);

                    rowCount++;

                    if (rowCount % batchSize == 0) {
                        escribirCicla(con, writer, batchRows, panList);
                        batchRows.clear();
                        panList.clear();
                    }
                }
            }

            if (!batchRows.isEmpty()) {
                escribirCicla(con, writer, batchRows, panList);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, null, e);
            JOptionPane.showMessageDialog(null, "Ocurrió un error generando el archivo de Transunion: " + e.getMessage());
        }
    }

    private Map<String, String> obtenerCuentas(Connection con, List<String> panList) throws SQLException {
        Map<String, String> result = new HashMap<>();
        String pans = panList.stream().map(pan -> "'" + pan + "'").collect(Collectors.joining(","));
        String query = "SELECT IFNULL(LISTAGG(F, ','), '') FROM (SELECT TRIM(PAN)||'-'||CUENTA AS F FROM @TA_LIB.TARTJCTE1 WHERE PAN IN ( " + pans + " ) )";

        try (PreparedStatement ps = con.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next() && !rs.getString(1).isEmpty()) {
                String[] listaPanCuenta = rs.getString(1).split(",");
                for (String l : listaPanCuenta) {
                    result.put(l.split("-")[0], l.split("-")[1]);
                }
            }
        }

        return result;
    }

    private void escribirCicla(Connection con, BufferedWriter bw, List<List<String>> filas, List<String> panList) throws IOException, SQLException {
        Map<String, String> mapaCuentaPan = obtenerCuentas(con, panList);

        for (int j = 0; j < filas.size(); j++) {
            int cardPosition = filas.get(j).size() > 43 ? 19 : 18;

            // Si no se encuentra la cuenta, se ignora ese fila
            if (!mapaCuentaPan.containsKey((filas.get(j).get(cardPosition).trim()))) {
                continue;
            }

            filas.get(j).set(cardPosition, mapaCuentaPan.get((filas.get(j).get(cardPosition).trim())));

            StringBuilder filaEscribir = new StringBuilder(filas.get(j).get(0));

            enmascararTarjetasCicla(filas, j);

            boolean flag = false; // Variable bandera para verificar si se unieron los campos cuando el nombre de la empresa tine coma
            for (int temp = 1; temp < filas.get(j).size(); temp++) {

                // Cuando el nombre de la empresa (campo 6 índice 5) tiene coma. Por ejemplo: EMPRESA, SRL.
                // En esos casos, el nombre se separaría en dos campos debido a la coma. Por lo tanto, se une en un solo campo para mantener la estructura.
                if (filas.get(j).get(0).equals("E") && filas.get(j).size() == 44 && temp == 5) {
                    filaEscribir.append(',').append(filas.get(j).get(5).trim()).append(" ").append(filas.get(j).get(6));
                    flag = true;
                    continue;
                }

                // Cuando se hace la unión del nombre de la empresa em campo 6 (índice 5) se obvia el siguiente campo 7 (índice 6)
                if (flag && temp == 6) {
                    continue;
                }

                filaEscribir.append(',').append(filas.get(j).get(temp));
            }

            bw.write(String.valueOf(filaEscribir));
            bw.newLine();
        }
    }

    private static String enmascararPan(String valor) {
        if (valor == null) {
            return "";
        }
        String t = valor.trim();
        // PAN reales: 13-19 dígitos. Si viene más corto (vacío, cuenta corta,
        // campo no numérico, dato corrupto) se deja tal cual para no reventar
        // con StringIndexOutOfBoundsException y no alterar la estructura.
        if (t.length() <= 10) {
            return t;
        }
        return t.substring(0, 6) + MASK + t.substring(t.length() - 4);
    }

    private void enmascararTarjetasCicla(List<List<String>> filas, int position) {
        if (filas.get(position).size() < 43) {
            filas.get(position).set(19, enmascararPan(filas.get(position).get(19)));

        } else if (filas.get(position).size() > 43) {
            filas.get(position).set(20, enmascararPan(filas.get(position).get(20)));
            filas.get(position).set(21, enmascararPan(filas.get(position).get(21)));
        } else {
            filas.get(position).set(19, enmascararPan(filas.get(position).get(19)));
            filas.get(position).set(20, enmascararPan(filas.get(position).get(20)));
        }
    }

    public void exportarArchivoCicla() {
        String select = "SELECT * FROM @ta_lib.cicla736DB";
        TiempoEjecucionUtil.medirTiempo("exportarArchivoCicla", () -> generarArchivoCicla(select));
    }

    public void eportarArchivoDatacredito() {
        String select = "SELECT * FROM @ta_lib.DATAC736DB";
        TiempoEjecucionUtil.medirTiempo("eportarArchivoDatacredito", () -> generarArchivoDataCredito(select));
    }

    private void procesos() {
        Repositorio actualizarDatabase = new Repositorio();
        //limpiar
        //Cicla
        // fechareporte viene como yyyy-MM-dd desde Home (JXDatePicker + SimpleDateFormat).
        String anoProc = this.fechareporte.substring(0, 4);
        // Sin ceros a la izquierda a propósito: se inyecta como número en (ANO*12+MES).
        String mesProc = String.valueOf(Integer.parseInt(this.fechareporte.substring(5, 7)));
        LOGGER.log(Level.INFO, "Fecha reporte={0} => ANO={1} MES={2}", new Object[]{this.fechareporte, anoProc, mesProc});

        LOGGER.log(Level.INFO, "CICLA.........................");

        TiempoEjecucionUtil.medirTiempo("ACTUALIZO_STATUS", () -> actualizarDatabase.ejecutarSQL(cicla.ACTUALIZO_STATUS.toString()));
        TiempoEjecucionUtil.medirTiempo("DIRECCION", () -> actualizarDatabase.ejecutarSQL(cicla.DIRECCION.toString()));
        TiempoEjecucionUtil.medirTiempo("ELIMINO_TARJETAS_TECNOCOM_DOLAR", () -> actualizarDatabase.ejecutarSQL(cicla.ELIMINO_TARJETAS_TECNOCOM_DOLAR.toString()));
        TiempoEjecucionUtil.medirTiempo("ELIMINO_TARJETAS_TECNOCOM_PESO", () -> actualizarDatabase.ejecutarSQL(cicla.ELIMINO_TARJETAS_TECNOCOM_PESO.toString()));
        TiempoEjecucionUtil.medirTiempo("ELIMINA_PASAPORTES", () -> actualizarDatabase.ejecutarSQL(cicla.ELIMINA_PASAPORTES.toString()));
        TiempoEjecucionUtil.medirTiempo("INSERTAR_TARJETAS CASTIGADAS VIGENTES DISTIP 24", () -> actualizarDatabase.ejecutarSQL(cicla.insertarTarjetasCastigadasVigentes(this.fechareporte, "24")));
        TiempoEjecucionUtil.medirTiempo("INSERTAR_TARJETAS CASTIGADAS VIGENTES DISTIP 25", () -> actualizarDatabase.ejecutarSQL(cicla.insertarTarjetasCastigadasVigentes(this.fechareporte, "25")));
        TiempoEjecucionUtil.medirTiempo("INSERTAR_TARJETAS CASTIGADAS CANCELADAS DISTIP 24", () -> actualizarDatabase.ejecutarSQL(cicla.insertarTarjetasCastigadasCanceladas(this.fechareporte, "24")));
        TiempoEjecucionUtil.medirTiempo("INSERTAR_TARJETAS CASTIGADAS CANCELADAS DISTIP 25", () -> actualizarDatabase.ejecutarSQL(cicla.insertarTarjetasCastigadasCanceladas(this.fechareporte, "25")));
        // Vencidos ANTES de reemplazar PAN por CUENTA para no mover las posiciones 447-510.
        // Las castigadas traen 'T' en 510, por lo que quedan excluidas solas (igual que pasaportes).
        TiempoEjecucionUtil.medirTiempo("ELIMINA_VENCIDOS_48 CICLA", () -> actualizarDatabase.ejecutarSQL(cicla.ELIMINA_VENCIDOS_48.toString().replace(":ANOPROC", anoProc).replace(":MESPRO", mesProc)));
        TiempoEjecucionUtil.medirTiempo("ACTUALIZAR_TARJETA_POR_CUENTA CICLA", () -> actualizarDatabase.ejecutarSQL(cicla.ACTUALIZAR_TARJETA_POR_CUENTA.toString()));

        //DataCredito
        LOGGER.log(Level.INFO, "DATACREDITO.........................");

        TiempoEjecucionUtil.medirTiempo("DIRECCION", () -> actualizarDatabase.ejecutarSQL(datacredito.DIRECCION.toString()));
        TiempoEjecucionUtil.medirTiempo("ELIMINO_TARJETAS_TECNOCOM", () -> actualizarDatabase.ejecutarSQL(datacredito.ELIMINO_TARJETAS_TECNOCOM.toString()));
        TiempoEjecucionUtil.medirTiempo("ELIMINA_PASAPORTES", () -> actualizarDatabase.ejecutarSQL(datacredito.ELIMINA_PASAPORTES.toString()));
        TiempoEjecucionUtil.medirTiempo("INSERTAR_TARJETAS CASTIGADAS CACELADAS", () -> actualizarDatabase.ejecutarSQL(datacredito.insertarTarjetasCastigadasCanceladas(this.fechareporte)));
        TiempoEjecucionUtil.medirTiempo("INSERTAR_TARJETAS CASTIGADAS VIGENTES", () -> actualizarDatabase.ejecutarSQL(datacredito.insertarTarjetasCastigadasVigente(this.fechareporte)));
        TiempoEjecucionUtil.medirTiempo("AGREGAR_TARJETAS_VIEJAS", () -> actualizarDatabase.ejecutarSQL(datacredito.AGREGAR_TARJETAS_VIEJAS.toString()));
        TiempoEjecucionUtil.medirTiempo("ACTUALIZAR_COMA", () -> actualizarDatabase.ejecutarSQL(datacredito.ACTUALIZAR_COMA.toString()));
        // Vencidos DESPUÉS de ACTUALIZAR_COMA (el SQL ya tolera ',' y '|') y ANTES de
        // reemplazar PAN por CUENTA. Las castigadas traen PAN en 14,16 -> excluidas solas.
        TiempoEjecucionUtil.medirTiempo("ELIMINA_VENCIDOS_48 DATACREDITO", () -> actualizarDatabase.ejecutarSQL(datacredito.ELIMINA_VENCIDOS_48.toString().replace(":ANOPROC", anoProc).replace(":MESPRO", mesProc)));
        TiempoEjecucionUtil.medirTiempo("ACTUALIZAR_TARJETA_POR_CUENTA", () -> actualizarDatabase.ejecutarSQL(datacredito.ACTUALIZAR_TARJETA_POR_CUENTA.toString()));

    }
}
