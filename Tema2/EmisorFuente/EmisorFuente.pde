/**
 * @name Emisor fuente
 * @description Simulación de un emisor de partículas que simulan el chorro de una fuente de agua.
 * @author Jordi Beltran Querol
 */

ParticleEmitter emitter;

void setup() {
  size(600, 400);
  emitter = new ParticleEmitter(new PVector(width/2, height/2));
}

void draw() {
  background(255);
  drawText();

  fill(#AECBEB, 100);
  rect(0, height/2, width, height/2);

  emitter.createNewParticles();
  emitter.moveObject();

  if(keyPressed) {
    if(key == ' ') {
      emitter.resetEmitter();
    }
    if(key == '+'){
      emitter.mag += 1;
    }
    if(key == '-'){
      emitter.mag -= 1;
    }
    if(key == 'q' || key == 'Q'){
      emitter.n_chorros += 1;
    }
    if(key == 'w' || key == 'W' && emitter.n_chorros > 2){
      emitter.n_chorros -= 1;
    }
  }

  for (Particle p : emitter.particles) {
    stroke(#C2E7DA);
    fill(#AECBEB);
    ellipse(p.pos.x, p.pos.y, 10, 10);
  }
}

void drawText() {
  fill(0);
  text("Emisor fuente de partículas", 10, 20);
  text("Número de particulas " + emitter.getNumParticles(), 10, 40);
  text("Presiona [+/-] para cambiar la velocidad de salida de las partículas, [SPACE] para reiniciar", 10, 60);
  text("Presiona las teclas [Q] para aumentar el número de chorros de agua, [W] para decrementarlo", 10, 80);
  text("Número de chorros de agua: " + emitter.n_chorros, 10, 100);
}