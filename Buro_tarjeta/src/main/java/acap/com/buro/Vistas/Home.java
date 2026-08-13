/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acap.com.buro.Vistas;
import acap.com.buro.Buro;
import java.awt.EventQueue;
import java.awt.HeadlessException;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.GroupLayout;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.LayoutStyle;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import org.jdesktop.swingx.JXDatePicker;

public class Home extends JFrame {
  public Home() { initComponents(); }




  
  JXDatePicker vdate;



  
  private void initComponents() {
    JDialog jDialog1 = new JDialog();
    JDialog jDialog2 = new JDialog();
    JLabel jLabel1 = new JLabel();
    JPanel jPanel1 = new JPanel();
    JLabel jLabel2 = new JLabel();
    JButton jButton1 = new JButton();
    this.vdate = new JXDatePicker();
    JLabel jLabel3 = new JLabel();
    
    GroupLayout jDialog1Layout = new GroupLayout(jDialog1.getContentPane());
    jDialog1.getContentPane().setLayout(jDialog1Layout);
    jDialog1Layout.setHorizontalGroup(jDialog1Layout
        .createParallelGroup(GroupLayout.Alignment.LEADING)
        .addGap(0, 400, 32767));
    
    jDialog1Layout.setVerticalGroup(jDialog1Layout
        .createParallelGroup(GroupLayout.Alignment.LEADING)
        .addGap(0, 300, 32767));

    
    GroupLayout jDialog2Layout = new GroupLayout(jDialog2.getContentPane());
    jDialog2.getContentPane().setLayout(jDialog2Layout);
    jDialog2Layout.setHorizontalGroup(jDialog2Layout
        .createParallelGroup(GroupLayout.Alignment.LEADING)
        .addGap(0, 400, 32767));
    
    jDialog2Layout.setVerticalGroup(jDialog2Layout
        .createParallelGroup(GroupLayout.Alignment.LEADING)
        .addGap(0, 300, 32767));

    
    setDefaultCloseOperation(3);
    
    jLabel1.setText("www.asociacioncibao.com.do");
    
    jLabel2.setText("Fecha de Operación");
    
    jButton1.setText("Generar Reporte");
    jButton1.addMouseListener(new MouseAdapter() {
          @Override
          public void mouseClicked(MouseEvent evt) {
            Home.this.jButton1MouseClicked(evt);
          }
        });
    
    GroupLayout jPanel1Layout = new GroupLayout(jPanel1);
    jPanel1.setLayout(jPanel1Layout);
    jPanel1Layout.setHorizontalGroup(jPanel1Layout
        .createParallelGroup(GroupLayout.Alignment.LEADING)
        .addComponent(this.vdate, GroupLayout.Alignment.TRAILING, -1, -1, 32767)
        .addGroup(jPanel1Layout.createSequentialGroup()
          .addGroup(jPanel1Layout.createParallelGroup(GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
              .addGap(19, 19, 19)
              .addComponent(jLabel2))
            .addGroup(jPanel1Layout.createSequentialGroup()
              .addGap(18, 18, 18)
              .addComponent(jButton1)))
          .addContainerGap(34, 32767)));
    
    jPanel1Layout.setVerticalGroup(jPanel1Layout
        .createParallelGroup(GroupLayout.Alignment.LEADING)
        .addGroup(jPanel1Layout.createSequentialGroup()
          .addContainerGap(56, 32767)
          .addComponent(jLabel2, -2, 16, -2)
          .addPreferredGap(LayoutStyle.ComponentPlacement.RELATED)
          .addComponent(this.vdate, -2, 24, -2)
          .addGap(34, 34, 34)
          .addComponent(jButton1, -2, 44, -2)));

    
    jLabel3.setText("Generar Buro");
    
    GroupLayout layout = new GroupLayout(getContentPane());
    getContentPane().setLayout(layout);
    layout.setHorizontalGroup(layout
        .createParallelGroup(GroupLayout.Alignment.LEADING)
        .addGroup(layout.createSequentialGroup()
          .addGroup(layout.createParallelGroup(GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
              .addContainerGap(-1, 32767)
              .addComponent(jLabel1))
            .addGroup(layout.createSequentialGroup()
              .addGroup(layout.createParallelGroup(GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                  .addGap(72, 72, 72)
                  .addComponent(jPanel1, -2, -1, -2))
                .addGroup(layout.createSequentialGroup()
                  .addGap(127, 127, 127)
                  .addComponent(jLabel3)))
              .addGap(0, 82, 32767)))
          .addContainerGap()));
    
    layout.setVerticalGroup(layout
        .createParallelGroup(GroupLayout.Alignment.LEADING)
        .addGroup(GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
          .addGap(9, 9, 9)
          .addComponent(jLabel3, -2, 30, -2)
          .addPreferredGap(LayoutStyle.ComponentPlacement.RELATED)
          .addComponent(jPanel1, -2, -1, -2)
          .addPreferredGap(LayoutStyle.ComponentPlacement.RELATED, 14, 32767)
          .addComponent(jLabel1)
          .addContainerGap()));

    
    pack();
  }

  
  private void jButton1MouseClicked(MouseEvent evt) {
    try {
      if (!this.vdate.isValid()) {
        DateFormat oDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String fechaReporte = oDateFormat.format(this.vdate.getDate());
        Buro generartasa = new Buro(fechaReporte);
        generartasa.exportarArchivoCicla();
        generartasa.eportarArchivoDatacredito();
        JOptionPane.showMessageDialog(null, "Reporte Generado");
      } else {
        
        JOptionPane.showMessageDialog(null, "La Fecha no Puede estar en blanco");
      } 
    } catch (HeadlessException ex) {
      JOptionPane.showMessageDialog(null, "Hay un error en el Proceso");
    } 
  }









  
  public static void main(String[] args) {
    try {
      for (UIManager.LookAndFeelInfo info : UIManager.getInstalledLookAndFeels()) {
        if ("Nimbus".equals(info.getName())) {
          UIManager.setLookAndFeel(info.getClassName());
          break;
        } 
      } 
    } catch (ClassNotFoundException | InstantiationException | IllegalAccessException | UnsupportedLookAndFeelException ex) {
      Logger.getLogger(Home.class.getName()).log(Level.SEVERE, null, ex);
    } 



    
    EventQueue.invokeLater(() -> {
        (new Home()).setVisible(true);
    });
  }
}
