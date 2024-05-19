// Damped spring between two particles:
//
// Fp1 = Fe - Fd
// Fp2 = -Fe + Fd = -(Fe - Fd) = -Fp1
//
//    Fe = Ke·(l - l0)·eN
//    Fd = -Kd·eN·v
//
//    e = s2 - s1  : current elongation vector between the particles
//    l = |e|      : current length
//    eN = e/l     : current normalized elongation vector
//    v = dl/dt    : rate of change of length

public class DampedSpring
{
   Particle _p1;     // First particle attached to the spring
   Particle _p2;     // Second particle attached to the spring

   float _Ke;        // Elastic constant (N/m)
   float _Kd;        // Damping coefficient (kg/m)

   float _l0;        // Rest length (m)
   float _l;         // Current length (m)
   float _v;         // Current rate of change of length (m/s)
   float prev_l;     // Previous length (m)

   PVector _e;       // Current elongation vector (m)
   PVector _eN;      // Current normalized elongation vector (no units)
   PVector _F;       // Force applied by the spring on particle 1 (the force on particle 2 is -_F) (N)
   
   DampedSpring(Particle a, Particle b, float l0, float ke, float kd)
   {
      _p1 = a;
      _p2 = b;

      _Ke = ke;
      _Kd = kd;

      _l0 = l0;
      _l = _l0;
      _v = 0.0;

      _e = PVector.sub(_p2.getPosition(), _p1.getPosition());
      _eN = _e.copy().normalize();
      _F = new PVector();
   }

   Particle getParticle1()
   {
      return _p1;
   }

   Particle getParticle2()
   {
      return _p2;
   }

   void update(float simStep)
   {
      _e = PVector.sub(_p2.getPosition(), _p1.getPosition());
      _eN = PVector.div(_e, _l);
      _l = _e.mag();

      PVector Fe = PVector.mult(_eN, _Ke * (_l - _l0));
      
      // _v = (prev_l - _l) / simStep;
      _v = (_l - _l0 ) / simStep;
      PVector Fd = PVector.mult(_eN, _Kd *_v);

      _F = PVector.add(Fe, Fd);
      // println("F: " + _F.mag());
      applyForces();

      prev_l = _l;  
   }

   void applyForces()
   {
      _p1.addExternalForce(_F);
      _p2.addExternalForce(PVector.mult(_F, -1.0));
   }
}
