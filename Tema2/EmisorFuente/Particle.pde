class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float mass;

  Particle(float x, float y, float m) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    mass = m;
  }
  
  // Constructor with initial position and velocity
  Particle(PVector p, PVector v, float m) {
    pos = p.copy();
    vel = v.copy();
    acc = new PVector(0, 0);
    mass = m;
  }
}