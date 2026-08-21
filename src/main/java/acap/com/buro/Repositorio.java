/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acap.com.buro;

import com.acap.mas400.as400.Encapsulado.Usuariofijo;
import com.acap.mas400.as400.Manejadores.ManejadorUsuarioFijo;
import com.acap.mas400.conexion.As400Sql;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Repositorio {

    public void ejecutarSQL(String Update) {
        try {
            PreparedStatement st = conectarDB().prepareStatement(Update);
            st.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(Repositorio.class.getName()).log(Level.SEVERE, null, ex);
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
