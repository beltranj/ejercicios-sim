static int _lastParticleId = 0; //<>//

public class Particle
{
   int _id;            // Unique id for each particle

   PVector _s;         // Position (m)
   PVector _v;         // Velocity (m/s)
   PVector _a;         // Acceleration (m/(s*s))
   PVector _F;         // Force (N)
   float _m;           // Mass (kg)
   float dist_ball;

   boolean _noGravity; // If true, the particle will not be affected by gravity
   boolean _clamped;   // If true, the particle will not move


   Particle(PVector s, PVector v, float m, boolean noGravity, boolean clamped)
   {
      _id = _lastParticleId++;

      _s = s.copy();
      _v = v.copy();
      _m = m;

      _noGravity = noGravity;
      _clamped = clamped;

      _a = new PVector(0.0, 0.0, 0.0);
      _F = new PVector(0.0, 0.0, 0.0);
   }

   void update(float simStep, Ball b)
   {
      if (_clamped)
         return;

      if (!_noGravity)
         updateWeightForce();

      // if(b!=null){
      //    if(checkCollision(b))
      //       updateCollisionForce(b);
      // }
      // Simplectic Euler:
      // v(t+h) = v(t) + h*a(s(t),v(t))
      // s(t+h) = s(t) + h*v(t+h)

      _a = PVector.div(_F, _m);
      _v.add(PVector.mult(_a, simStep));
      _s.add(PVector.mult(_v, simStep));
      _F.set(0.0, 0.0, 0.0);
   }

   boolean checkCollision(Ball b){
      dist_ball = PVector.dist(_s, b.getPosition());
      return dist_ball<Dm;
   }
   
   void updateCollisionForce(Ball b){
      float incX = dist_ball - L0_ball;

      if(incX < 0.0) 
         incX = -incX;

      float Fe = Ke_ball * incX;
      // Fuerza de rozamiento
      PVector Fd = PVector.mult(_v, 0.0001);

      PVector dist = PVector.sub(_s, b.getPosition());
      dist.normalize();
      PVector Fm = PVector.mult(dist, Fe);
      _F.add(Fm);
      _F.add(Fd);
      b.addExternalForce(PVector.mult(Fm, -1));
   }

   int getId()
   {
      return _id;
   }

   PVector getPosition()
   {
      return _s;
   }

   void setPosition(PVector s)
   {
      _s = s.copy();
      _a.set(0.0, 0.0, 0.0);
      _F.set(0.0, 0.0, 0.0);
   }

   void setVelocity(PVector v)
   {
      _v = v.copy();
   }

   void setClamped(boolean clamped)
   {
      _clamped = clamped;
   }

   void setNoGravity(boolean noGravity)
   {
      _noGravity = noGravity;
   }

   void updateWeightForce()
   {
      // Se modifica la fuerza peso para que sea en la dirección negativa de y
      PVector weigthForce = new PVector(0, G*_m, 0);
      _F.add(weigthForce);
   }

   void addExternalForce(PVector F)
   {
      _F.add(F);
   }
}
