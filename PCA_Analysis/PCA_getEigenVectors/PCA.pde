import Jama.Matrix;
import pca_transform.*;

Matrix originalData;
Matrix eigenVectors;
PCA pca;
Matrix rotated;

PVector axis1;
PVector axis2;
PVector mean;

//float[] allX, allY;

void getEigenVectors(Table csvData) {
  originalData = new Matrix(csvData.getRowCount(), csvData.getColumnCount());
  mean = new PVector();
  //allX = new float[csvData.getRowCount()];
  // allY = new float[csvData.getRowCount()]; 
  for (int i = 0; i < originalData.getRowDimension(); i++) {
    TableRow row = csvData.getRow(i);
    float xValue = row.getFloat("x");
    float yValue = row.getFloat("y");
    originalData.set(i, 0, xValue);
    originalData.set(i, 1, yValue);
    mean.x += xValue;
    mean.y += yValue;
    //allX[i] = xValue;
    //allY[i] = yValue;
  }
  //originalData.print(10, 2);

  mean.x /= originalData.getRowDimension();
  mean.y /= originalData.getRowDimension();

  pca = new PCA(originalData);
  eigenVectors = pca.getEigenvectorsMatrix();
  println("num eigen vectors: " + eigenVectors.getColumnDimension());
  for (int i = 0; i < eigenVectors.getColumnDimension(); i++) {
    println("eigenvalue for eigenVector " + i + ": " + pca.getEigenvalue(i) );
  }
  eigenVectors.print(10, 2);
  axis1 = new PVector();
  axis2 = new PVector();
  axis1.x = (float)eigenVectors.get(0, 0);
  axis1.y = (float)eigenVectors.get(1, 0);
  axis2.x = (float)eigenVectors.get(0, 1);
  axis2.y = (float)eigenVectors.get(1, 1);  
  axis1.mult((float)pca.getEigenvalue(0));
  axis2.mult((float)pca.getEigenvalue(1));
  rotated = pca.transform(originalData, PCA.TransformationType.ROTATION);
}

public PVector point_nearest_line(PVector v0, PVector v1, PVector p){
  PVector vp = null;
  PVector the_line = PVector.sub(v1, v0);
  float lineMag = the_line.mag();
  lineMag = lineMag * lineMag;
  if (lineMag > 0.0) {
    PVector pv0_line = PVector.sub(p, v0);
    float t = pv0_line.dot(the_line)/lineMag;
    if (t >= 0 && t <= 1){
      vp = new PVector();
      vp.x = the_line.x * t + v0.x;
      vp.y = the_line.y * t + v0.y;
    }
  }
  return vp;
}