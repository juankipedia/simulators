package com.hanoiTowers;

import java.awt.Graphics;
import java.util.Stack;

public class Torre {
    private Stack<Disco> todosLosDiscos;//Representa todos los disco que tiene la torre actual
    private int posicionX;              //Representa la posicion inicial en X
    private int posicionY;              //Representa la posicion inicial en Y
    private int posicionXFinal;         //Representa la posicion Final en X
    private int posicionYFinal;         //Representa la posicion Final en Y
            
    /**
     * Constructor que inicializar la pila de todos los dicos
     * @param posicionX Es la posicion promedio del palo en X, promedio por que si es de X0=5 y X1=15 la posicion de x sera 10
     * @param posicionY Es la posicion promedio del palo en Y, Explicacion arriba
     */
    public Torre(int posicionX,int posicionY,int posicionXFinal,int posicionYFinal){
        this.posicionX = posicionX;
        this.posicionY = posicionY;
        this.posicionXFinal = posicionXFinal;
        this.posicionYFinal = posicionYFinal;
        todosLosDiscos = new Stack<Disco>();        
    }
    
    public Torre(){
        todosLosDiscos = new Stack<Disco>();      
    }
    
    /**
     * Metodo que devuelve el ultimo disco de la torre,Pero sin eliminarlo
     * @return Devuelve el disco del tope de la torre
     */
    public Disco peek(){
        return todosLosDiscos.peek();
    }
    
    /**
     * Metodo utilizado para eliminar el ultimo disco de la pila y devolverlo
     * @return Devulve el disco de mas arriba de la torre eliminandolo de la torre
     */
    public Disco getDisco(){
        return todosLosDiscos.pop();
    }
    
    /**
     * Metodo encargado de agregar un disco a al tope de la torre
     * @param numeroDisco Es el numero de disco que se le asignara al nuevo disco
     */
    public void push(int numeroDisco){        
        todosLosDiscos.push(new Disco(numeroDisco));
    }
    
    /**
     * Metodo utilizado para obtener una copia de la pila de los discos de la torre
     * @return Devuelve la pila de todos los discos de la torre
     */
    public Stack<Disco> clonarPilaDiscos(){
        return (Stack<Disco>) todosLosDiscos.clone();
    }
   
    
    /**
     * Metodo encargado de pintar el palo con todos sus discos
     * @param g
     */
    public void paint(Graphics g){
        Stack<Disco> todosLosDiscosCopia = (Stack) todosLosDiscos.clone();
        g.fill3DRect(getPosicionX(),getPosicionY(),getPosicionXFinal(),getPosicionYFinal(), true);
        
        int posicionMedia = (getPosicionX()-getPosicionXFinal())/2;
        for(int c=1;todosLosDiscosCopia.isEmpty();c++){
            Disco disco = todosLosDiscos.pop();
            int mitad = disco.getSize()/2;
            posicionMedia-=mitad;
            g.fill3DRect(posicionMedia, getPosicionYFinal()-(c*10), disco.getSize(), 10, true);
        }
    }

    public int getPosicionX() {
        return posicionX;
    }

    public void setPosicionX(int posicionX) {
        this.posicionX = posicionX;
    }

    public int getPosicionY() {
        return posicionY;
    }

    public void setPosicionY(int posicionY) {
        this.posicionY = posicionY;
    }

    public int getPosicionXFinal() {
        return posicionXFinal;
    }

    public void setPosicionXFinal(int posicionXFinal) {
        this.posicionXFinal = posicionXFinal;
    }

    public int getPosicionYFinal() {
        return posicionYFinal;
    }

    public void setPosicionYFinal(int posicionYFinal) {
        this.posicionYFinal = posicionYFinal;
    }
    
    
    
    
    /**
     *Clase privada que representa un disco dentro de la Torre
     */
    class Disco{
        //Representa el numero de disco que es,Aparte nos sirve para calcular
        //El tamaño del mismo multiplicando el numero por 10
        int numeroDisco;
                        
        
        public Disco(int numeroDisco){
            this.numeroDisco=numeroDisco;
        }
        
        /**
         * Metodo encargado de desirnos el tamaño del disco
         * @return regresa el tamaño del disco
         */
        public int getSize(){
            return numeroDisco*10;
        }
        
        /**
         * Metodu usado para obtener el numero de disco
         * @return numeo de disco
         */
        public int getNumero(){
            return numeroDisco;
        }
    }
}
