/*
 * GUI.java
 *
 * Created on 1 de mayo de 2008, 08:40 AM
 */
package com.hanoiTowers;

import java.awt.*;
import javax.swing.table.DefaultTableModel;

public class GUI extends javax.swing.JFrame {

    gameTable t;
    Thread gameThread;

    public GUI() {
        initComponents();
    
    }

    private void addBoard() {
        int originTower = 1;
        int endTower = 3;
        int helpTower = 2;
        int discsNumber = Integer.parseInt(discsNumberField.getText());

        int speed = Integer.parseInt(speedField.getText());
        t = new gameTable(originTower - 1, endTower - 1, helpTower - 1, speed, discsNumber, startButton, towerAField, towerBField, towerCField, table);
        boardPanel.add(t, BorderLayout.CENTER);
        this.validate();
    }
    

    private void start() {
        addBoard();
        this.gameThread = new Thread(t);
        this.gameThread.start();
    }
    // End of variables declaration

    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {
        jPanel1 = new javax.swing.JPanel();
        boardPanel = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        discsNumberField = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        speedField = new javax.swing.JTextField();
        startButton = new javax.swing.JButton();
        resetButton = new javax.swing.JButton();
        pauseButton = new javax.swing.JButton();
        jPanel6 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        table = new javax.swing.JTable();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        towerAField = new javax.swing.JTextField();
        towerBField = new javax.swing.JTextField();
        towerCField = new javax.swing.JTextField();
        jSeparator1 = new javax.swing.JSeparator();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("LAS TORRES DE HANOI");

        jPanel1.setBackground(new java.awt.Color(34,34,34));
        jPanel6.setBackground(new java.awt.Color(34,34,34));
        jPanel4.setBackground(new java.awt.Color(34,34,34));

        discsNumberField.setForeground(new java.awt.Color(255,255,255));
        discsNumberField.setBackground(new java.awt.Color(89,89,89));

        speedField.setForeground(new java.awt.Color(255,255,255));
        speedField.setBackground(new java.awt.Color(89,89,89));

        towerAField.setForeground(new java.awt.Color(255,255,255));
        towerAField.setBackground(new java.awt.Color(89,89,89));

        towerBField.setForeground(new java.awt.Color(255,255,255));
        towerBField.setBackground(new java.awt.Color(89,89,89));

        towerCField.setForeground(new java.awt.Color(255,255,255));
        towerCField.setBackground(new java.awt.Color(89,89,89));

        jPanel1.setBackground(new java.awt.Color(34, 34, 34));

        boardPanel.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(34, 34, 34)));
        boardPanel.setMinimumSize(new java.awt.Dimension(2, 2));
        boardPanel.setLayout(new java.awt.BorderLayout());
        boardPanel.setBackground(new java.awt.Color(34,34,34));

        table.setBackground(new java.awt.Color(34,34,34));
        table.setForeground(new java.awt.Color(255,255,255));

        jPanel5.setBorder(javax.swing.BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.RAISED));
        jPanel5.setBackground(new java.awt.Color(34,34,34));

        jLabel3.setFont(new java.awt.Font("Verdana", 1, 14));
        jLabel3.setText("Settings:");
        jLabel3.setForeground(new java.awt.Color(255,255,255));
        jLabel3.setBackground(new java.awt.Color(34,34,34));

        jLabel4.setFont(new java.awt.Font("Calibri", 0, 14));
        jLabel4.setText("Discs:");
        jLabel4.setForeground(new java.awt.Color(255,255,255));

        jLabel7.setFont(new java.awt.Font("Calibri", 0, 14));
        jLabel7.setText("Speed:");
        jLabel7.setForeground(new java.awt.Color(255,255,255));

        startButton.setText("Start");
        startButton.setForeground(new java.awt.Color(255,255,255));
        startButton.setBackground(new java.awt.Color(89,89,89));
        startButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                botonStartActionPerformed(evt);
            }
        });

        resetButton.setText("Reset");
        resetButton.setBackground(new java.awt.Color(89,89,89));
        resetButton.setForeground(new java.awt.Color(255,255,255));
        resetButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                botonResetActionPerformed(evt);
            }
        });

        pauseButton.setText("Stop");
        pauseButton.setBackground(new java.awt.Color(89,89,89));
        pauseButton.setForeground(new java.awt.Color(255,255,255));
        pauseButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                botonPausaActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jLabel3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 167, Short.MAX_VALUE)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 86, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGroup(jPanel5Layout.createSequentialGroup()
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED))
                                        .addGroup(jPanel5Layout.createSequentialGroup()
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                                    .addGroup(jPanel5Layout.createSequentialGroup()
                                        .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 86, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(speedField, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(discsNumberField, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(11, 11, 11))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(startButton, javax.swing.GroupLayout.DEFAULT_SIZE, 179, Short.MAX_VALUE)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addComponent(pauseButton, javax.swing.GroupLayout.PREFERRED_SIZE, 85, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(resetButton, javax.swing.GroupLayout.DEFAULT_SIZE, 88, Short.MAX_VALUE)))))))
                        .addContainerGap())))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(discsNumberField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(speedField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 31, Short.MAX_VALUE)
                .addComponent(startButton)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(pauseButton)
                    .addComponent(resetButton))
                .addContainerGap())
        );

        jPanel6.setBorder(javax.swing.BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.RAISED));

        table.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "#", "Disc", "From", "To"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class, java.lang.String.class, java.lang.Integer.class, java.lang.Integer.class
            };
            boolean[] canEdit = new boolean [] {
                false, false, false, false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jScrollPane1.setViewportView(table);
        jScrollPane1.setBackground(new java.awt.Color(34,34,34));
        ;
        jLabel8.setFont(new java.awt.Font("Verdana", 1, 14));
        jLabel8.setText("Executed Movements:");
        jLabel8.setForeground(new Color(255,255,255));

        jLabel9.setText("Tower 1:");
        jLabel9.setForeground(new Color(255,255,255));

        jLabel10.setText("Tower 2:");
        jLabel10.setForeground(new Color(255,255,255));


        jLabel11.setText("Tower 3:");
        jLabel11.setForeground(new Color(255,255,255));

        jLabel12.setFont(new java.awt.Font("Verdana", 1, 14));
        jLabel12.setText("Towers Movements:");
        jLabel12.setForeground(new Color(255,255,255));


        towerAField.setEditable(false);
        towerAField.setText("0");

        towerBField.setEditable(false);
        towerBField.setText("0");

        towerCField.setEditable(false);
        towerCField.setText("0");

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel12, javax.swing.GroupLayout.DEFAULT_SIZE, 421, Short.MAX_VALUE)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel9)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(towerAField, javax.swing.GroupLayout.PREFERRED_SIZE, 96, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel10)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(towerBField, javax.swing.GroupLayout.DEFAULT_SIZE, 92, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel11)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(towerCField, javax.swing.GroupLayout.PREFERRED_SIZE, 94, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 421, Short.MAX_VALUE)
                    .addComponent(jLabel8, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 421, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 26, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 131, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel12)
                .addGap(8, 8, 8)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(towerCField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel11)
                    .addComponent(towerBField, javax.swing.GroupLayout.DEFAULT_SIZE, 22, Short.MAX_VALUE)
                    .addComponent(jLabel10)
                    .addComponent(towerAField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jPanel6, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel5, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(boardPanel, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 678, Short.MAX_VALUE)
                    .addComponent(jPanel4, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(boardPanel, javax.swing.GroupLayout.DEFAULT_SIZE, 134, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        getContentPane().add(jPanel1, java.awt.BorderLayout.CENTER);


        pack();
    }// </editor-fold>//GEN-END:initComponents
    private void botonStartActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_botonStartActionPerformed
        startButton.setEnabled(false);
        DefaultTableModel modelo = (DefaultTableModel) table.getModel();
        modelo.getDataVector().clear();
        table.validate();
        towerAField.setText("0");
        towerBField.setText("0");
        towerCField.setText("0");
        start();
        
}//GEN-LAST:event_botonStartActionPerformed

    private void botonResetActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_botonResetActionPerformed
        discsNumberField.setText("");
        speedField.setText("");
        DefaultTableModel modelo = (DefaultTableModel) table.getModel();
        modelo.getDataVector().clear();
        table.validate();
        table.repaint();
        towerAField.setText("0");
        towerBField.setText("0");
        towerCField.setText("0");
        if(gameThread.isAlive()){
           gameThread.stop();
           startButton.setEnabled(true);
        }
    }//GEN-LAST:event_botonResetActionPerformed

    private void botonPausaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_botonPausaActionPerformed
        if (gameThread.isAlive()) {
            gameThread.stop();
        }
        startButton.setEnabled(true);
    }//GEN-LAST:event_botonPausaActionPerformed

    public static void main(String args[]) {
        java.awt.EventQueue.invokeLater(new Runnable() {

            public void run() {
                new GUI().setVisible(true);
            }
        });
    }
    private javax.swing.JButton pauseButton;
    private javax.swing.JButton resetButton;
    private javax.swing.JButton startButton;
    private javax.swing.JTextField discsNumberField;
    private javax.swing.JTextField towerAField;
    private javax.swing.JTextField towerBField;
    private javax.swing.JTextField towerCField;
    private javax.swing.JTextField speedField;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JPanel boardPanel;
    private javax.swing.JTable table;
    // End of variables declaration//GEN-END:variables
}
