// Definitions:

// Spring Layout
enum SpringLayout
{
   STRUCTURAL,
   SHEAR,
   BEND,
   STRUCTURAL_AND_SHEAR,
   STRUCTURAL_AND_BEND,
   SHEAR_AND_BEND,
   STRUCTURAL_AND_SHEAR_AND_BEND
}

// Simulation values:

final boolean REAL_TIME = true;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time


// Display and output parameters:

boolean DRAW_MODE = false;                            // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1400;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 900;                       // Display height (pixels)
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color OBJ_COLOR = color(250, 240, 190);         // Object color (RGB)

final color BALL_COLOR = #92B6B1;                     // Ball color (RGB)
final float BALL_RADIUS = 20;                         // Ball radius (m)
final float BALL_MASS = 1;                            // Ball mass (kg)

final color BACKGROUND_COLOR = #E8DDB5;               // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables

// Parameters of the problem:

final float TS = 0.001;                // Initial simulation time step (s)
final float G = 9.81;                  // Acceleration due to gravity (m/(s·s))

final int N_H = 60;                    // Number of nodes of the object in the horizontal direction
final int N_V = 60;                    // Number of nodes of the object in the vertical direction

final float D_H = 3;                   // Separation of the object's nodes in the horizontal direction (m)
final float D_V = 3;                   // Separation of the object's nodes in the vertical direction (m)

final float PARTICLE_MASS = 0.25;      // Mass of the particles (kg)

final float KE_STRUCTURAL = 400;       // Structural spring stiffness (N/m)
final float KD_STRUCTURAL = 3;         // Structural spring damping (N·s/m)

final float KE_SHEAR = 150;            // Shear spring stiffness (N/m)
final float KD_SHEAR = 2;              // Shear spring damping (N·s/m)

final float KE_BEND = 300;             // Bend spring stiffness (N/m)
final float KD_BEND = 2;               // Bend spring damping (N·s/m)

boolean isGravity = false;             // True to consider gravity
boolean areClamped = false;            // True to clamp two vertexes of the mesh

PVector gravity = new PVector();       // Gravity direction
