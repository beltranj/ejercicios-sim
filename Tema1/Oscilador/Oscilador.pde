/**
 * @name Oscilador
 * @description La posición de una partícula que se mueve a lo largo de una trayectoria sinusoidal.
 * @author Jordi Beltran Querol
 */

PVector initialPosition, particula;
ArrayList<PVector> particula_posiciones;
int type = 1;
float SIM_STEP = 0.01;


void setup(){
    size(800, 600);
    initialPosition = new PVector(0, height/2);
    particula = new PVector(initialPosition.x, initialPosition.y);
    particula_posiciones = new ArrayList<PVector>();
}

void draw(){
    background(#B3B7EE);
    
    drawTrajectory();
    moveParticle(type);
    displayInfo();
}

/**
    Función que mueve la partícula a lo largo de la trayectoria sinusoidal. Y la almacena en
    un vector de posiciones, para dibujar su trayectoria.
*/
void moveParticle(int type){
    fill(0);
    stroke(0);
    ellipse(particula.x, particula.y, 10, 10);
    
    particula.x += SIM_STEP;
    if(type == 1)
        particula.y = particula.y + (3*(0.5 * sin(3 * particula.x) + 0.5 * sin(3.5 * particula.x)));
    else if(type == 2)
        particula.y = particula.y + ( sin(particula.x) * exp(-0.002 * particula.x));
   
    // Añadir cada vez un nuevo PVector con la posición de la partícula, si no se sobreescribe todo el rato la misma.
    particula_posiciones.add(new PVector(particula.x, particula.y));
}

/**
    Función que dibuja la trayectoria de la partícula.
*/
void drawTrajectory(){
    noFill();
    stroke(0,0,0); // Color rojo para la trayectoria
    beginShape();
    for (PVector p : particula_posiciones) {
        vertex(p.x, p.y);
    }
    endShape();
}

void restartSimulation(){
    particula_posiciones.clear();
    particula = new PVector(initialPosition.x, initialPosition.y);
}

void keyPressed(){
    if(key == 'r' || key == 'R'){
        restartSimulation();
    }
    if(key == '1'){
        restartSimulation();
        type = 1;
    }
    if(key == '2'){
        restartSimulation();
        type = 2;
    }
    if(key == '+'){
        SIM_STEP += 0.01;
        print(SIM_STEP);
    }
    if(key == '-'){
        SIM_STEP -= 0.01;
    }

}

void displayInfo()
{
    stroke(0,0,0);
    fill(0,0,0);   
    textSize(14);
        text("Animate the particle movement of a particle at velocity v over the 2 oscillating functions", width*0.025, height*0.05);
    if (type == 1)
        text("Using function: y = 0.5sin(3x) + 0.5sin(3.5x)", width*0.025, height*0.10);
    else if (type == 2)
        text("Using function: y = sin(x) * exp(-0.002x)", width*0.025, height*0.10);
    text("Press 'r' to restart the simulation", width*0.025, height*0.15);
    text("Press '1' to use function y = 0.5sin(3x) + 0.5sin(3.5x)", width*0.025, height*0.20);
    text("Press '2' to use function y = sin(x) * exp(-0.002x)", width*0.025, height*0.25);
    text("Simulation step: " + SIM_STEP, width*0.025, height*0.40);
    text("Press '+' to increase the simulation step", width*0.025, height*0.30);
    text("Press '-' to decrease the simulation step", width*0.025, height*0.35);
}