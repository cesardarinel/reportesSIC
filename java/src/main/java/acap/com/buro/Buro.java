package acap.com.buro;

import acap.com.buro.constantes.cicla;
import acap.com.buro.constantes.datacredito;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import javax.swing.JOptionPane;

public class Buro {

    private static final String EXTENCION = ".txt";
    private static final String RUTA = "C:\\DATA\\";
    private static final String MASK = "******";
    private final String fechareporte;

    public Buro(String fechareporte) {
        this.fechareporte = fechareporte;
        procesos();
    }

    private void generarArchivoDataCredito(String select) {
        try {
            Connection con = (new Repositorio()).conectarDB();
            try (FileOutputStream fw = new FileOutputStream(new File(RUTA.concat("DATA")
                    .concat(this.fechareporte)
                    .concat(EXTENCION)));
                    BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fw, StandardCharsets.UTF_8))) {
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(select);

                int numCols = rs.getMetaData().getColumnCount();

                while (rs.next()) {
                    boolean ignoredRow = false;

                    for (int i = 1; i <= numCols; i++) {
                        try {
                            String dataWithComa = rs.getString(i).replace("|", ",");
                            List<String> fila = new ArrayList<String>(Arrays.asList(dataWithComa.split(",")));

                            if (((String) fila.get(1)).trim().isEmpty()) {
                                ignoredRow = true;
                                break;
                            }

                            if (fila.size() < 55) {
                                if (((String) fila.get(fila.size() - 1)).trim().isEmpty()) {
                                    fila.add("                ");
                                } else {
                                    fila.add(fila.get(fila.size() - 1));
                                    fila.set(fila.size() - 2, "          ");
                                }
                            }

                            // Enmascarar tarjeta (defensivo: ignora valores cortos/vacíos)
                            int lastPosition = fila.size() - 1;
                            if (!((String) fila.get(lastPosition)).trim().isEmpty()) {
                                fila.set(lastPosition, enmascararPan((String) fila.get(lastPosition)));
                            }

                            String updatedData = String.join("|", fila).trim();
                            bw.write(updatedData);
                        } catch (Exception e) {
                            Logger.getLogger(Buro.class.getName()).log(Level.SEVERE, null, e);
                            JOptionPane.showMessageDialog(null, "Ocurrió un error generando el archivo txt de Datacredito: " + e.getMessage());
                        }
                    }

                    if (!ignoredRow) {
                        bw.newLine();
                    }
                }

                rs.close();
                stmt.close();
            } catch (Exception e) {
                Logger.getLogger(Buro.class.getName()).log(Level.SEVERE, null, e);
                JOptionPane.showMessageDialog(null, "Ocurrió un error generando el archivo de DataCredito: " + e.getMessage());
            }
        } catch (Exception e) {
            Logger.getLogger(Buro.class.getName()).log(Level.SEVERE, null, e);
            JOptionPane.showMessageDialog(null, "Ocurrió un error generando el archivo de DataCredito: " + e.getMessage());
        }
    }

    private void generarArchivoCicla(String select) {
        int batchSize = 100;

        try {
            Connection con = (new Repositorio()).conectarDB();
            try (FileOutputStream fw = new FileOutputStream(new File(RUTA.concat("CICLA")
                    .concat(this.fechareporte)
                    .concat(EXTENCION)));
                    BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fw, StandardCharsets.UTF_8))) {
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(select);

                int numCols = rs.getMetaData().getColumnCount();
                List<List<String>> filas = new ArrayList<List<String>>();
                int row = 0;
                while (rs.next()) {
                    for (int i = 1; i <= numCols; i++) {
                        List<String> fila = Arrays.asList(rs.getString(i).split(","));
                        filas.add(fila);
                        row++;

                        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "Fila: " + row);

                        if (row % batchSize == 0) {
                            escribirCicla(con, bw, filas);
                            filas.clear();
                        }
                    }
                }

                if (!filas.isEmpty()) {
                    escribirCicla(con, bw, filas);
                }

                rs.close();
                stmt.close();
            } catch (Exception e) {
                Logger.getLogger(Buro.class.getName()).log(Level.SEVERE, null, e);
                JOptionPane.showMessageDialog(null, "Ocurrió un error generando el archivo de Transunion: " + e.getMessage());
            }
        } catch (Exception e) {
            Logger.getLogger(Buro.class.getName()).log(Level.SEVERE, null, e);
            JOptionPane.showMessageDialog(null, "Ocurrió un error generando el archivo de Transunion: " + e.getMessage());
        }
    }

    private void escribirCicla(Connection con, BufferedWriter bw, List<List<String>> filas) throws IOException {
        String query = "SELECT IFNULL(LISTAGG(F, ','), '') FROM (SELECT TRIM(PAN)||'-'||CUENTA AS F FROM @TA_LIB.TARTJCTE1 WHERE PAN IN (";
        String tarjetas = "";
        String tarjeta2 = "";
        Map<String, String> MapaCuentaPan = new HashMap<String, String>();

        for (int j = 0; j < filas.size(); j++) {
            int cardPosition = 18;
            if (((List) filas.get(j)).size() > 43) {
                cardPosition = 19;
            }

            if (j < filas.size() - 1) {
                tarjetas = tarjetas + "'" + ((String) ((List) filas.get(j)).get(cardPosition)).trim() + "',";
            } else {
                tarjetas = tarjetas + "'" + ((String) ((List) filas.get(j)).get(cardPosition)).trim() + "'))";
            }
        }

        query = query + tarjetas;

        try {
            PreparedStatement statement = con.prepareStatement(query);
            ResultSet resultCuenta = statement.executeQuery();
            if (resultCuenta.next()
                    && !resultCuenta.getString(1).isEmpty()) {
                List<String> listaCuentaPan = Arrays.asList(resultCuenta.getString(1).split(","));
                for (String l : listaCuentaPan) {
                    MapaCuentaPan.put(l.split("-")[0], l.split("-")[1]);
                }
            }

            resultCuenta.close();
            statement.close();
        } catch (Exception e) {
            Logger.getLogger(Buro.class.getName()).log(Level.SEVERE, null, e);
            JOptionPane.showMessageDialog(null, "Ocurrió un error obteniendo el PAN y la CUENTA para Transunion: " + e.getMessage());
        }

        for (int j = 0; j < filas.size(); j++) {
            int cardPosition = 18;
            if (((List) filas.get(j)).size() > 43) {
                cardPosition = 19;
            }

            if (MapaCuentaPan.containsKey(((String) ((List) filas.get(j)).get(cardPosition)).trim())) {

                ((List) filas.get(j)).set(cardPosition, MapaCuentaPan.get(((String) ((List) filas.get(j)).get(cardPosition)).trim()));

                StringBuilder filaEscribir = new StringBuilder((String) ((List) filas.get(j)).get(0));

                if (((List) filas.get(j)).size() < 43) {
                    tarjeta2 = ((String) ((List) filas.get(j)).get(19)).trim();

                    if (!tarjeta2.isEmpty()) {
                        ((List) filas.get(j)).set(19, enmascararPan((String) ((List) filas.get(j)).get(19)));
                    }
                } else if (((List) filas.get(j)).size() > 43) {
                    tarjeta2 = ((String) ((List) filas.get(j)).get(20)).trim();

                    if (!tarjeta2.isEmpty()) {
                        ((List) filas.get(j)).set(20, enmascararPan((String) ((List) filas.get(j)).get(20)));
                    }

                    ((List) filas.get(j)).set(21, enmascararPan((String) ((List) filas.get(j)).get(21)));
                } else {
                    tarjeta2 = ((String) ((List) filas.get(j)).get(19)).trim();

                    if (!tarjeta2.isEmpty()) {
                        ((List) filas.get(j)).set(19, enmascararPan((String) ((List) filas.get(j)).get(19)));
                    }

                    ((List) filas.get(j)).set(20, enmascararPan((String) ((List) filas.get(j)).get(20)));
                }

                boolean flag = false;
                for (int temp = 1; temp < ((List) filas.get(j)).size(); temp++) {
                    if (((String) ((List) filas.get(j)).get(0)).equals("E") && ((List) filas.get(j)).size() == 44 && temp == 5) {
                        filaEscribir.append(',').append(((String) ((List) filas.get(j)).get(5)).trim()).append(" ").append((String) ((List) filas.get(j)).get(6));
                        flag = true;
                    } else if (!flag || temp != 6) {
                        filaEscribir.append(',').append((String) ((List) filas.get(j)).get(temp));
                    }
                }
                bw.write(String.valueOf(filaEscribir));
                bw.newLine();
            }
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

    public void exportarArchivoCicla() {
        String select = "SELECT * FROM @ta_lib.cicla736DB";
        long inicio = System.currentTimeMillis();
        generarArchivoCicla(select);
        long fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "exportarArchivoCicla: " + ((fin - inicio) / 1000.0D) + " s");
    }

    public void eportarArchivoDatacredito() {
        String select = "SELECT * FROM @ta_lib.DATAC736DB";
        long inicio = System.currentTimeMillis();
        generarArchivoDataCredito(select);
        long fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "eportarArchivoDatacredito: " + ((fin - inicio) / 1000.0D) + " s");
    }

    private Map<String, String> obtenerCuentasPorBatch(Connection con, List<String> panBatch) throws SQLException {
        Map<String, String> result = new HashMap<String, String>();
        String placeholders = (String) panBatch.stream().map(p -> "?").collect(Collectors.joining(","));
        String query = "SELECT PAN, CUENTA FROM @TA_LIB.TARTJCTE1 WHERE PAN IN (" + placeholders + ")";

        try (PreparedStatement ps = con.prepareStatement(query)) {
            for (int i = 0; i < panBatch.size(); i++) {
                ps.setString(i + 1, (String) panBatch.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                result.put(rs.getString("PAN"), rs.getString("CUENTA"));
            }
        }

        return result;
    }

    private void procesos() {
        Repositorio actualizarDatabase = new Repositorio();

        // fechareporte viene como yyyy-MM-dd desde Home (JXDatePicker + SimpleDateFormat).
        String anoProc = this.fechareporte.substring(0, 4);
        // Sin ceros a la izquierda a propósito: se inyecta como número en (ANO*12+MES).
        String mesProc = String.valueOf(Integer.parseInt(this.fechareporte.substring(5, 7)));
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "Fecha reporte=" + this.fechareporte + " => ANO=" + anoProc + " MES=" + mesProc);

        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "CICLA.........................");

        long inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.ACTUALIZO_STATUS.toString());
        long fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ACTUALIZO_STATUS: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.DIRECCION.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "DIRECCION: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.ELIMINO_TARJETAS_TECNOCOM_DOLAR.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ELIMINO_TARJETAS_TECNOCOM_DOLAR: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.ELIMINO_TARJETAS_TECNOCOM_PESO.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ELIMINO_TARJETAS_TECNOCOM_PESO: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.ELIMINA_PASAPORTES.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ELIMINA_PASAPORTES: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.insertarTarjetasCastigadasVigentes(this.fechareporte, "24"));
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "INSERTAR_TARJETAS CASTIGADAS VIGENTES DISTIP 24: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.insertarTarjetasCastigadasVigentes(this.fechareporte, "25"));
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "INSERTAR_TARJETAS CASTIGADAS VIGENTES DISTIP 25: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.insertarTarjetasCastigadasCanceladas(this.fechareporte, "24"));
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "INSERTAR_TARJETAS CASTIGADAS CANCELADAS DISTIP 24: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.insertarTarjetasCastigadasCanceladas(this.fechareporte, "25"));
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "INSERTAR_TARJETAS CASTIGADAS CANCELADAS DISTIP 25: " + ((fin - inicio) / 1000.0D) + " s");

        // Solicitud 2026-289: diferidos con balance vencido > 48 meses.
        // Las castigadas traen 'T' en 510, por lo que quedan excluidas solas.
        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(cicla.ELIMINA_VENCIDOS_48.toString().replace(":ANOPROC", anoProc).replace(":MESPRO", mesProc));
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ELIMINA_VENCIDOS_48 CICLA: " + ((fin - inicio) / 1000.0D) + " s");

        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "DATACREDITO.........................");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.DIRECCION.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "DIRECCION: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.ELIMINO_TARJETAS_TECNOCOM.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ELIMINO_TARJETAS_TECNOCOM: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.ELIMINA_PASAPORTES.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ELIMINA_PASAPORTES: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.insertarTarjetasCastigadasCanceladas(this.fechareporte));
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "INSERTAR_TARJETAS CASTIGADAS CACELADAS: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.insertarTarjetasCastigadasVigente(this.fechareporte));
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "INSERTAR_TARJETAS CASTIGADAS VIGENTES: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.AGREGAR_TARJETAS_VIEJAS.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "AGREGAR_TARJETAS_VIEJAS: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.ACTUALIZAR_COMA.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ACTUALIZAR_COMA: " + ((fin - inicio) / 1000.0D) + " s");

        // Solicitud 2026-289: DESPUÉS de ACTUALIZAR_COMA (el SQL tolera ',' y '|')
        // y ANTES de reemplazar PAN por CUENTA. Las castigadas traen PAN en 14,16.
        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.ELIMINA_VENCIDOS_48.toString().replace(":ANOPROC", anoProc).replace(":MESPRO", mesProc));
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ELIMINA_VENCIDOS_48 DATACREDITO: " + ((fin - inicio) / 1000.0D) + " s");

        inicio = System.currentTimeMillis();
        actualizarDatabase.ejecutarSQL(datacredito.ACTUALIZAR_TARJETA_POR_CUENTA.toString());
        fin = System.currentTimeMillis();
        Logger.getLogger(Buro.class.getName()).log(Level.INFO, "ACTUALIZAR_TARJETA_POR_CUENTA: " + ((fin - inicio) / 1000.0D) + " s");
    }
}
