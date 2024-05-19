public class DeformableObject
{
  int _numNodesH;   // Number of nodes in horizontal direction
  int _numNodesV;   // Number of nodes in vertical direction

  float _sepH;      // Separation of the object's nodes in the X direction (m)
  float _sepV;      // Separation of the object's nodes in the Y direction (m)

  SpringLayout _springLayout;   // Physical layout of the springs that define the surface of each layer
  color _color;                 // Color (RGB)

  Particle[][] _nodes;                             // Particles defining the object
  ArrayList<DampedSpring> _springs;                // Springs joining the particles

  float _kd;                                      // Damping coefficient
  float _ke;                                      // Elastic coefficient
  
  DeformableObject(SpringLayout layout, color c, float Ke, float Kd)
  {
    _springLayout = layout;
    _color = c;

    _numNodesH = N_H;
    _numNodesV = N_V;

    _sepH = D_H;
    _sepV = D_V;

    _nodes = new Particle[_numNodesH][_numNodesV];
    _springs = new ArrayList<DampedSpring>();

    _kd = Kd;
    _ke = Ke;

    createDeformableObject();
    createSprings();
  }

  int getNumNodes()
  {
    return _numNodesH*_numNodesV;
  }

  int getNumSprings()
  {
    return _springs.size();
  }

  PVector calculateWindForce(PVector normal){
    
    PVector windNormalized = wind_direction.normalize();
    float windModulo = PVector.dot(normal, windNormalized);
    PVector windForce = PVector.mult(wind_direction, windModulo);

    return windForce;
  }

  PVector calculateNormal(int i, int j) {

    int counter = 0;

    PVector n = new PVector(0, 0, 0);
    PVector p = _nodes[i][j]._s;

    if (i + 1 < _numNodesH) {
      PVector p1 = _nodes[i + 1][j]._s;
      PVector v1 = PVector.sub(p1, p);
      if (j + 1 < _numNodesV) {
        PVector p2 = _nodes[i][j + 1]._s;
        PVector v2 = PVector.sub(p2, p);
        n.add(v1.cross(v2));
        counter++;
      }
    }

    if (j + 1 < _numNodesV) {
      PVector p2 = _nodes[i][j + 1]._s;
      PVector v2 = PVector.sub(p2, p);
      if (i - 1 >= 0) {
        PVector p3 = _nodes[i - 1][j]._s;
        PVector v3 = PVector.sub(p3, p);
        n.add(v2.cross(v3));
        counter++;
      }
    }

    if (i - 1 >= 0) {
      PVector p3 = _nodes[i - 1][j]._s;
      PVector v3 = PVector.sub(p3, p);
      if (j - 1 >= 0) {
        PVector p4 = _nodes[i][j - 1]._s;
        PVector v4 = PVector.sub(p4, p);
        n.add(v3.cross(v4));
        counter++;
      }
    }

    if (j - 1 >= 0) {
      PVector p4 = _nodes[i][j - 1]._s;
      PVector v4 = PVector.sub(p4, p);
      if (i + 1 < _numNodesH) {
        PVector p1 = _nodes[i + 1][j]._s;
        PVector v1 = PVector.sub(p1, p);
        n.add(v4.cross(v1));
        counter++;
      }
    }

    if (counter > 0) {
      n.div(counter);
    }

    if (n.mag() != 0) {
      n.normalize();
    }

    return n;
  }


  void createDeformableObject(){
    for(int i = 0; i < N_H; i++)
    {
      for(int j = 0; j < N_V; j++)
      {  
        if(i == 0 && j == 0 || i == 0 && j == N_V-1)
          _nodes[i][j] = new Particle(new PVector(i*_sepH, 0, j*_sepV), new PVector(0,0,0), PARTICLE_MASS, true);
        else
          _nodes[i][j] = new Particle(new PVector(i*_sepH, 0, j*_sepV), new PVector(0,0,0), PARTICLE_MASS, false);
      }
    }
  }

  void update(float simStep)
  {
    for (DampedSpring s : _springs) 
      s.update(simStep);

    for(int i = 0; i < N_H; i++)
    {
      for(int j = 0; j < N_V; j++)
      {
        if(_nodes[i][j] != null){
          PVector normal = calculateNormal(i, j);
          _nodes[i][j]._F.add(calculateWindForce(normal));
          _nodes[i][j]._F.add(gravity);
          _nodes[i][j].update(simStep);
        } 
      }
    } 
  }

  void createSprings() {
    if(_springLayout == _springLayout.STRUCTURAL){
      createStructural();
    } else if(_springLayout == _springLayout.SHEAR){
      createShear();
    } else if(_springLayout == _springLayout.BEND){
      createBend();
    } else if(_springLayout == _springLayout.STRUCTURAL_AND_SHEAR){
      createStructuralShear();
    } else if(_springLayout == _springLayout.SHEAR_AND_BEND){
      createShearBend();
    } else if(_springLayout == _springLayout.STRUCTURAL_AND_BEND){
      createStructuralBend();
    } else if(_springLayout == _springLayout.STRUCTURAL_AND_SHEAR_AND_BEND){
      createStructuralShearBend();
    }
  }

  void createStructural() {
    for (int y = 0; y < _numNodesV; y++){
      for (int x = 0; x < _numNodesH; x++) {
        if(y > 0)       
          _springs.add(new DampedSpring(_nodes[x][y-1], _nodes[x][y], _sepV, _ke, _kd));

        if(x>0)
          _springs.add(new DampedSpring(_nodes[x-1][y], _nodes[x][y], _sepH, _ke, _kd));
      }
    }
  }

  void createShear() {
    float l0 = sqrt(_sepH*_sepH + _sepV*_sepV);

    for (int y = 1; y < _numNodesV; y++){
      for (int x = 1; x < _numNodesH; x++) {
        _springs.add(new DampedSpring(_nodes[x-1][y-1], _nodes[x][y], l0, _ke, _kd));
        _springs.add(new DampedSpring(_nodes[x-1][y], _nodes[x][y-1], l0, _ke, _kd));
      }
    }
  }

  void createBend() {
    for (int y = 0; y < _numNodesV; y++){
      for (int x = 0; x < _numNodesH; x++) {

        if(x == 0 && y == 0 || x == 0 && y == N_V-1)
          _nodes[x][y].setClamped(true);

        if(y > 1)
          _springs.add(new DampedSpring(_nodes[x][y-2], _nodes[x][y], _sepV*2, _ke, _kd));
        
        if(x>1)
          _springs.add(new DampedSpring(_nodes[x-2][y], _nodes[x][y], _sepH*2, _ke, _kd));
        
      }
    }
  }

  void createStructuralShear(){
      createStructural();
      createShear();
  }

  void createShearBend(){
      createShear();
      createBend();
  }

  void createStructuralBend(){
      createStructural();
      createBend();
  }

  void createStructuralShearBend(){
      createStructural();
      createShear();
      createBend();
  }

  void render()
  {
    if (DRAW_MODE)
      renderWithSegments();
    else
      renderWithQuads();
  }

  void renderWithQuads()
  {
    int i, j;

    fill(_color);
    stroke(0);

    for (j = 0; j < _numNodesV - 1; j++)
    {
      beginShape(QUAD_STRIP);
      for (i = 0; i < _numNodesH; i++)
      {
        if ((_nodes[i][j] != null) && (_nodes[i][j+1] != null))
        {
          PVector pos1 = _nodes[i][j].getPosition();
          PVector pos2 = _nodes[i][j+1].getPosition();

          vertex(pos1.x, pos1.y, pos1.z);
          vertex(pos2.x, pos2.y, pos2.z);
        }
      }
      endShape();
    }
  }

  void renderWithSegments()
  {
    stroke(_color);

    for (DampedSpring s : _springs) 
    {
      PVector pos1 = s.getParticle1().getPosition();
      PVector pos2 = s.getParticle2().getPosition();

      line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
    }
  }

}