/**
 * @name Bubble Shooter (disparo de particulas)
 * @description Disparo de particulas con el mouse
 * @author Jordi Beltran Querol
 */
 
PVector vecInicio, vecFinal, vecDireccion;
ArrayList<Particula> particulas;
float dt = 0.1;

void setup(){
    size(400, 300);
    vecInicio = new PVector(width/2, height-20);
    vecFinal = new PVector();
    particulas = new ArrayList<Particula>();
}

void draw(){
    background(#B5E2FA);
    drawText();

    // Muestra la posición inicial del disparo
    stroke(0);
    fill(#0FA3B1);
    ellipse(vecInicio.x, vecInicio.y, 10, 10);

    // Dibuja la línea que indica la dirección del disparo
    mouseHover();

    // Muestra las particulas en pantalla
    for(Particula p : particulas){
        p.mover();
        p.mostrar();
    }
}

/**
* Función que dibuja una línea desde la posición inicial hasta´
* la posición del mouse indicando la dirección de disparo
* @return void
*/
void mouseHover(){
    vecFinal = new PVector(mouseX, mouseY);
    fill(#F7A072);
    ellipse(vecFinal.x, vecFinal.y, 10, 10);

    stroke(0);
    line(vecInicio.x, vecInicio.y, vecFinal.x, vecFinal.y);
}

/**
 * Función que calcula la velocidad de la partícula en función de la dirección
 * @return PVector vecDireccion
 */
PVector calcularVelocidad(){
    PVector vecDireccion = PVector.sub(vecFinal, vecInicio);
    vecDireccion.normalize();
    vecDireccion.mult(100);
    return vecDireccion;
}


/**
 * Función que tras un click del mouse, lanza una nueva partícula.
 * @return void
 */
void mousePressed(){
    vecDireccion = calcularVelocidad();
    Particula p = new Particula(vecInicio, vecDireccion);
    particulas.add(p);
}

void drawText(){
    fill(0);
    text("Haz click con el mouse para disparar particulas :)", 10, 20);
}
