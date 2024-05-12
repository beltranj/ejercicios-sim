float G = 4.9; // Gravedad

final int DISPLAY_SIZE_X = 1024; // Tamaño de la pantalla
final int DISPLAY_SIZE_Y = 600; // Tamaño de la pantalla
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;  
final float alturaBanderas = 200;
final float numeroBanderas = 3;

// Modificable properties
boolean hasWind = false;
boolean hasGravity = false;

PVector wind = new PVector (0, 0, 0);
PVector gravity = new PVector (0, 0, 0);
