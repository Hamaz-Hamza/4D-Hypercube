float angle = 0;
Vector[] points = new Vector[16];
float[][] projection = {{1, 0, 0, 0},
                        {0, 1, 0, 0},
                        {0, 0, 1, 0}};

void setup() {
  size(1200, 600, P3D);
  
  points[0] = new Vector(-1, -1, -1, 01);
  points[1] = new Vector(01, -1, -1, 01);
  points[2] = new Vector(01, 01, -1, 01);
  points[3] = new Vector(-1, 01, -1, 01);
  points[4] = new Vector(-1, -1, 01, 01);
  points[5] = new Vector(01, -1, 01, 01);
  points[6] = new Vector(01, 01, 01, 01);
  points[7] = new Vector(-1, 01, 01, 01);
  points[8] = new Vector(-1, -1, -1, -1);
  points[9] = new Vector(01, -1, -1, -1);
  points[10] = new Vector(01, 01, -1, -1);
  points[11] = new Vector(-1, 01, -1, -1);
  points[12] = new Vector(-1, -1, 01, -1);
  points[13] = new Vector(01, -1, 01, -1);
  points[14] = new Vector(01, 01, 01, -1);
  points[15] = new Vector(-1, 01, 01, -1);
  
  stroke(250);
  strokeWeight(12);
  noFill();
}

void draw() {
  background(0);
  translate(width/2, height/2);
  rotateX(-PI/2);
  
  PVector[] projected3d = new PVector[16];

  for (int i = 0; i < points.length; i++) {
    Vector vec = points[i];
                                
    float[][] rotationMatrixZW = {{1, 0,          0,           0},
                                  {0, 1,          0,           0},
                                  {0, 0, cos(angle), -sin(angle)},
                                  {0, 0, sin(angle), cos(angle)}};
                                
    float[][] rotationMatrixYW = {{1, 0         , 0,           0},
                                  {0, cos(angle), 0, -sin(angle)},
                                  {0, 0         , 1,           0},
                                  {0, sin(angle), 0, cos(angle)}};
    
    float[][] rotationMatrixXW = {{cos(angle), 0, 0, -sin(angle)},
                                  {0         , 1, 0,           0},
                                  {0         , 0, 1,           0},
                                  {sin(angle), 0, 0, cos(angle)}};
                                  
    float[][] rotationMatrixXY = {{cos(angle), -sin(angle), 0, 0},
                                  {sin(angle),  cos(angle), 0, 0},
                                  {0         , 0, 1,           0},
                                  {0         , 0, 0,           1}};
    
    vec = matrixMult4x4(rotationMatrixZW, vec);
    vec = matrixMult4x4(rotationMatrixXY, vec);

    float distance = 2;
    float w = 3 / (distance - vec.w);
    
    float[][] proj = scalarMult(projection, w);
    PVector projected = matrixMult3x4(proj, vec);
    
    projected.mult(50);
    projected3d[i] = projected;

    strokeWeight(20);
    point(projected.x, projected.y, projected.z);
  }
    
  strokeWeight(5);
  // Connecting points
  for (int i = 0; i < 4; i++) {
    connect(0, i, (i+1) % 4, projected3d);
    connect(0, i+4, ((i+1) % 4)+4, projected3d);
    connect(0, i, i+4, projected3d);
  
    connect(8, i, (i+1) % 4, projected3d );
    connect(8, i+4, ((i+1) % 4)+4, projected3d);
    connect(8, i, i+4, projected3d);
  }

  for (int i = 0; i < 8; i++) connect(0, i, i + 8, projected3d);

  angle += 0.02;
}

void connect(int offset, int i, int j, PVector[] points) {
  PVector a = points[i+offset];
  PVector b = points[j+offset];
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}

float[][] scalarMult(float[][] matrix, float f){
    float[][] mat = new float[3][4];
    for (int i = 0; i < 3; i++){
        for (int j = 0; j < 4; j++){
            mat[i][j] = matrix[i][j] * f;
        }
    }
    return mat;
}

Vector matrixMult4x4(float[][] matrix, Vector vector){
    float[] row1 = matrix[0];
    float[] row2 = matrix[1];
    float[] row3 = matrix[2];
    float[] row4 = matrix[3];
    
    float x = 0;
    for (int i = 0; i < 4; i++)  x += row1[i]*vector.get(i);
    
    float y = 0;
    for (int i = 0; i < 4; i++)  y += row2[i]*vector.get(i);
    
    float z = 0;
    for (int i = 0; i < 4; i++)  z += row3[i]*vector.get(i);
    
    float w = 0;
    for (int i = 0; i < 4; i++)  w += row4[i]*vector.get(i);
    
    return new Vector(x,y,z,w);
}

PVector matrixMult3x4(float[][] matrix, Vector vector){
    float[] row1 = matrix[0];
    float[] row2 = matrix[1];
    float[] row3 = matrix[2];
    
    float x = 0;
    for (int i = 0; i < 4; i++)  x += row1[i]*vector.get(i);
    
    float y = 0;
    for (int i = 0; i < 4; i++)  y += row2[i]*vector.get(i);
    
    float z = 0;
    for (int i = 0; i < 4; i++)  z += row3[i]*vector.get(i);
    
    return new PVector(x,y,z);
}
