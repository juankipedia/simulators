package com.hanoiTowers;

import java.awt.Graphics;
import java.util.Stack;

public class Tower {
    private Stack<Disc> allDiscs;
    private int Xpos;
    private int Ypos;
    private int XposFinal;
    private int YposFinal;

    public Tower(int Xpos, int Ypos, int XposFinal, int YposFinal){
        this.Xpos = Xpos;
        this.Ypos = Ypos;
        this.XposFinal = XposFinal;
        this.YposFinal = YposFinal;
        allDiscs = new Stack<Disc>();
    }
    
    public Tower(){
        allDiscs = new Stack<Disc>();
    }

    public Disc peek(){
        return allDiscs.peek();
    }

    public Disc getDisc(){
        return allDiscs.pop();
    }

    public void push(int DiscNumber){
        allDiscs.push(new Disc(DiscNumber));
    }

    public Stack<Disc> cloneDiscsStack(){
        return (Stack<Disc>) allDiscs.clone();
    }

    public void paint(Graphics g){
        Stack<Disc> allDiscsCopy = (Stack) allDiscs.clone();
        g.fill3DRect(getXpos(), getYpos(), getXposFinal(), getYposFinal(), true);
        
        int meanPos = (getXpos()- getXposFinal())/2;
        for(int c=1;allDiscsCopy.isEmpty();c++){
            Disc disc = allDiscs.pop();
            int half = disc.getSize()/2;
            meanPos-=half;
            g.fill3DRect(meanPos, getYposFinal()-(c*10), disc.getSize(), 10, true);
        }
    }

    public int getXpos() {
        return Xpos;
    }

    public void setXpos(int xpos) {
        this.Xpos = xpos;
    }

    public int getYpos() {
        return Ypos;
    }

    public void setYpos(int ypos) {
        this.Ypos = ypos;
    }

    public int getXposFinal() {
        return XposFinal;
    }

    public void setXposFinal(int xposFinal) {
        this.XposFinal = xposFinal;
    }

    public int getYposFinal() {
        return YposFinal;
    }

    public void setYposFinal(int yposFinal) {
        this.YposFinal = yposFinal;
    }
    
    
    

    class Disc {
        int discNumber;
                        
        
        public Disc(int discNumber){
            this.discNumber = discNumber;
        }

        public int getSize(){
            return discNumber *10;
        }

        public int getNum(){
            return discNumber;
        }
    }
}
