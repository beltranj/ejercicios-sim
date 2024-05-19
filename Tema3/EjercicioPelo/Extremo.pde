class Extremo
{
  PVector _s;
  PVector _v;
  PVector _a;
  float Ec, Ep;
  boolean dragging = false;
  
  Extremo(float x, float y)
  {
    _s = new PVector(x,y);
    _v = new PVector();
    _a = new PVector();
  }
  
  void applyForce(PVector force)
  {
    PVector f = force.get();
    f.div(M);
    _a.add(f);

  }
  
  void update(float simStep)
  {
    _v.add(PVector.mult(_a, simStep));
    _s.add(PVector.mult(_v, simStep));
    _a.set(0,0);
  }

  void display()
  {
    stroke(0);
    strokeWeight(2);
    fill(175, 120);
  }
  
  void mousePressed(){
    PVector mouse = new PVector(mouseX, mouseY);
    PVector dir = PVector.sub(mouse, _s);
    float dist = dir.mag();
    if(dist < 20){
      dragging = true;
    }
  }  

  void mouseDragged(){
    if(dragging){
      _s.set(mouseX, mouseY);
    }
  }
}
  
