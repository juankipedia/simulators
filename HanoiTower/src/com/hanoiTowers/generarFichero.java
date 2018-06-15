package com.hanoiTowers;

import java.awt.Desktop;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import javax.swing.JOptionPane;
import javax.swing.JTable;

public class generarFichero {

    File f;
    FileWriter ficheroEscritura;
    BufferedWriter escribir;

    public generarFichero() {
        f = new File("./data.txt");
        if (!f.exists()) {
            try {
                f.createNewFile();
            } catch (Exception e) {
                JOptionPane.showMessageDialog(null, "Err: Creating");
                return;
            }
        }


        try {
            ficheroEscritura = new FileWriter(f, false);
            escribir = new BufferedWriter(ficheroEscritura);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Err:loading");
            return;
        }
    }

    public void generarFichero(JTable tabla,int totalTorreA,int totalTorreB,int totalTorreC) {
        int totalFilas = tabla.getRowCount();
        int totalColumnas = 4;
        int i=0;

        try {
            escribir.write("\tData");
            escribir.newLine();
            escribir.newLine();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,"Err: writing" );
        }
        

        for (int c = 0; c < totalFilas; c++) {
            try {
                escribir.write("Movement:"+(Integer)tabla.getValueAt(c, i++) + "  |  Disc:"+(Integer)tabla.getValueAt(c, i++)+"  |  From: "+(Integer)tabla.getValueAt(c, i++)+"  |  To: "+(Integer)tabla.getValueAt(c, i++));
                escribir.newLine();
                i=0;
            } catch (Exception e) {
                JOptionPane.showMessageDialog(null, "Err: writing line"+e);
                return;
            }
        }
        

        try {
            escribir.newLine();
            escribir.newLine();
            escribir.newLine();
            escribir.write("\t\tMovements:"+(totalTorreA+totalTorreB+totalTorreC));
            escribir.newLine();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,"Err: writing" );
        }
        
        try {
            escribir.close();
            ficheroEscritura.close();            
        } catch (Exception e) {}

        Desktop d = Desktop.getDesktop();
        try {
            d.open(f);
        } catch (Exception e) {}
        
    }

    public static void main(String[] args) {
        new generarFichero();
    }
}
