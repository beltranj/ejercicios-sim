import peasy.*;
PeasyCam cam;
Ball b;
Malla malla;

float dt = 0.1;

void settings(){
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
}

void setup(){
    float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);
    perspective((FOV*PI)/180, aspect, NEAR, FAR);
    cam = new PeasyCam(this, 0);
    cam.rotateX(PI/2);
    cam.setDistance(400);
    b = new Ball(new PVector(0,0,-40), new PVector(0,0,0), 40, 25, 255);
    malla = new Malla(100, 100, 100, 100, 100, 100);
}

void draw(){
    background(#C3DFE0);
    drawAxes(100);
    drawStaticEnvironment();
    updateSimulation();
    changeValues();
    drawDynamicEnvironment();
}

/**
 * Dibuja el entorno estático
 * Ahora mismo dibuja los palos de las banderas
 */
void drawStaticEnvironment(){
    // Draw the static environment
    // Draw a plane
    box(300, 300, 1);
    // Draw a Ball
    b.drawBall();
    
}

void drawDynamicEnvironment(){
    //TODO: Draw the dynamic environment
    //Draw a mesh

}

void updateSimulation(){
    malla.update();
    b.update();
    b.checkCollision(malla);
}

void drawAxes(float length) {
    // X-axis in red
    stroke(255, 0, 0);
    line(0, 0, 0, length, 0, 0);

    // Y-axis in green
    stroke(0, 255, 0);
    line(0, 0, 0, 0, length, 0);

    // Z-axis in blue
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, length);
}

void keyPressed(){

    if(key == 'v' || key == 'V'){
        hasWind = !hasWind;
    }

    if (key == 'r' || key == 'R') {
        // resetSimulation();
    }

    if (key == 'g' || key == 'G') {
        hasGravity = !hasGravity;
    }
}

void changeValues(){

    if (hasWind) {
        wind = new PVector(0.5 - random(10, 40) * 0.1, 0.1 - random(0, 0.2), 0.5 + random(10, 60) * 0.1);    
    } else {
        wind = new PVector(0, 0, 0);
    }

    if (hasGravity) {
        gravity = new PVector(0,0,4.8);
    } else {
        gravity = new PVector(0, 0, 0);   
    }
}

void printFlagInformation(){
    pushMatrix();
    
    camera();
    fill(0);
    textSize(14);
    text("Press 'v' to toggle wind", 10, 20);

    popMatrix();
}