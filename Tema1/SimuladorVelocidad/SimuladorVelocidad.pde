/**
 * @name Simulador de coche (rudimentario)
 * @description Simular un coche que acelera al presionar la tecla espaciadora 
 * y obtener su gráfica de velocidad
 * @author Jordi Beltran Querol
 */

Coche coche;
float dt = 0.1;
PVector posicionInicial;
PVector velocidadInicial;
float potencia = 1000;

void setup() {
  size(800, 600);
  posicionInicial = new PVector(0, height / 2);
  velocidadInicial = new PVector(0, 0);
  coche = new Coche(1000, posicionInicial, velocidadInicial);
}

void draw() {
    background(#92DCE5);

    // Detectar si hemos llegado al borde derecho de la pantalla
    if(coche._s.x >= width)
      coche._s.x = 0;

    // Aplicar potencia al coche al presionar la tecla espaciadora
    if (keyPressed && key == ' ')
      coche.aplicarPotencia(potencia, dt); // Se

    if(keyPressed && keyCode == UP)
      potencia += 100;

    if(keyPressed && keyCode == DOWN)
      potencia -= 100;

    if(potencia < 0)
      potencia = 0;

    if(keyPressed && key == '+')
      coche.coeficienteRozamiento += 0.0001;

    if(keyPressed && key == '-')
      coche.coeficienteRozamiento -= 0.0001;

    if(keyPressed && key == 'r' || key == 'R'){
      coche._s.x = 0;
      coche._v.x = 0;
      coche._a.x = 0;
      coche.velocidades.clear();
    }

    // Actualizar la velocidad del coche
    coche.actualizarVelocidad(dt);
    
    // Actualizar la posición del coche
    coche.actualizarPosicion(dt);
    
    // Dibujar el coche
    coche.dibujarCoche();

    // Dibujado de información de la simulación y la gráfica de la velocidad
    informacionSimulacion();

    fill(#7C7C7C);
    noStroke();
    rect(posicionInicial.x, posicionInicial.y + 30, width, height);
    
    graficaVelocidad();
}

void graficaVelocidad() {
  // Dibujar la gráfica de la velocidad
  stroke(0);
  fill(0);
  strokeWeight(2);
  text("Gráfica de velocidad", 30, 2*height / 3);

  // Dibujar la gráfica de la velocidad
  for (int i = 0; i < coche.velocidades.size(); i ++) { // Incremento de 2 en lugar de 1
    PVector velocidad = coche.velocidades.get(i);
    float x = i + 30;
    float y = 20 + velocidad.mag() + 2* height / 3;
    point(x, y);
    
    // Detectar si hemos llegado al borde derecho de la pantalla
    if (x >= width - 30) {
      coche.velocidades.clear(); // Limpiar la lista de velocidades
      break; // Salir del bucle
    }
  }
}

void informacionSimulacion() {
  // Dibujar la información de la simulación
  fill(0);
  text("Simulación de un coche. Presionar tecla SPACE para acelerar, tecla R para reiniciar la simulación, teclas ARROW UP/DOWN para modificar la potencia,", 30, 20);
  text("teclas +/- para modificar la fuerza de rozamiento y ESC para finalizar la ejecución", 30, 40);
  text("Posición: " + coche._s, 30, 60);
  text("Velocidad: " + coche._v, 30, 80);
  text("Aceleración: " + coche._a, 30, 100);
  text("Potencia: " + potencia, 30, 120);
  text("Fuerza de rozamiento: " + coche.coeficienteRozamiento, 30, 140);
}