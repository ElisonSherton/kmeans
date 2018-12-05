// A Visual representation of the k-means algorithm
// Vinayak Nayak - 4th December 2018 - 17:37 IST
Table table;
String s;
float x_sum, y_sum;
ArrayList<Point> cluster1 = new ArrayList<Point>();
ArrayList<Point> cluster2 = new ArrayList<Point>();
ArrayList<Point> cluster3 = new ArrayList<Point>();
ArrayList<Point> data = new ArrayList<Point>();
ArrayList<Point> operationalData = new ArrayList<Point>();
ArrayList<Point> centroids;
int k = 3;
float scl = 6.5;

void setup() {
  size(800, 800);
  background(0);
  //Get the data from a csv file in an arraylist of Point Object
  table = loadTable("data.csv", "header");
  for (TableRow r : table.rows()) {
    data.add(new Point(r.getFloat("data_x"), r.getFloat("data_y")));
    operationalData.add(new Point(r.getFloat("data_x"), r.getFloat("data_y")));
  }
  //The operational Data set is created in order to pull three(k) unique points
  //From the given data. initializeCentroid function is specifically written to do that 
  centroids = initializeCentroids(operationalData);

  //Visually represent all the points in a raw unclassified format.
  for (Point unit : data) {
    pushMatrix();
    translate(width/10, height*0.9);
    text("O(0,0)", -50, 20);
    //Draw The Co-ordinate Axes
    stroke(255);
    line(-width/10, 0, width*0.9, 0);
    line(0, -height*0.9, 0, height*0.1);
    s = "(" + str(unit.x) + " , " + str(unit.y) + ")";
    textSize(16);
    text(s, unit.x*scl*1.1, -unit.y*scl*1.1);
    ellipse(unit.x*scl, -unit.y*scl, 16, 16);
    popMatrix();
  }
  //Introduced delay so that the transition can be seen distinctively
  delay(2000);
}// End of setup()

//Function to find the euclidean distance between two points.
//More on it here: https://en.wikipedia.org/wiki/Euclidean_distance
float euclideanDistance(Point a, Point b) {
  return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
}// End of euclideanDistance()

void draw() {
  ArrayList<Point> cluster1 = new ArrayList<Point>();
  ArrayList<Point> cluster2 = new ArrayList<Point>();
  ArrayList<Point> cluster3 = new ArrayList<Point>();
  background(0);
  for (Point x : data) {
    // Find the nearest centroid to a given point
    float distance = 10000;
    Point nearestPoint = centroids.get(0);
    for (Point y : centroids) {
      if (euclideanDistance(x, y) <= distance) {
        distance = euclideanDistance(x, y);
        nearestPoint = new Point(y.x, y.y);
      }
    }

    if (nearestPoint.x == centroids.get(0).x && nearestPoint.y == centroids.get(0).y) {
      cluster1.add(new Point(x.x, x.y));
    } else if (nearestPoint.x == centroids.get(1).x && nearestPoint.y == centroids.get(1).y) {
      cluster2.add(new Point(x.x, x.y));
    } else if (nearestPoint.x == centroids.get(2).x && nearestPoint.y == centroids.get(2).y) {
      cluster3.add(new Point(x.x, x.y));
    }
  }

  centroids = resetCentroids(cluster1, cluster2, cluster3);
  // Function to visually represent the result of the above iteration. 
  graph_Points(cluster1, cluster2, cluster3, centroids);
  delay(2000);
  fill(255);
  textSize(32);
  text("Post Iteration " + str(frameCount), 150, 50);
  textSize(16);

}// End of draw()

ArrayList<Point> initializeCentroids(ArrayList<Point> data) {
  ArrayList<Point> pts = new ArrayList<Point>();
  for (int i = 0; i<=k; i++) {
    int choice = int(random(data.size()));
    pts.add(data.get(choice));
    data.remove(choice);
  }
  return pts;
}//End of initializeCentroids

ArrayList<Point> resetCentroids(ArrayList<Point> c1, ArrayList<Point> c2, ArrayList<Point> c3) {
  ArrayList<Point> centroids = new ArrayList<Point>();
  x_sum = 0;
  y_sum = 0;
  for (Point a : c1) {
    x_sum += a.x;
    y_sum += a.y;
  }
  centroids.add(new Point(x_sum/c1.size(), y_sum/c1.size()));

  x_sum = 0;
  y_sum = 0;
  for (Point a : c2) {
    x_sum += a.x;
    y_sum += a.y;
  }
  centroids.add(new Point(x_sum/c2.size(), y_sum/c2.size()));

  x_sum = 0;
  y_sum = 0;
  for (Point a : c3) {
    x_sum += a.x;
    y_sum += a.y;
  }
  centroids.add(new Point(x_sum/c3.size(), y_sum/c3.size()));
  return centroids;
}// End of resetCentroid()

void graph_Points(ArrayList<Point> c1, ArrayList<Point> c2, ArrayList<Point> c3, ArrayList<Point> centroid) {
  pushMatrix();
  translate(width*0.10, height*0.9);
  //Draw The Co-ordinate Axes
  stroke(255);
  line(-width*0.1, 0, width*0.9, 0);
  line(0, -height*0.9, 0, height*0.1);
  text("O(0,0)", -50, 20);

  //Draw the centroid vector of cluster 1
  stroke(255, 0, 0);
  fill(255, 0, 0);
  line(0, 0, centroid.get(0).x*scl, -centroid.get(0).y*scl);
  ellipse(centroid.get(0).x*scl, -centroid.get(0).y*scl, 32, 32);

  //Draw the centroid vector of cluster 2
  stroke(0, 255, 0);
  fill(0, 255, 0);
  line(0, 0, centroid.get(1).x*scl, -centroid.get(1).y*scl);
  ellipse(centroid.get(1).x*scl, -centroid.get(1).y*scl, 32, 32);

  //Draw the centroid vector of cluster 3
  stroke(0, 0, 255);
  fill(0, 0, 255);
  line(0, 0, centroid.get(2).x*scl, -centroid.get(2).y*scl);
  ellipse(centroid.get(2).x*scl, -centroid.get(2).y*scl, 32, 32);


  //Draw Scatter Points And Bounding Circle for cluster 1
  float maxDistance = 0;
  Point farthest = new Point(0, 0);
  for (Point unit : c1) {
    s = "(" + str(unit.x) + " , " + str(unit.y) + ")";
    fill(255);
    text(s, unit.x*scl*1.1, -unit.y*scl*1.1);
    fill(255, 0, 0);
    ellipse(unit.x*scl, -unit.y*scl, 16, 16);
    if (euclideanDistance(unit, centroid.get(0)) > maxDistance) {
      maxDistance = euclideanDistance(unit, centroid.get(0));
      farthest = new Point(unit.x, unit.y);
    }
  }
  noFill();
  stroke(255, 0, 0);
  ellipse(centroid.get(0).x*scl, -centroid.get(0).y*scl, maxDistance*scl*2, maxDistance*scl*2);
  line(farthest.x*scl, -farthest.y*scl, centroid.get(0).x*scl, -centroid.get(0).y*scl);


  //Draw Scatter Points for cluster 2
  maxDistance = 0;
  farthest =  new Point(0, 0);
  for (Point unit : c2) {
    s = "(" + str(unit.x) + " , " + str(unit.y) + ")";
    fill(255);
    text(s, unit.x*scl*1.1, -unit.y*scl*1.1);
    fill(0, 255, 0);
    ellipse(unit.x*scl, -unit.y*scl, 16, 16);
    if (euclideanDistance(unit, centroid.get(1)) > maxDistance) {
      maxDistance = euclideanDistance(unit, centroid.get(1));
      farthest = new Point(unit.x, unit.y);
    }
  }
  noFill();
  stroke(0, 255, 0);
  ellipse(centroid.get(1).x*scl, -centroid.get(1).y*scl, maxDistance*scl*2, maxDistance*scl*2);
  line(farthest.x*scl, -farthest.y*scl, centroid.get(1).x*scl, -centroid.get(1).y*scl);


  //Draw Scatter Points and bounding circle for cluster 3
  maxDistance = 0;
  farthest =  new Point(0, 0);
  for (Point unit : c3) {
    s = "(" + str(unit.x) + " , " + str(unit.y) + ")";
    fill(255);
    text(s, unit.x*scl*1.1, -unit.y*scl*1.1);
    fill(0, 0, 255);
    ellipse(unit.x*scl, -unit.y*scl, 16, 16);
    if (euclideanDistance(unit, centroid.get(2)) > maxDistance) {
      maxDistance = euclideanDistance(unit, centroid.get(2));
      farthest = new Point(unit.x, unit.y);
    }
  }
  noFill();
  stroke(0, 0, 255);
  ellipse(centroid.get(2).x*scl, -centroid.get(2).y*scl, maxDistance*scl*2, maxDistance*scl*2);
  line(farthest.x*scl, -farthest.y*scl, centroid.get(2).x*scl, -centroid.get(2).y*scl);
  popMatrix();
  noStroke();
}// End of graph_Points()
