/**
 * @name Splash
 * @description Simulación de una partícula que al caer en un líquido realiza un splash
 * @author Jordi Beltran Querol
 */

PVector _s, _v, _a, F;
ParticleSystem ps;

float _densidad = 0.001;
float _volumen = 0;
float _m = 5;
float _r = 10;
float TS = 0.001;
float Kd = 0.5;

final float min_velocity_x = -20;      // Minima velocidad de las partículas producidas por el Splash (m/s)
final float max_velocity_x = 20;       // Maximum velocidad de las partículas producidas por el Splash (m/s)
final float min_velocity_y = -60;      // Minimum velocidad de las partículas producidas por el Splash (m/s)
final float max_velocity_y = -0;       // Maximum velocidad de las partículas producidas por el Splash (m/s)

float N_PARTICULAS = 20;
float F_B = 0;

boolean splashRealizado = false; // Variable para controlar si ya se realizó el splash

void setup(){
    size(640,320);
    // Inicializamos la posición, velocidad y aceleración de la particula flotante
    _s = new PVector(width/2, height/2 - 100);
    _v = new PVector(0, 0);
    _a = new PVector(0, 0);
    F = new PVector(0, 0);
    ps = new ParticleSystem(new PVector(width/2, height/2));
}

void draw(){
    background(#E1ECF7); 

    // Actualizar la posición, velocidad y aceleración de la particula flotante y dibujarla
    actualizar();
    dibujarParticula();

    // Dibujar la superficie del agua
    noStroke();
    fill(#AECBEB, 127); // Color del agua
    rect(0, height/2, width, height);

    // Si la particula cae en la superficie y el splash no se ha realizado aún
    if(_s.y + _r > height/2 && _s.y - _r < height/2 && !splashRealizado){
        // Realizar splash
        for(int i = 0; i < N_PARTICULAS; i++){
            PVector v_p = new PVector(random(min_velocity_x, max_velocity_x), random(min_velocity_y, max_velocity_y));
            ps.addParticle(_m/5, new PVector(0,0), v_p, 5, #AECBEB, 30); // Lifespan of the particles is 500 frames
        }
        splashRealizado = true; // Establecer el flag a true para indicar que el splash ya se ha realizado
    }
    
    ps.render();
    ps.update(TS);
    TS += 0.001;
    drawText();
}

/**
* Metodo que actualiza la posición, velocidad y aceleración de la particula flotante
* utilizando Euler Simplectico
*/
void actualizar(){
    calcularAceleracion();
    _v.add(PVector.mult(_a, TS));
    _s.add(PVector.mult(_v, TS));
}

/**
* Metodo que calcula la aceleración de la particula flotante
*/
void calcularAceleracion(){
    F.set(0, 9.81);

    calcularVolumen();
    F_B =  _densidad * -9.81 * _volumen;
    F.add(0, F_B);

    // Se añade una fuerza de rozamiento para frenar la particula flotante
    float F_Roz = - Kd * _v.y;
    F.add(0, F_Roz);
    _a = PVector.div(F, _m);
}

/**
* Metodo que calcula el volumen de la particula flotante
* según si esta completamente sumergida o parcialmente sumergida
*/
void calcularVolumen(){
    // Si la particula esta completamente sumergida
    if(_s.y - _r >= height/2){
        _volumen = 4 * PI * _r * _r * _r / 3;
    }
    // Si la partícula esta parcialmente sumergida
    else if(_s.y + _r > height/2){
        float h = _s.y + _r - height/2;
        float a = sqrt(2 * h * _r - h * h);
        _volumen = (3 * a*a + h*h) * PI * h / 6;
    }
}

/**
* Metodo que dibuja la particula
*/
void dibujarParticula(){
    fill(#EF6F6C);
    ellipse(_s.x, _s.y, _r * 2, _r * 2);
}

void drawText(){
    fill(0);
    text("Volumen de la partícula: " + _volumen, 10, 10);
    text("Densidad del líquido: " + _densidad, 10, 25);
    text("Masa de la partícula: " + _m, 10, 40);
    text("Fuerza boyante: " + F_B, 10, 55);
    text("Fuerza resultante: " + F, 10, 70);
    text("Aceleración: " + _a, 10, 85);
    text("Velocidad: " + _v, 10, 100);
    text("Posición: " + _s, 10, 115);
}