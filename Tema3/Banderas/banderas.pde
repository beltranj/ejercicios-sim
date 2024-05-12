import peasy.*;
PeasyCam cam;

Malla bandera1, bandera2, bandera3;
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

    bandera1 = new Malla(30, 20, "Structured", #ED6A5A);
    bandera2 = new Malla(30, 20, "Bend", #F4F1BB);
    bandera3 = new Malla(30, 20, "Shear", #9BC1BC);
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
    fill(#5E574D);
    stroke(0);
    
    for (int i = -1; i < numeroBanderas -1; ++i) {
        pushMatrix();
        translate(-200 * i,0, 0);
        box(5, 5, alturaBanderas);
        popMatrix();
    }

    printFlagInformation();
}

void drawDynamicEnvironment(){
    pushMatrix();
    translate(-200,0, -100);
    bandera1.display();
    popMatrix();
    
    pushMatrix();
    translate(0,0,-100);
    bandera2.display();
    popMatrix();

    pushMatrix();
    translate(200,0,-100);
    bandera3.display();
    popMatrix();
}

void updateSimulation(){
    bandera1.update();
    bandera2.update();
    bandera3.update();
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
        bandera1 = new Malla(30, 20, "Structured", #ED6A5A);
        bandera2 = new Malla(30, 20, "Bend", #F4F1BB);
        bandera3 = new Malla(30, 20, "Shear", #9BC1BC);
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

    text("Press 'v' to toggle wind. " +
        (hasWind ? "ENABLED" : "DISABLED"), 20, 40);
    text("Press 'g' to toggle gravity. " +
        (hasGravity ? "ENABLED" : "DISABLED"), 20, 60);
    text("Press 'r' to reset the simulation", 20, 80);

    text("Mesh type: " + bandera1.Type, 200, 500);
    text("Elastic constant: " + bandera1.ke, 200, 520);
    text("Damping constant: " + bandera1.m_Damping, 200, 540);

    text("Mesh type: " + bandera2.Type, 500, 500);
    text("Elastic constant: " + bandera2.ke, 500, 520);
    text("Damping constant: " + bandera2.m_Damping, 500, 540);

    text("Mesh type: " + bandera3.Type, 750, 500);
    text("Elastic constant: " + bandera3.ke, 750, 520);
    text("Damping constant: " + bandera3.m_Damping, 750, 540);

    popMatrix();
}