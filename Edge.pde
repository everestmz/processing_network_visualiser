// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.
// Based on the GraphLayout example by Sun Microsystems.


class Edge {
  Node from;
  Node to;
  float len;
  int count;
  color eColor = #FFFFFF;


  Edge(Node from, Node to) {
    this.from = from;
    this.to = to;
    this.len = 50;
  }
  
  
  void increment() {
    count++;
  }
  
  
  void relax() {
    int divisor = 100*edgeCount*nodeCount;
    float vx = to.x - from.x;
    float vy = to.y - from.y;
    float d = mag(vx, vy);
    if (d > 0) {
      float f = (len - d) / (d*3);
      float dx = f * vx;
      float dy = f * vy;
      to.dx += dx/divisor;
      to.dy += dy/divisor;
      from.dx -= dx/divisor;
      from.dy -= dy/divisor;
    }
  }


  void draw() {
    stroke(eColor);
    strokeWeight(1.25);
    line(from.x, from.y, to.x, to.y);
  }
}
