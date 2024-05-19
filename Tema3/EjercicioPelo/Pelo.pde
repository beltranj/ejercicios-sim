class Pelo
{
  PVector _s_ini;                                  // Vector que almacena el punto de inicio del pelo
  float long_p;                                    // Longitud del pelo
  int nm;                                          // Número de muelles
  float longitud_muelle;                           // Longitud que tiene el muelle
  
  Muelle[] vMuelles = new Muelle[NMUELLES];        // Vector que almacena los muelles que forman el pelo
  Extremo[] vExtremos = new Extremo[NMUELLES+1];   // Vector que almacena los extremos que forman los muelles
  
  Pelo (PVector pos_ini)
  {
    _s_ini = pos_ini;
    
    long_p = LONGITUD_PELO;
    nm = NMUELLES;
    longitud_muelle = long_p/nm;
    
    for(int i = 0; i < vExtremos.length; i++)
      vExtremos[i] = new Extremo (pos_ini.x + i * longitud_muelle, pos_ini.y);
    
    for (int i = 0; i < vMuelles.length; i++)
      vMuelles[i] = new Muelle(vExtremos[i], vExtremos[i+1], longitud_muelle); //inicialización de los muelles que unen los extremos
  }
  
  void update()
  {
    for (Muelle m: vMuelles)
    {
      m.update();
      m.display();
    }
    
    for (int i = 1; i < vExtremos.length; i++)
    {
      vExtremos[i].update(simStep);
      vExtremos[i].display();
    }
  }

  void mousePressed()
  {
    for (int i = 1; i < vExtremos.length; i++)
      vExtremos[i].mousePressed();
  }

  void mouseDragged()
  {
    for (int i = 1; i < vExtremos.length; i++)
      vExtremos[i].mouseDragged();
  }
}
