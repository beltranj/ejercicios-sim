// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle (-)

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   float _lifeSpan;     // Total time the particle should live (s)
   float _timeToLive;   // Remaining time before the particle dies (s)
   float gravity = -9.81;

   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c, float lifeSpan)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;

      _a = new PVector(0.0, 0.0);
      _F = new PVector(0.0, 0.0);

      _radius = radius;
      _color = c;
      _lifeSpan = lifeSpan;
      _timeToLive = _lifeSpan;
   }

   void setPos(PVector s)
   {
      _s = s;
   }

   void setVel(PVector v)
   {
      _v = v;
   }

   PVector getForce()
   {
      return _F;
   }

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   float getTimeToLive()
   {
      return _timeToLive;
   }

   boolean isDead()
   {
      return (_timeToLive <= 0.0);
   }

   void update(float timeStep)
   {
      // Update the particle's position, velocity, force and energy.
      _timeToLive -= timeStep;
      
      updateSimplecticEuler(timeStep);
   }

   void updateSimplecticEuler(float timeStep)
   {
      // a = F/m
      // v(t+h) = v(t) + h*a(s(t),v(t))
      // s(t+h) = s(t) + h*v(t)
   
      updateForce();

      _a = PVector.div(_F, _m);
      _v.add(PVector.mult(_a, timeStep));
      _s.add(PVector.mult(_v, timeStep));
   }

   void updateForce()
   {
      // F = Fg + Fd
      // Fg = m*g
      // Fd = -Kd*v^2

      if(_s.y < height/3){
         gravity = 9.81;
      }

      _F = new PVector(0.0, 0.0);
      PVector g = new PVector(0.0, gravity);
      PVector Fg = PVector.mult(g, _m);
      PVector Fd = PVector.mult(_v, 0.0001);
      
      _F = PVector.add(_F, Fg);
      _F = PVector.add(_F, Fd);
   }

   void render()
   {
      // Draw the particle on the screen using texture or not.
      // stroke(255);
      fill(_color, _timeToLive*255/_lifeSpan);
      ellipse(_s.x, _s.y, _radius*2, _radius*2);
   }
}