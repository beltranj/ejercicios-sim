/**
* Parameters 
*/
final float G = 9.81;
final float M = 10;
final int NMUELLES = 19;
float LONGITUD_PELO = 20;
float simStep = 0.1;

PVector GRAVITY = new PVector(0,G);

PVector pos_cabeza;
float tam_cabeza = 100;
Pelo pelo;
Pelo[] Pelos = new Pelo[NPELOS];