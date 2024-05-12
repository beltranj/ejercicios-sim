/**
 * @name Movimiento Circular
 * @description Simulación de un movimiento circular uniforme
 * @author Jordi Beltran
 */

// Declaración de variables
float tiempo, T, w, radio;
PVector c, p;

void setup(){

  size(600,600);
  
  // Radio del círculo
  radio = 150;
  
  // Posición inicial de la partícula
  c = new PVector(width/2, height/2);
  p = new PVector(c.x + radio, c.y);
  
  // Cálculo de la velocidad angular
  T = 1; // Periodo
  w = TWO_PI / T; // Velocidad angular

  tiempo = millis() / 1000.0; // Tiempo en segundos
}

void draw(){
  background(#7C9885);
  drawText();
  
  if(keyPressed){
    if(key == '+'){
      T += 1;
      w = TWO_PI / T;
    }
    if(key == '-'){
      T -= 1;
      w = TWO_PI / T;
    }
    if(key == 'r' || key == 'R'){
      resetSimulation();
    }
  }

  // Lineas que dividen el canvas
  line(0,width/2,height,width/2);
  line(height/2,0,height/2,width);
  
  // Centro del circulo
  fill(#033F63);
  ellipse(c.x,c.y,10,10);

  // Dibujar trayectoria circular
  stroke(#28666E); // Color de la trayectoria
  strokeWeight(2); // Grosor del borde
  noFill();
  ellipse(width/2, height/2, 2*radio, 2*radio);
  
  // Calcular las coordenadas x y y de la partícula utilizando funciones trigonométricas
  tiempo = millis() / 1000.0; // Tiempo en segundos
  p.x = width/2 + radio * cos(w * tiempo); // Coordenada x
  p.y = height/2 + radio * sin(w * tiempo); // Coordenada y
  
  // Dibujar la partícula
  fill(#28666E); // Color azul
  ellipse(p.x, p.y, 25, 25); // Dibujar partícula

  // Dibujar la línea que conecta el centro del círculo con la partícula
  stroke(#033F63); // Color
  strokeWeight(1);
  line(c.x, c.y, p.x, p.y); // Dibujar línea
}

void drawText(){
  fill(255);
  textSize(14);
  text("Movimiento Circular", 10, 20);
  text("Radio: " + radio, 10, 40);
  text("Velocidad Angular: " + w, 10, 60);
  text("Periodo: " + T, 10, 80);
  text("Tiempo: " + tiempo, 10, 100);
  text("Pulse [+][-] para aumentar o disminuir el periodo, [R] para reiniciar la simulación", 10, 120);
}

void resetSimulation(){
  T = 1;
  w = TWO_PI / T;
}