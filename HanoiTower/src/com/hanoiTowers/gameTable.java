package com.hanoiTowers;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.util.Stack;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;

public class gameTable extends JPanel implements Runnable {

    private int originTower;
    private int endTower;
    private int auxTower;
    private int speed;
    private int towerSize;
    private Tower[] towers;

    private JButton startButton;
    
    //Campos con el contador de movimientos
    private JTextField fieldTowerA;
    private JTextField fieldTowerB;
    private JTextField fieldTowerC;
    private JTable table;
    
    private int movementsCounter;

    public gameTable(int originTower, int endTower, int auxTower, int speed, int towerSize, JButton startButton, JTextField fieldTowerA, JTextField fieldTowerB, JTextField fieldTowerC, JTable table) {
        this.originTower = originTower;
        this.endTower = endTower;
        this.auxTower = auxTower;
        this.speed = speed;
        this.towerSize = towerSize;
        
        //Iniciliso las 3 towers
        this.towers = new Tower[3];
        towers[0] = new Tower();
        towers[1] = new Tower();
        towers[2] = new Tower();
        
        //Creamos una referencia a sia los campo del formulario para poderlos actualizar
        this.startButton = startButton;
        this.fieldTowerA = fieldTowerA;
        this.fieldTowerB = fieldTowerB;
        this.fieldTowerC = fieldTowerC;
        this.table = table;
    }

    @Override
    public void paint(Graphics g) {
        Image i = createImage(this.getSize().width,this.getSize().height);
        Graphics gra = i.getGraphics();
        gra.setColor(new Color(34,34,34));
        gra.fill3DRect(0,0, this.getSize().width,this.getSize().height, true);

        towers[0].setXpos(this.getSize().width / 4);
        towers[0].setYpos(10);
        towers[0].setXposFinal(6);
        towers[0].setYposFinal(this.getSize().height - 20);
        
        towers[1].setXpos(this.getSize().width / 2);
        towers[1].setYpos(10);
        towers[1].setXposFinal(6);
        towers[1].setYposFinal(this.getSize().height - 20);

        towers[2].setXpos((this.getSize().width / 4) * 3);
        towers[2].setYpos(10);
        towers[2].setXposFinal(6);
        towers[2].setYposFinal(this.getSize().height - 20);

        //Se dibujan en el panel las 3 towers
        gra.setColor(Color.blue);
        gra.fill3DRect(towers[0].getXpos(), towers[0].getYpos(), towers[0].getXposFinal(), towers[0].getYposFinal(), true);
        gra.fill3DRect(towers[1].getXpos(), towers[1].getYpos(), towers[1].getXposFinal(), towers[1].getYposFinal(), true);
        gra.fill3DRect(towers[2].getXpos(), towers[2].getYpos(), towers[2].getXposFinal(), towers[2].getYposFinal(), true);

        //Una ves impresos las towers devemos imprimir los discos
        for (int c = 0; c < towers.length; c++) {
            //Obtenemos las towers del vector de las towers
            Tower tower = towers[c];
            
            //Obtenemos la pila con los discos que contiene la tower
            Stack<Tower.Disc> pila = tower.cloneDiscsStack();
            
            //Recuperamos el numeros que tiene actualmente la tower
            int totalDiscos = pila.size();
            
            //Imprimimos los discos
            for (; !pila.isEmpty() ;) {
                Tower.Disc disc = pila.pop();
                int posicionX = (tower.getXpos()+3)-(disc.getSize()/2);//posicion en x inicial del disc
                int posicionY = (this.getSize().height-10)-(10*totalDiscos);//posicion en y inicial del disc
                int posicionXFinal = disc.getSize();                       //posicion en x final del disc
                int posicionYFinal = 10;                                    //posicion en y final del disc
                gra.setColor(Color.yellow);
                gra.fill3DRect(posicionX, posicionY, posicionXFinal, posicionYFinal, true);
                totalDiscos--;
            }      
        }
        g.drawImage(i, 0, 0, this);
        this.validate();
    }

    public void run() {
        initializeBoard();
        try {
            Thread.sleep(speed);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, e);
            return;
        }
        move(originTower, endTower, auxTower, towerSize);
        buildDataFile generarF = new buildDataFile();
        generarF.buildDataFile(table,Integer.parseInt(fieldTowerA.getText()),Integer.parseInt(fieldTowerB.getText()),Integer.parseInt(fieldTowerC.getText()));
        startButton.setEnabled(true);
    }

    public void move(int origin, int end, int aux, int discsNumber) {
        if (discsNumber == 1) {
            move(origin, end);
            return;
        } else {
            move(origin, aux, end, discsNumber - 1);
            move(origin, end);
            move(aux, end, origin, discsNumber - 1);
            return;
        }
    }

    public void move(int origin, int end) {
        movementsCounter++;

        Tower.Disc disc = towers[origin].getDisc();

        towers[end].push(disc.getNum());
        if(end ==0){
            fieldTowerA.setText( (Integer.parseInt(fieldTowerA.getText())+1)+"" );
        }
        else if(end==1){
            fieldTowerB.setText( (Integer.parseInt(fieldTowerB.getText())+1)+"" );
        }
        else{
            fieldTowerC.setText( (Integer.parseInt(fieldTowerC.getText())+1)+"" );
        }
        
        DefaultTableModel modelo = (DefaultTableModel) table.getModel();
        modelo.addRow(new Object[]{movementsCounter, disc.getNum(),origin+1,end+1,});

        this.repaint();
        try {
            Thread.sleep(speed);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this,e );
        }
        
    }

    public void initializeBoard() {
        
        for (int c = this.towerSize; c > 0; c--) {
            towers[originTower].push(c);
        }
        
        this.repaint();
        
    }

    
}
