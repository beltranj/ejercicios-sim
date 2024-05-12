class Coche {
  
    float m;                          // Masa del coche en kg
    PVector _s;                       // Posición del coche en m
    PVector _v;                       // Velocidad del coche en m/s
    PVector _a;                       // Aceleración del coche en m/s^2
    float energiaCinetica;            // Energía cinética del coche en J
    float coeficienteRozamiento;      // Coeficiente de rozamiento
    ArrayList<PVector> velocidades;   // Vector de velocidades para realizar la gráfica
  
    /**
    * Constructor de la clase Coche 
    */
    Coche(float masa, PVector posicionInicial, PVector velocidadInicial) {
        m = masa;
        _s = posicionInicial.copy();
        _v = velocidadInicial.copy();
        _a = new PVector(0, 0);
        energiaCinetica = 0;
        coeficienteRozamiento = 0.0001;
        velocidades = new ArrayList<PVector>();
    }
    
    /**
    * Aplicar una potencia al coche
    * @param potencia Potencia aplicada en W
    * @param dt Paso de tiempo en s
    */
    void aplicarPotencia(float potencia, float dt) {
        
        energiaCinetica = potencia * dt; // Cambio de energía cinética en J

        // Calcular el cambio de velocidad
        float deltaVelocidad = sqrt(2 * energiaCinetica / m); // Cambio de velocidad en m/s
    
        // Actualizar la velocidad
        _v.x += deltaVelocidad;
    }
    
    /**
    * Actualizar la velocidad del coche
    * @param dt Paso de tiempo en s
    */
    void actualizarVelocidad(float dt) {
        // Guardar la velocidad para la gráfica
        velocidades.add(_v.copy());

        // Calcular la fuerza de rozamiento
        float fuerzaRozamiento = -coeficienteRozamiento * _v.magSq() * _v.magSq();
        
        // Calcular la aceleración
        _a = PVector.div(_v.copy().normalize().mult(fuerzaRozamiento), m);
        
        // Actualizar la velocidad
        _v.add(PVector.mult(_a, dt));
    }
    
    /**
    * Actualizar la posición del coche
    * @param dt Paso de tiempo en s
    */
    void actualizarPosicion(float dt) {
        // Calcular el cambio de posición
        PVector deltaPosicion = _v.copy().mult(dt);
        
        // Actualizar la posición
        _s.add(deltaPosicion);
    }
    
    /**
    * Dibujar el coche
    */
    void dibujarCoche() {
        noStroke();
        fill(#D64933);
        rect(_s.x, _s.y, 50, 30);
    }
}