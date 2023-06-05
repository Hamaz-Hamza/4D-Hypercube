class Vector {
  float x, y, z, w;

  Vector(float x, float y, float z, float w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }
  
  float get(int index){
      switch(index){
          case 0: return x;
          case 1: return y;
          case 2: return z;
          case 3: return w;
          default: return 0;
      }
  }
  
}
