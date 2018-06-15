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

public class tablero extends JPanel implements Runnable {

    private int torreInicio;//Indica donde deven empesar los discos
    private int torreFin;   //Indica donde deven terminar los discos
    private int torreAyuda; //Indica cual sera el poste de ayuda
    private int velocidad;  //indica a que velocidad se desarrollara el juego
    private int numeroDiscos;//Indic el numero de discos que tendra el juego
    private Torre[] torres;

    private JButton botonStart;
    
    //Campos con el contador de movimientos
    private JTextField campoTorreA;
    private JTextField campoTorreB;
    private JTextField campoTorreC;
    private JTable tabla;
    
    private int contadorMovimientos;
    /**
     * Constructor que inicializa todos los paramentros para empesar a trabajar
     * @param torreInicio Es donde empesaran los discos
     * @param torreFin Es donde deven de terminar los discos
     * @param torreAyuda Este es el poste que se usara como ayuda para pasar los discos
     * @param velocidad Es la velocidad con la que se desarrollara el juego
     */
    public tablero(int torreInicio, int torreFin, int torreAyuda, int velocidad, int numeroDiscos,JButton botonStart,JTextField campoTorreA,JTextField campoTorreB,JTextField campoTorreC,JTable tabla) {
        this.torreInicio = torreInicio;
        this.torreFin = torreFin;
        this.torreAyuda = torreAyuda;
        this.velocidad = velocidad;
        this.numeroDiscos = numeroDiscos;
        
        //Iniciliso las 3 torres
        this.torres = new Torre[3];
        torres[0] = new Torre();        
        torres[1] = new Torre();        
        torres[2] = new Torre();
        
        //Creamos una referencia a sia los campo del formulario para poderlos actualizar
        this.botonStart=botonStart;        
        this.campoTorreA = campoTorreA;
        this.campoTorreB = campoTorreB;
        this.campoTorreC = campoTorreC;        
        this.tabla = tabla;
    }

    @Override
    public void paint(Graphics g) {
        Image i = createImage(this.getSize().width,this.getSize().height);
        Graphics gra = i.getGraphics();
        //Obtenemos las nuevas dimenciones de la pantalla para calcular el la nuevas dimenciones de las
        //Torres ya que las torren creson con respecto a la pantalla
        torres[0].setPosicionX(this.getSize().width / 4);
        torres[0].setPosicionY(10);
        torres[0].setPosicionXFinal(6);
        torres[0].setPosicionYFinal(this.getSize().height - 20);
        
        torres[1].setPosicionX(this.getSize().width / 2);
        torres[1].setPosicionY(10);
        torres[1].setPosicionXFinal(6);
        torres[1].setPosicionYFinal(this.getSize().height - 20);

        torres[2].setPosicionX((this.getSize().width / 4) * 3);
        torres[2].setPosicionY(10);
        torres[2].setPosicionXFinal(6);
        torres[2].setPosicionYFinal(this.getSize().height - 20);

        //Se dibujan en el panel las 3 torres
        gra.setColor(Color.red);
        gra.fill3DRect(torres[0].getPosicionX(), torres[0].getPosicionY(), torres[0].getPosicionXFinal(), torres[0].getPosicionYFinal(), true);
        gra.fill3DRect(torres[1].getPosicionX(), torres[1].getPosicionY(), torres[1].getPosicionXFinal(), torres[1].getPosicionYFinal(), true);
        gra.fill3DRect(torres[2].getPosicionX(), torres[2].getPosicionY(), torres[2].getPosicionXFinal(), torres[2].getPosicionYFinal(), true);

        //Una ves impresos las torres devemos imprimir los discos
        for (int c = 0; c < torres.length; c++) {
            //Obtenemos las torres del vector de las torres
            Torre torre = torres[c];
            
            //Obtenemos la pila con los discos que contiene la torre
            Stack<Torre.Disco> pila = torre.clonarPilaDiscos();
            
            //Recuperamos el numeros que tiene actualmente la torre
            int totalDiscos = pila.size();
            
            //Imprimimos los discos
            for (; !pila.isEmpty() ;) {
                Torre.Disco disco = pila.pop();
                int posicionX = (torre.getPosicionX()+3)-(disco.getSize()/2);//posicion en x inicial del disco
                int posicionY = (this.getSize().height-10)-(10*totalDiscos);//posicion en y inicial del disco
                int posicionXFinal = disco.getSize();                       //posicion en x final del disco
                int posicionYFinal = 10;                                    //posicion en y final del disco
                gra.setColor(Color.cyan);
                gra.fill3DRect(posicionX, posicionY, posicionXFinal, posicionYFinal, true);
                totalDiscos--;
            }      
        }
        g.drawImage(i, 0, 0, this);
        this.validate();
    }

    public void run() {
        inizializarTablero();
        try {
            Thread.sleep(velocidad);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, e);
            return;
        }
        pasar(torreInicio, torreFin, torreAyuda, numeroDiscos);
        buildDataFile generarF = new buildDataFile();
        generarF.buildDataFile(tabla,Integer.parseInt(campoTorreA.getText()),Integer.parseInt(campoTorreB.getText()),Integer.parseInt(campoTorreC.getText()));
        botonStart.setEnabled(true);
    }

    public void pasar(int inicio, int fin, int ayuda, int numeroDiscos) {
        if (numeroDiscos == 1) {
            pasar(inicio, fin);
            return;
        } else {
            pasar(inicio, ayuda, fin, numeroDiscos - 1);
            pasar(inicio, fin);
            pasar(ayuda, fin, inicio, numeroDiscos - 1);
            return;
        }
    }

    public void pasar(int inicio, int fin) {
        //Incrementamos el numero de movimientos
        contadorMovimientos++;
        
        //Retiramos el disco del inicio        
        Torre.Disco disco = torres[inicio].getDisco();
        
        //Introducimos el disco al destino
        torres[fin].push(disco.getNumero());
        if(fin ==0){
            campoTorreA.setText( (Integer.parseInt(campoTorreA.getText())+1)+"" );
        }
        else if(fin==1){
            campoTorreB.setText( (Integer.parseInt(campoTorreB.getText())+1)+"" );
        }
        else{
            campoTorreC.setText( (Integer.parseInt(campoTorreC.getText())+1)+"" );
        }
        
        DefaultTableModel modelo = (DefaultTableModel) tabla.getModel();
        modelo.addRow(new Object[]{contadorMovimientos,disco.getNumero(),inicio+1,fin+1,});

        //repintamos el tablero
        this.repaint();
        try {
            Thread.sleep(velocidad);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this,e );
        }
        
    }

    public void inizializarTablero() {
        
        for (int c = this.numeroDiscos; c > 0; c--) {
            //Se crean los discos y se les asigna su numero de disco
            torres[torreInicio].push(c);
        }
        
        this.repaint();
        
    }

    
}
