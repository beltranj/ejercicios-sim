class Particula{
    PVector _s;
    PVector _v;
    PVector _a;
    PVector F;
    float _m;
    float _r;
    float _volumen;
    float _densidad;
    float F_B;
    float F_G;

    /**
    * Constructor de la clase Particula 
    */
    Particula(PVector s, PVector v, float m, float r){
        _s = s;
        _v = v;
        _a = new PVector(0, 0);
        F = new PVector(0, 0);
        _m = m;
        _r = r;
        _densidad = 0.0005;
        _volumen = 0;
        F_B = 0;
        F_G = 9.81;
    }

    /**
    * Metodo que actualiza la posicion de la particula
    */
    void actualizar(float dt){
        calcularAceleracion();
        _v.add(PVector.mult(_a, dt));
        _s.add(PVector.mult(_v, dt));
    }

    void calcularAceleracion(){
        
        F.set(0, F_G);

        calcularVolumen();
        F_B =  _densidad * -9.81 * _volumen;
        F.add(0, F_B);
        _a = PVector.div(F, _m);
    }

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
    void dibujar(){
        fill(#71A5DE);
        ellipse(_s.x, _s.y, _r * 2, _r * 2);
    }
}