class HeightMap
{
  private final int mapSize;
  private final float cellSize;
  
  private float initPos[][][];
  private float pos[][][];
  private float tex[][][];
  protected ArrayList<Wave> waves;
  private Wave waveArray[];
  
  public HeightMap(int mapSize, float cellSize)
  {
    this.mapSize = mapSize;
    this.cellSize = cellSize;
    initGridPositions();
    initTextValues();
    waves = new ArrayList<Wave>();
    waveArray = new Wave[0];
  }
  
  private void initGridPositions()
  {
    float startPos = -mapSize*cellSize/2f;
    pos = new float[mapSize][mapSize][3];
    initPos = new float[mapSize][mapSize][3];
    for(int i = 0; i < mapSize; i++)
    {
      for(int j = 0; j < mapSize; j++)
      {
        pos[i][j][0] = startPos + j * cellSize;//X
        pos[i][j][1] = 0;//Y
        pos[i][j][2] = startPos + i * cellSize;//Z
        
        initPos[i][j][0] = pos[i][j][0];
        initPos[i][j][1] = pos[i][j][1];
        initPos[i][j][2] = pos[i][j][2];
      }
    }
  }
  
  private void initTextValues()
  {
    tex = new float[mapSize][mapSize][2];
    float mapSizeCasted = (float)mapSize;
    int i, j;
    for(i = 0; i < mapSize; i++)
    {
      for(j = 0; j < mapSize; j++)
      {
        tex[i][j][0] = j/mapSizeCasted*img.width;
        tex[i][j][1] = i/mapSizeCasted*img.height;
      }
    }
  }
  
  public void update()
  {
    //Pass arraylist to array to iterate quicker
    waveArray = waves.toArray(waveArray);
    //Declarations
    int i, j, k, len = waveArray.length;
    PVector variation;
    float time = millis()/1000f;
    //Iterate over arrays
    for(i = 0; i < mapSize; i++)
    {
      for(j = 0; j < mapSize; j++)
      {
        //Reset positions
        pos[i][j][0] = initPos[i][j][0];
        pos[i][j][1] = initPos[i][j][1];
        pos[i][j][2] = initPos[i][j][2];
        //Iterate through waves
        for(k = 0; k < len; k++)
        {
          variation = waveArray[k].getVariation(pos[i][j][0],pos[i][j][1],pos[i][j][2],time);
          pos[i][j][0] += variation.x;
          pos[i][j][1] += variation.y;
          pos[i][j][2] += variation.z;
        }
      }
    }
  }
  
  public void present()
  {
    noStroke();
    fill(0xffffffff);
    beginShape(TRIANGLES);
    texture(img);
    for(int i = 0; i < mapSize-1; i++)
    {
      for(int j = 0; j < mapSize-1; j++)
      {
        vertex(pos[i][j][0], pos[i][j][1], pos[i][j][2]              ,tex[i][j][0],tex[i][j][1]);
        vertex(pos[i+1][j][0], pos[i+1][j][1], pos[i+1][j][2]        ,tex[i+1][j][0],tex[i+1][j][1]);
        vertex(pos[i+1][j+1][0], pos[i+1][j+1][1], pos[i+1][j+1][2]  ,tex[i+1][j+1][0],tex[i+1][j+1][1]);
        
        vertex(pos[i][j][0], pos[i][j][1], pos[i][j][2]              ,tex[i][j][0],tex[i][j][1]);
        vertex(pos[i+1][j+1][0], pos[i+1][j+1][1], pos[i+1][j+1][2]  ,tex[i+1][j+1][0],tex[i+1][j+1][1]);
        vertex(pos[i][j+1][0], pos[i][j+1][1], pos[i][j+1][2]        ,tex[i][j+1][0],tex[i][j+1][1]);
      }
    }
    endShape();
  }
  
  public void presentWired()
  {
    stroke(0xff000000);
    noFill();
    beginShape(TRIANGLES);
    for(int i = 0; i < mapSize-1; i++)
    {
      for(int j = 0; j < mapSize-1; j++)
      {
        vertex(pos[i][j][0], pos[i][j][1], pos[i][j][2]              ,tex[i][j][0],tex[i][j][1]);
        vertex(pos[i+1][j][0], pos[i+1][j][1], pos[i+1][j][2]        ,tex[i+1][j][0],tex[i+1][j][1]);
        vertex(pos[i+1][j+1][0], pos[i+1][j+1][1], pos[i+1][j+1][2]  ,tex[i+1][j+1][0],tex[i+1][j+1][1]);
        
        vertex(pos[i][j][0], pos[i][j][1], pos[i][j][2]              ,tex[i][j][0],tex[i][j][1]);
        vertex(pos[i+1][j+1][0], pos[i+1][j+1][1], pos[i+1][j+1][2]  ,tex[i+1][j+1][0],tex[i+1][j+1][1]);
        vertex(pos[i][j+1][0], pos[i][j+1][1], pos[i][j+1][2]        ,tex[i][j+1][0],tex[i][j+1][1]);
      }
    }
    endShape();
  }
  
  public void addWave(Wave wave)
  {
    waves.add(wave);
  }

  public boolean isColliding(Ball b){
    // Supposing the collision point is always (0,0,0)
    dist = b.getPosition().dist(new PVector(0,0,0));
    if (dist - b.getRadius() < 0){
      return true;
    }
    return false;
  }

  // public void ballCollision(Ball b){

  //   float amplitude = random(2f)+8f;
  //   float dx = random(2f)-1;
  //   float dz = random(2f)-1;
  //   float wavelength = amplitude * (30 + random(2f));
  //   float speed = wavelength / (1+random(3f));

  //   if(isColliding(b)){
  //     b._v = b._v.mult(-1);
  //     addWave(new WaveRadial(amplitude,new PVector(dx*(_MAP_SIZE*_MAP_CELL_SIZE/2f),0,dz*(_MAP_SIZE*_MAP_CELL_SIZE/2f)),wavelength,speed));//amplitude,direction,wavelength,speed
  //   }
  // }

  void updateCollisionForce(Ball b){

      float amplitude = random(2f)+8f;
    float dx = random(2f)-1;
    float dz = random(2f)-1;
    float wavelength = amplitude * (30 + random(2f));
    float speed = wavelength / (1+random(3f));

      float incX = dist - L0_ball;

      if(incX < 0.0) 
         incX = -incX;

      float Fe = Ke_ball * incX;
      // Fuerza de rozamiento
      PVector Fd = PVector.mult(b._v, 0.0001);

      PVector dist = PVector.sub(new PVector(0,0,0), b.getPosition());
      dist.normalize();

      PVector Fm = PVector.mult(dist, Fe);
      b._F.add(Fm);
      b._F.add(Fd);
      b._v = b._v.mult(-1);
      b.addExternalForce(PVector.mult(Fm, -1));
      addWave(new WaveRadial(amplitude,new PVector(dx*(_MAP_SIZE*_MAP_CELL_SIZE/2f),0,dz*(_MAP_SIZE*_MAP_CELL_SIZE/2f)),wavelength,speed));//amplitude,direction,wavelength,speed
    
  }

    void updateBall(float simStep, Ball b)
    {
      b.updateWeightForce();

      if(b!=null){
         if(isColliding(b))
            updateCollisionForce(b);
      }
      // if(b!=null){
      //    if(checkCollision(b))
            // updateCollisionForce(b);
      // }
      // Simplectic Euler:
      // v(t+h) = v(t) + h*a(s(t),v(t))
      // s(t+h) = s(t) + h*v(t+h)

      b._a = PVector.div(b._F, b._m);
      b._v.add(PVector.mult(b._a, simStep));
      b._s.add(PVector.mult(b._v, simStep));
      b._F.set(0.0, 0.0, 0.0);
   }


  

}
