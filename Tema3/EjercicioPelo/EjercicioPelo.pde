/*
 * Ejercicio de Simulación de Cabello en Processing
 * Autor: Jordi Beltran
 *
 * Este programa simula el movimiento de cabello utilizando un modelo de muelles con damping.
 * Se crean NPELOS pelos alrededor de una cabeza y se actualizan en cada frame para simular su movimiento.
 * El usuario puede interactuar con los pelos haciendo clic y arrastrándolos con el ratón (arrastrar los extremos de los muelles) 
 *
 */

final int NPELOS = 120;
float _simTime;

void setup()
{
  size (700, 800);
  pos_cabeza = new PVector(width/2, height/3);
  crearPelos();
  _simTime = 0;
}

void crearPelos()
{
  for (int i = 0; i < NPELOS; i++)
  {
    float ang = random(PI, 2*PI);
    float x = pos_cabeza.x + cos(ang) * tam_cabeza/2;
    float y = pos_cabeza.y + sin(ang) * tam_cabeza/2;
    PVector ini = new PVector(x,y); //Se inicializarán en posiciones random 
    pelo = new Pelo (ini);
    Pelos[i] = pelo;
  }
}

void draw()
{
  background(#87C38F);
  fill(#DEC3BE);
  ellipse(pos_cabeza.x, pos_cabeza.y, tam_cabeza, tam_cabeza);
  updateSimulation();
  textInfo();
}

void updateSimulation(){
  for (int i = 0; i < NPELOS; i++)
    Pelos[i].update();

  _simTime += 0.1;
}

void mousePressed()
{
  for (int i = 0; i < NPELOS; i++)
    Pelos[i].mousePressed();
}

void mouseDragged()
{
  for (int i = 0; i < NPELOS; i++)
    Pelos[i].mouseDragged();
}

void textInfo()
{
  fill(0);
  textSize(20);
  text("Click and drag the mouse to interact with the hair", width*0.025, height*0.05);
  text("Number of hairs: " + NPELOS, width*0.025, height*0.075);
  text("Number of springs: " + NMUELLES, width*0.025, height*0.1);
}