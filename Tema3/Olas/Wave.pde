///////////////////////////////////////////////////////////////////////
//
// WAVE
//
///////////////////////////////////////////////////////////////////////

abstract class Wave
{
  
  protected PVector tmp;
  
  protected float A,C,W,Q,phi;
  protected PVector D;//Direction or centre
  
  public Wave(float _a,PVector _srcDir, float _L, float _C)
  {
    tmp = new PVector();
    A = _a;
    C = _C;
    W = 2*PI/_L;
    Q = PI * ((2*A)/_L) * C; // Factor Q para simular el transporte, la pendiente de la onda
    D = new PVector().add(_srcDir); // Es la dirección en el caso de las ondas direccionales y el epicentro en el caso de las radiales
    // phi = C*(_L/C);
    phi = C*W;
  }
  
  abstract PVector getVariation(float x, float y, float z, float time);
}

///////////////////////////////////////////////////////////////////////
//
// DIRECTIONAL WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveDirectional extends Wave
{
  public WaveDirectional(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    // Solo existe variación en el eje Y (vertical)
    tmp.x = 0;
    tmp.z = 0;
    
    PVector dir = D.copy();
    dir.normalize();
    
    float p_Escalar = PVector.dot(new PVector(x,y,z),dir);

    tmp.y = -A * sin(p_Escalar*W + phi * time);
    return tmp;
  }
}

///////////////////////////////////////////////////////////////////////
//
// RADIAL WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveRadial extends Wave
{
  public WaveRadial(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    // Solo existe variación en el eje Y (vertical)
    tmp.x = 0;
    tmp.z = 0;
    float d_ep = dist(x, y, D.x, D.y);
    tmp.y = -A * sin(d_ep*W + phi * time);
    return tmp;
  }
}

///////////////////////////////////////////////////////////////////////
//
// GERSTNER WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveGerstner extends Wave
{
  public WaveGerstner(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    // Recordar que Y es el eje vertical
    PVector dir = D.copy();
    dir.normalize();

    tmp.x = A * Q * D.x * cos(PVector.mult(D,W).dot(new PVector(x,y,z)) + phi * time);
    tmp.y = -A * sin(PVector.mult(D,W).dot(new PVector(x,y,z)) + phi * time);
    tmp.z = A * Q * D.y * cos(PVector.mult(D,W).dot(new PVector(x,y,z)) + phi * time);
    
    return tmp;
  }
}
