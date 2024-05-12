class ParticleEmitter {
  
    ArrayList<Particle> particles;
    PVector _pos;
    
    // Parametros de la simulación
    float g = 9.8;
    float k = 0.0001;
    float vx = 120;
    float vy = -200;
    float mag = 200;
    int n_chorros = 7;
    
    int _i = 0;
    float dt = 0.015;
    
    ParticleEmitter(PVector pos) {
        _pos = pos;
        particles = new ArrayList<Particle>();
    }

    /**
    * Devuelve el número de partículas en el sistema
    * @return [int] Número de partículas 
    */
    int getNumParticles() {
        return particles.size();
    }

    /**
    * Calcular la fuerza de la partícula y actualizar su aceleración
    * @param [Particle] p Partícula a la que se le aplica la fuerza
    */
    void calcForce(Particle p) {
        PVector gravity = new PVector(0, p.mass * g);
        PVector drag = p.vel.copy()
                            .normalize()
                            .mult(-k);
        PVector force = PVector.add(gravity, drag);

        p.acc.add(force.div(p.mass));
    }

    /**
    * Actualizar la posición y velocidad de la partícula
    * @param [Particle] p Partícula a actualizar
    */
    void update(Particle p){
        calcForce(p);
        p.vel.add(PVector.mult(p.acc, dt));
        p.pos.add(PVector.mult(p.vel, dt));
    }

    /**
    * Mover las partículas del sistema
    */
    void moveObject() {
        
        for (int i = particles.size() - 1; i >= 0; i--) {
            Particle p = particles.get(i);

            // Aplicar fuerzas
            update(p);

            // Eliminar particulas que salen de la pantalla
            if (p.pos.x < 0 || p.pos.x > width || p.pos.y < 0 || p.pos.y > height) {
                particles.remove(i);
            }
        }
    }
    
    /**
     * Añadir las partículas al sistema
     * 
     */
    void createNewParticles() {
        int n;
        if(n_chorros <= 0)
            n_chorros = 10;

        n = _i % n_chorros;

        float angle = -(60 + 10 * n) * PI / 180;

        PVector velocidad = PVector.fromAngle(angle).mult(mag);
        Particle newParticle = new Particle(_pos, velocidad, 0.1);
        particles.add(newParticle);
        _i++;
    }

    void resetEmitter() {
        _i = 0;
        mag = 200;
        particles.clear();
    }
}