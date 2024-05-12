/**
 * @name Montaña rusa
 * @description Simular el movimiento de una partícula en distintos tramos de velocidad constante
 * @author Jordi Beltran Querol
 */
float dt = 1;

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
  velAB.mult(2);
  
  velBC = PVector.sub(c,b);
  velBC.normalize();
  velBC.mult(5);
  
  velCD = PVector.sub(d,c);
  velCD.normalize();
  velCD.mult(2);

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
      p.add(velAB);
  }
  else if(p.x < c.x && p.y <= c.y){
      // Velocidad
      p.add(velBC);
      
  }
  else if(p.x < d.x && p.y > d.y){
      // Velocidad
      p.add(velCD);
  }
}

void drawText(){
  fill(0);
  text("Velocidad AB: " + velAB.mag(), 10, height - 80);
  text("Velocidad BC: " + velBC.mag(), 10, height - 60);
  text("Velocidad CD: " + velCD.mag(), 10, height - 40);
  text("Presiona [R] para reiniciar la simulación", 10, height - 20);
}

void resetSimulation(){
  p = new PVector(a.x,a.y);
}