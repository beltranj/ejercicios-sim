// Class for a particle system controller
class ParticleSystem
{
   PVector _location;   
   ArrayList<Particle> _particles;
   int _nextId;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;
   }

   void addParticle(float mass, PVector initPos, PVector initVel, float radius, color c, float lifeSpan)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, radius, c, lifeSpan));
      _nextId++;
   }

   void restart()
   {
      _particles.clear();
   }

   int getNumParticles()
   {
      return _particles.size();
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void update(float timeStep)
   {
      for (int i = _particles.size() - 1; i >= 0 ; i--)
      {
         Particle p = _particles.get(i);
         
         if (!p.isDead())
            p.update(timeStep);
         else
            _particles.remove(i);
      }
   }

   void render()
   {
      for (int i = _particles.size() - 1; i >= 0 ; i--)
      {
         Particle p = _particles.get(i);
         p.render();
      }
   }
}