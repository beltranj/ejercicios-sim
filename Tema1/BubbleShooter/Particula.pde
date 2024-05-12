class Particula {
  
  PVector _s;
  PVector _v;

  /**
   * Constructor de la clase Particula
   */
  Particula(PVector posicion, PVector direccion) {
    _s = posicion.copy();
    _v = direccion.copy();
  }

  /**
   * Método que actualiza la posición de la partícula
   */
  void mover() {
    _s.add(PVector.mult(_v, dt));
  }

  /**
   * Método que muestra la partícula
   */
  void mostrar() {
    fill(#F7A072);
    ellipse(_s.x, _s.y, 20, 20);
  }

}