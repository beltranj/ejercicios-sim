/**
 * @name Plano inclinado
 * @description Simulación de una bola sobre un plano inclinado
 * @author Jordi Beltran Querol
 */

float angle = radians(30);    // Ángulo de inclinación del plano
float mass = 10;              // Masa de la bola
float radius = 5;             // Radio de la bola
float kd = 0.0001;            // Coeficiente de fricción
float G = 9.81;               // Aceleración debido a la gravedad
float dt = 0.1;               // Intervalo de tiempo

PVector _Fpeso, _Ffriccion, _F_N;
PVector _s, _v, _a, _F;
PVector p1, p2;

void setup() {
  size(640, 320);
  background(255);
  p1 = new PVector(-width, height/2);
  p2 = new PVector(2*width, height/2);
  _s = new PVector(0, height/2);
  _v = new PVector(0, 0);
  _a = new PVector(0, 0);
  _F = new PVector(0, 0);
  _Fpeso = new PVector(0, 0);
  _Ffriccion = new PVector(0, 0);
  _F_N = new PVector(0, 0);
}

void draw() {
  background(255);
  
  drawText();
  dibujarPlano();

  if (keyPressed) {
    if (key == 'r' || key == 'R') {
      resetSimulation();
    }
    if (key == '+') {
      angle += radians(1);
      resetSimulation();
    }
    if (key == '-') {
      angle -= radians(1);
      resetSimulation();
    }
  }

  actualizar();

  // Dibujar la bola
  PVector _s_rot = _s.copy();
  _s_rot.rotate(angle);

  fill(#C5283D);

  pushMatrix(); // Guarda el sistema de coordenadas actual
    translate(_s_rot.x, _s_rot.y); // Mueve el origen al centro del rectángulo
    rotate(angle); // Rota
    rect(0, 0, -50, -20); // Dibuja el rectángulo con el origen en su centro
  popMatrix(); // Restaura el sistema de coordenadas original
}

/**
* Función que calcula la aceleración de la caja sobre el plano inclinado
*/
void calcularAceleracion() {
  // Calcular la aceleración de la bola
  _Fpeso = new PVector(mass * G * sin(angle), + mass * G * cos(angle)); // Fuerza de peso
  _Ffriccion = new PVector(-kd * _v.x, -kd * _v.y); // Fuerza de fricción
  _F_N = new PVector(0, - mass * G * cos(angle)); // Fuerza normal

  _F = PVector.add(_Fpeso, _F_N);
  _F.add(_Ffriccion);
  _a = PVector.div(_F, mass);
}

/**
* Función que actualiza la posición de la caja
*/
void actualizar() {
  calcularAceleracion();
  _v.add(PVector.mult(_a, dt));
  _s.add(PVector.mult(_v, dt));
}

/**
* Función que dibuja el plano inclinado como una linea
*/
void dibujarPlano() {
  // Dibujar el plano inclinado
  PVector p1_rot = p1.copy();
  PVector p2_rot = p2.copy();
  p1_rot.rotate(angle);
  p2_rot.rotate(angle);
  stroke(0);
  line(p1_rot.x, p1_rot.y, p2_rot.x, p2_rot.y);
}

/**
* Reinicia la simulación
*/
void resetSimulation() {
  _s = new PVector(0, height/2);
  _v = new PVector(0, 0);
  _a = new PVector(0, 0);
}

void drawText() {
  fill(0);
  text("Ángulo: " + degrees(angle), 10, 20);
  text("Fuerza de peso:" + _Fpeso, 10, 40);
  text("Fuerza de fricción:" + _Ffriccion, 10, 50);
  text("Fuerza normal: " + _F_N , 10, 60);
  text("Fuerza resultante: " + _F, 10, 70);
  text("Aceleración: " + _a, 10, 90);
  text("Velocidad: " + _v, 10, 110);
  text("Pulse [R] para reiniciar la simulación, [+] para incrementar el ángulo del plano, [-] para decrementarlo", 10, 130);
}