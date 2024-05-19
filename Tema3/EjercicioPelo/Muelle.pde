class Muelle
{
  Extremo a;
  Extremo b;
  
  PVector fA, fB;
  
  float longitud_muelle; // Longitud que tendrá el muelle
  float l0;
  float ke = 30;
  float kd = 10;
  
  Muelle (Extremo a_, Extremo b_, float l)
  {
    a = a_;
    b = b_;
    longitud_muelle = l;
    l0 = l;
    fA = new PVector(0,0);
    fB = new PVector(0,0);
  }

  void update()
  {
    PVector d = PVector.sub(b._s, a._s);
    longitud_muelle = d.mag();
    float elongacion = longitud_muelle - l0;
    d.normalize();

    fA = PVector.mult(d, ke * elongacion).sub(PVector.mult(PVector.sub(a._v, b._v), kd)); 
    fB = fA.copy().mult(-1);

    PVector f_peso = PVector.mult(GRAVITY, M);

    fB.add(f_peso);

    a.applyForce(fA);
    b.applyForce(fB);
  }
  
  void display()
  {
    strokeWeight(2);
    stroke(0);
    line(a._s.x, a._s.y, b._s.x, b._s.y);
  }
}
