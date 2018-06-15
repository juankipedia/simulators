package com.hanoiTowers;

import java.awt.Desktop;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import javax.swing.JOptionPane;
import javax.swing.JTable;

public class buildDataFile {

    File f;
    FileWriter w;
    BufferedWriter writing;

    public buildDataFile() {
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
            w = new FileWriter(f, false);
            writing = new BufferedWriter(w);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Err:loading");
            return;
        }
    }

    public void buildDataFile(JTable table, int tTowerA, int tTowerB, int tTowerC) {
        int tRows = table.getRowCount();
        int i=0;

        try {
            writing.write("\tData");
            writing.newLine();
            writing.newLine();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,"Err: writing" );
        }
        

        for (int c = 0; c < tRows; c++) {
            try {
                writing.write("Movement:"+(Integer)table.getValueAt(c, i++) + "  |  Disc:"+(Integer)table.getValueAt(c, i++)+"  |  From: "+(Integer)table.getValueAt(c, i++)+"  |  To: "+(Integer)table.getValueAt(c, i++));
                writing.newLine();
                i=0;
            } catch (Exception e) {
                JOptionPane.showMessageDialog(null, "Err: writing line"+e);
                return;
            }
        }
        

        try {
            writing.newLine();
            writing.newLine();
            writing.newLine();
            writing.write("\t\tMovements:"+(tTowerA + tTowerB + tTowerC));
            writing.newLine();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,"Err: writing" );
        }
        
        try {
            writing.close();
            w.close();
        } catch (Exception e) {}

        Desktop d = Desktop.getDesktop();
        try {
            d.open(f);
        } catch (Exception e) {}
        
    }

    public static void main(String[] args) {
        new buildDataFile();
    }
}
