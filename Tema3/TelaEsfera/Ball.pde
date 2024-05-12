class Ball{
    
    PVector _s;
    PVector _v;
    PVector _a;
    PVector _F;

    float _r;
    float _m;
    float scaleVelocity;
    color _c;

    PImage _img;
    PShape sphere;

    float height;
    boolean isSurface = false;
    
    Ball(PVector s, PVector v, float r, float m, color c){
        _s = s;
        _v = v;
        _r = r;
        _m = m;
        _c = c;

        _a = new PVector(0.0, 0.0, 0.0);
        _F = new PVector(0.0, 0.0, 0.0);

        fill(_c);
        sphere = createShape(SPHERE, _r);
    }

    void drawBall() {
        pushMatrix();
        translate(_s.x, _s.y, _s.z);
        shape(sphere);
        popMatrix();
    }   
}
