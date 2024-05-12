float INITIAL_DISTANCE = 200;
PVector INITIAL_VELOCITY_BALL = new PVector(0, 0);
float MASS_BALL = 1;
float RADIUS_BALL = 20;
color BALL_COLOR = color(255, 0, 0);
final float pos_plane = -10;
final float Dm = RADIUS_BALL+1;

final float L0_ball = RADIUS_BALL+1;
final float Ke_ball = 20;
final float G = 9.8;
final float TS = 0.001;     // Initial simulation time step (s)
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time
float dist = 0; // distance between the ball and the heightmap