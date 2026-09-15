/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acap.com.buro;

import com.acap.mas400.as400.Encapsulado.Usuariofijo;
import com.acap.mas400.as400.Manejadores.ManejadorUsuarioFijo;
import com.acap.mas400.conexion.As400Sql;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Repositorio {

    public int ejecutarSQL(String Update) {
        try (Connection con = conectarDB();
             PreparedStatement st = con.prepareStatement(Update)) {
            int filas = st.executeUpdate();
            Logger.getLogger(Repositorio.class.getName()).log(Level.INFO, "SQL OK, filas afectadas: {0}", filas);
            return filas;
        } catch (SQLException ex) {
            Logger.getLogger(Repositorio.class.getName()).log(Level.SEVERE, "SQL ERROR: " + Update, ex);
            javax.swing.JOptionPane.showMessageDialog(null, "Error ejecutando SQL: " + ex.getMessage() + "\nVer log para el SQL completo.");
            throw new RuntimeException(ex);
        }
    }

    public Connection conectarDB() {
        ManejadorUsuarioFijo manejador = new ManejadorUsuarioFijo();
        Usuariofijo usuario = manejador.getListaUsuariofijoSingular();

        return As400Sql.INSTANCIA.setIpServer("ACAP")
                .setPassword(usuario.getContrasena())
                .setUsername(usuario.getUsuario()).connectAS400();
    }
}
