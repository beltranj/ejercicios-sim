/**
 * @name Partícula flotante
 * @description Simulación de una partícula flotando en un fluido, dado el volumen de la partícula y la densidad del líquido.
 * @author Jordi Beltran Querol
 */

Particula p;
PVector pos_ini, vel_ini;
float masa = 20;
float radio = 10;
float dt = 0.1;

void setup(){
    size(640,320);

    pos_ini = new PVector(width/2, height/3);
    vel_ini = new PVector(0, 0);

    p = new Particula(pos_ini, vel_ini, masa, radio);
}

void draw(){
    background(#E1ECF7); 

    noStroke();
    fill(#AECBEB); // Color del agua
    rect(0, height/2, width, height);

    p.actualizar(dt);
    p.dibujar();

    drawText();
}

void drawText(){
    fill(0);
    text("Volumen de la partícula: " + p._volumen, 10, 10);
    text("Densidad del líquido: " + p._densidad, 10, 25);
    text("Masa de la partícula: " + p._m, 10, 40);
    text("Fuerza boyante: " + p.F_B, 10, 55);
    text("Fuerza resultante: " + p.F, 10, 70);
    text("Aceleración: " + p._a, 10, 85);
    text("Velocidad: " + p._v, 10, 100);
    text("Posición: " + p._s, 10, 115);
}
