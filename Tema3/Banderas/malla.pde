class Malla{

    int tamX, tamY;
    String Type;
    color _c;
    
    PVector[][] vertices;
    PVector[][] fuerzas;
    PVector[][] velocidades;
    PVector[][] aceleraciones;

    float m_DirectDistance = 4;
    float m_aslantDistance = sqrt(pow(m_DirectDistance,2) + pow(m_DirectDistance, 2)); // Diagonal calculada con Pitagoras

    float ke;
    float m_Damping;
    PVector vDamp = new PVector(0,0,0);

    Malla(int tamX, int tamY, String Type, color c){
        this.tamX = tamX;
        this.tamY = tamY;
        this.Type = Type;

        vertices = new PVector[tamX][tamY];
        fuerzas = new PVector[tamX][tamY];
        velocidades = new PVector[tamX][tamY];
        aceleraciones = new PVector[tamX][tamY];
        _c = c;

        // Set elastic constant and damping according to mesh type
        switch (Type) {
            case "Structured" :
                ke = 400;
                m_Damping = 3;
            break;

            case "Shear":
                ke = 300;
                m_Damping = 2;
            break;

            case "Bend":
                ke = 150;
                m_Damping = 2.0;
            break;
        }
        crearMalla();
    }

    void crearMalla(){
        // Crear malla de vertices
        for (int i = 0; i < tamX; i++){
            for (int j = 0; j < tamY; j++){
                vertices[i][j] = new PVector(i*m_DirectDistance, 0, j*m_DirectDistance);
                fuerzas[i][j] = new PVector(0, 0, 0);
                velocidades[i][j] = new PVector(0, 0, 0);
                aceleraciones[i][j] = new PVector(0, 0, 0);
            }
        }
    }

    PVector getForce(PVector v1, PVector v2,  float m_Distance, float k){
        // println("VertexPos: "+VertexPos + " i: "+i + " j: "+j + " m_Distance: "+m_Distance + " k: "+k);
        PVector force = new PVector(0.0, 0.0, 0.0);
        PVector distancia = new PVector(0.0, 0.0, 0.0);
        float elongacion = 0.0;
        
        distancia = PVector.sub(v1, v2); 
        elongacion = distancia.mag() - m_Distance;   /// s = e.mag() - l_reposo    ---> x
        distancia.normalize(); // e.normalize() = _eN
        force = PVector.mult(distancia, -k * elongacion); //cálculo de fuerza elástica  --> (_eN) * (K*s)
        
        return force;
    }

    void update(){

        actualizaFuerzas();

        for(int i = 0; i < tamX; i++){
            for(int j = 0; j < tamY; j++){
                aceleraciones[i][j].add(fuerzas[i][j].mult(dt));
                velocidades[i][j].add(aceleraciones[i][j].mult(dt));
                vertices[i][j].add(velocidades[i][j].mult(dt));

                // fijar el vertice sup y inf de la primera columna de la malla
                if((i == 0 && j == 0) || (i == 0 && j == tamY - 1)){
                    fuerzas[i][j].set(0,0,0);
                    velocidades[i][j].set(0,0,0);
                    vertices[i][j].set(i*m_DirectDistance, 0, j*m_DirectDistance);
                }
                aceleraciones[i][j].mult(0);
            }
        }
    }

    void actualizaFuerzas()
    {
        PVector vDamp = new PVector (0,0,0);
        
        for (int i = 0; i<tamX; i++)
        {
            for (int j = 0; j < tamY; j++)
            {
                fuerzas[i][j].set(0,0,0);
                
                //Fuerza externa de la gravedad
                fuerzas[i][j].add(gravity);
                
                //Fuerza externa del viento
                PVector windForce = getWindForce(vertices[i][j], i, j);
                fuerzas[i][j] = PVector.add(fuerzas[i][j], windForce);
                
                switch(Type)
                {
                case "Structured":
                    if (i > 0)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i-1][j], m_DirectDistance, ke));
                    if (i < tamX - 1)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i+1][j], m_DirectDistance, ke));
                    if (j > 0)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i][j-1], m_DirectDistance, ke));
                    if (j < tamY - 1)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i][j+1], m_DirectDistance, ke));
                break;
                
                case "Bend":
                    if (i > 1){
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i-1][j], m_DirectDistance, ke));
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i-2][j], m_DirectDistance*2, ke));
                    }
                    if (i < tamX - 2){
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i+1][j], m_DirectDistance, ke));
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i+2][j], m_DirectDistance*2, ke));
                    }
                    if (j > 1){
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i][j-1], m_DirectDistance, ke));
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i][j-2], m_DirectDistance*2, ke));
                    }
                    if (j < tamY - 2){
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i][j+1], m_DirectDistance, ke));
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i][j+2], m_DirectDistance*2, ke));
                    }
                break;
                
                case "Shear":
                    if (i > 0)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i-1][j], m_DirectDistance, ke));
                    if (i < tamX - 1)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i+1][j], m_DirectDistance, ke));
                    if (j > 0)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i][j-1], m_DirectDistance, ke));
                    if (j < tamY - 1)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i][j+1], m_DirectDistance, ke));

                    if (i > 0 && j > 0)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i-1][j-1], m_aslantDistance, ke));
                    if (i > 0 && j < tamY - 1)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i-1][j+1], m_aslantDistance, ke));
                    if (i < tamX - 1 && j > 0)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i+1][j-1], m_aslantDistance, ke));
                    if (i < tamX - 1 && j < tamY - 1)
                        fuerzas[i][j] = PVector.add(fuerzas[i][j], getForce(vertices[i][j], vertices[i+1][j+1], m_aslantDistance, ke));
                break;
                }
                
                //Fuerza damping = -v*kr --> fuerza de amortiguamiento
                vDamp.set(velocidades[i][j].x, velocidades[i][j].y, velocidades[i][j].z);
                vDamp.mult(-m_Damping);
                
                fuerzas[i][j] = PVector.add(fuerzas[i][j], vDamp);
            }
        }
    }

    PVector getWindForce(PVector v, int i, int j){
        PVector windForce = new PVector(0,0,0);

        PVector n1 = getVectorNormal(v, i-1, j, i, j-1);
        PVector n2 = getVectorNormal(v, i-1, j, i, j+1);
        PVector n3 = getVectorNormal(v, i, j+1, i+1, j);
        PVector n4 = getVectorNormal(v, i+1, j, i, j-1);

        int cont = 0;

        if(n1.mag() > 0)
            cont++;

        if(n2.mag() > 0)
            cont++;

        if(n3.mag() > 0)
            cont++;

        if(n4.mag() > 0)
            cont++;

        PVector n = PVector.add(n1, n2);
        n.add(n3);
        n.add(n4);
        n.div(cont);
        n.normalize();

        float kViento = PVector.dot(n, wind);

        windForce = PVector.mult(n, kViento);
        // println("windForce: "+windForce);

        return windForce;
    }

    PVector getVectorNormal(PVector v, int a, int b, int c, int d) {
        PVector n = new PVector(0, 0, 0);
        if (a >= 0 && a <= tamX - 1 && b >= 0 && b <= tamY - 1 && c >= 0 && c <= tamX - 1 && d >= 0 && d <= tamY - 1) {
            PVector v1 = PVector.sub(vertices[a][b], v);
            PVector v2 = PVector.sub(vertices[c][d], v);
            n = v1.cross(v2);
        }
        return n;
    }

    void display(){
        fill(_c);
        stroke(0);
        for(int i = 0; i < tamX-1; i++){
            beginShape(QUAD_STRIP);
            for(int j = 0; j < tamY; j++){
                PVector p1 = vertices[i][j];
                PVector p2 = vertices[i+1][j];
                vertex(p1.x, p1.y, p1.z);
                vertex(p2.x, p2.y, p2.z);
            }
            endShape();
        }
    }

    
}