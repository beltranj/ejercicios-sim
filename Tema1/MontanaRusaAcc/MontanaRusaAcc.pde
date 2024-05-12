/**
 * @name Montaña rusa
 * @description Simular el movimiento de una partícula en distintos tramos de velocidad con aceleración constante
 * @author Jordi Beltran Querol
 */

float dt = 0.1;

// Posiciones clave de la trayectoria
PVector a, b, c, d;

// Particula
PVector p;

// Velocidades de la particula por tramos
PVector velAB, velBC, velCD;
PVector accAB , accBC, accCD;

void setup(){
  // Tamaño del lienzo
  size(800,600);

  // Inicialización de las posiciones
  a = new PVector(0, height/2);
  b = new PVector(a.x + 200, a.y - 250);
  c = new PVector(a.x + 400, a.y);
  d = new PVector(800, a.y - 250);

  // Inicialización de la particula en la posición inicial
  p = new PVector(a.x,a.y);
  
  // Calculo de las velocidades
  velAB = PVector.sub(b,a);
  velAB.normalize();
  
  velBC = PVector.sub(c,b);
  velBC.normalize();
  
  velCD = PVector.sub(d,c);
  velCD.normalize();

  // Calculo de las aceleraciones
  accAB = PVector.mult(velAB, dt);
  accBC = PVector.mult(velBC, dt);
  accCD = PVector.mult(velCD, dt);

}

void draw(){
  background(#F2EFEA);
  drawText();

  if(keyPressed){
    if(key == 'r' || key == 'R'){
      resetSimulation();
    }
  }

  // Posición A
  fill(#694873);
  ellipse(a.x, a.y, 20, 20);
   
  // Posición B
  fill(#889596);
  ellipse(b.x, b.y, 20, 20);
   
  // Posición C
  fill(#694873);
  ellipse(c.x, c.y, 20, 20);
  
  // Posición D
  fill(#889596);
  ellipse(d.x, d.y, 20, 20);
  
  // Lineas que unen las posiciones
  line(a.x, a.y, b.x, b.y);
  line(b.x, b.y, c.x, c.y);
  line(c.x, c.y, d.x, d.y);
  
  // Particula p (movimiento uniformemente acelerado)
  fill(#85B79D);
  ellipse(p.x, p.y, 30, 30);
  
  // Actualización de la posición de la partícula
  if(p.x < b.x && p.y > b.y){
      // Velocidad
      velAB.add(accAB);
      p.add(velAB);
  }
  else if(p.x < c.x && p.y <= c.y){
      // Velocidad
      velBC.add(accBC);
      p.add(velBC);
      
  }
  else if(p.x < d.x && p.y > d.y){
      // Velocidad
      velCD.add(accCD);
      p.add(velCD);
  }
}

void drawText(){
  fill(0);
  text("Velocidad AB: " + velAB.mag(), 10, height - 80);
  text("Velocidad BC: " + velBC.mag(), 10, height - 60);
  text("Velocidad CD: " + velCD.mag(), 10, height - 40);
  text("Aceleración AB: " + accAB.mag(), 10, height - 100);
  text("Aceleración BC: " + accBC.mag(), 10, height - 120);
  text("Aceleración CD: " + accCD.mag(), 10, height - 140);
  text("Presiona [R] para reiniciar la simulación", 10, height - 20);
}

void resetSimulation(){
  p = new PVector(a.x,a.y);
  velAB = new PVector(0,0);
  velBC = new PVector(0,0);
  velCD = new PVector(0,0);
}
