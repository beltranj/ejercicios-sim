/*
 * Deformable object simulation - Mesh-ball collision
 * Author: Jordi Beltran
 */

import peasy.*;

// Display control:
PeasyCam _camera;             // Mouse-driven 3D camera

// Simulation and time control:
float _timeStep;              // Simulation time-step (s)
int _lastTimeDraw = 0;        // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;         // Simulated time (s)
float _elapsedTime = 0.0;     // Elapsed (real) time (s)

// Output control:
boolean _writeToFile = false;
PrintWriter _output;

// System variables:
DeformableObject malla;       // Deformable object
Ball b;                       // Ball
SpringLayout _springLayout;   // Current spring layout

// Main code:
void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
}

void setup()
{
   frameRate(DRAW_FREQ);
   _lastTimeDraw = millis();

   float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);
   perspective((FOV*PI)/180, aspect, NEAR, FAR);
   _camera = new PeasyCam(this, 0);
   _camera.rotateX(-PI/2);
   _camera.setDistance(235);

   initSimulation();
}

void changeValues(){

   if(isGravity)
      gravity.set(0, 0, -G * PARTICLE_MASS);
   else
      gravity.set(0, 0, 0);
}

void stop()
{
   endSimulation();
}

void keyPressed()
{
   if (key == 'R' || key == 'r')
      initSimulation();

   if (key == 'D' || key == 'd')
      DRAW_MODE = !DRAW_MODE;
   
   if (key == 'G' || key == 'g')
      isGravity = !isGravity;

   if (key == 'C' || key == 'c'){
      areClamped = !areClamped;
      initSimulation();
   }
      
   if (key == '1')
      malla = new DeformableObject(SpringLayout.STRUCTURAL, #B2C9AB, KE_STRUCTURAL, KD_STRUCTURAL);

   if (key == '2')
      malla = new DeformableObject(SpringLayout.STRUCTURAL_AND_BEND, #B2C9AB, KE_SHEAR, KD_SHEAR);

   if (key == '3')
      malla = new DeformableObject(SpringLayout.STRUCTURAL_AND_SHEAR, #B2C9AB, KE_BEND, KD_BEND);

   if (key == '4')
      malla = new DeformableObject(SpringLayout.STRUCTURAL_AND_SHEAR_AND_BEND, #B2C9AB, KE_STRUCTURAL, KD_STRUCTURAL);
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, n, Tsim");
   }

   _simTime = 0.0;
   _timeStep = TS*TIME_ACCEL;
   _elapsedTime = 0.0;

   malla = new DeformableObject(SpringLayout.STRUCTURAL, #B2C9AB, KE_STRUCTURAL, KD_STRUCTURAL);
   b = new Ball(new PVector(N_H*D_H*0.5, N_V*D_V*0.5, -N_V*D_V*0.5), new PVector(0, 0, 0), BALL_MASS, BALL_RADIUS, BALL_COLOR);
   
   _camera.lookAt(b._s.x, b._s.y, b._s.z);
}

void restartSimulation(SpringLayout springLayout)
{
   _simTime = 0.0;
   _timeStep = TS*TIME_ACCEL;
   _elapsedTime = 0.0;
   _springLayout = springLayout;
}

void endSimulation()
{
   if (_writeToFile)
   {
      _output.flush();
      _output.close();
   }
}

void draw()
{
   int now = millis();
   _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
   _elapsedTime += _deltaTimeDraw;
   _lastTimeDraw = now;

   background(BACKGROUND_COLOR);
   changeValues();
   // drawStaticEnvironment();
   drawDynamicEnvironment();

   if (REAL_TIME)
   {
      float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
      float expectedIterations = expectedSimulatedTime/_timeStep;
      int iterations = 0;

      for (; iterations < floor(expectedIterations); iterations++)
         updateSimulation();

      if ((expectedIterations - iterations) > random(0.0, 1.0))
      {
         updateSimulation();
         iterations++;
      }
   } 
   else
      updateSimulation();

   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + "," + malla.getNumNodes() + ", 0");
}

void drawStaticEnvironment()
{
   noStroke();
   fill(255, 0, 0);
   box(1000.0, 1.0, 1.0);

   fill(0, 255, 0);
   box(1.0, 1000.0, 1.0);

   fill(0, 0, 255);
   box(1.0, 1.0, 1000.0);

   fill(255, 255, 255);
   sphere(1.0);
}

void drawDynamicEnvironment()
{
   b.render();
   malla.render();
}

void updateSimulation()
{
   malla.update(_timeStep);
   b.update(_timeStep);
   malla.ballCollision(b);

   _simTime += _timeStep;
}

void writeToFile(String data)
{
   _output.println(data);
}

void displayInfo()
{
   pushMatrix();
   {
      camera();
      fill(0);
      textSize(20);

      text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.75);
      text("Elapsed time = " + _elapsedTime + " s", width*0.025, height*0.775);
      text("Simulated time = " + _simTime + " s ", width*0.025, height*0.8);
      text("Available options: [R] to reset simulation, [D] to change the drawMode, [G] to toggle gravity", width*0.025, height*0.825);
      text("Structure type: [1] Structural, [2] Structural and Bend, [3] Structural and Shear, [4] Structural and Shear and Bend", width*0.025, height*0.85);
      text("Gravity state: " + isGravity, width*0.025, height*0.875);
      text("Clamped state: " + areClamped, width*0.025, height*0.9);
      text("Using mesh structure: " + malla._springLayout, width*0.025, height*0.925);
   }
   popMatrix();
}
