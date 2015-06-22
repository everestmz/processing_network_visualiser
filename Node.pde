// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.
// Based on the GraphLayout example by Sun Microsystems.


class Node {
  float x, y;
  float dx, dy;
  boolean fixed;
  String label;
  int count;
  int connections;
  color nColor;
  boolean highlighted = false;


  Node(String label) {
    this.label = label;
    x = random(width);
    y = random(height);
  }
  
  
  void increment() {
    count++;
  }
  
  
  void relax() {
    float ddx = 0;
    float ddy = 0;

    for (int j = 0; j < nodeCount; j++) {
      Node n = nodes[j];
      if (n != this) {
        float vx = x - n.x;
        float vy = y - n.y;
        float lensq = vx * vx + vy * vy;
        if (lensq == 0) {
          ddx += random(1);
          ddy += random(1);
        } else if (lensq < 100*100) {
          ddx += vx / lensq;
          ddy += vy / lensq;
        }
      }
    }
    float dlen = mag(ddx, ddy) / 2;
    if (dlen > 0) {
      dx += ddx / dlen;
      dy += ddy / dlen;
    }
  }


  void update() {
    if (!fixed) {      
      x += constrain(dx, -5, 5);
      y += constrain(dy, -5, 5);
      
      x = constrain(x, 0, width);
      y = constrain(y, 0, height);
    }
    dx /= 2;
    dy /= 2;
  }


  void draw() {
    if(count/2 > less75Count)
    {
      nColor = largeColor;
    }
    else if(count/2 > less50Count)
    {
      nColor = less75Color;
    }
    else if(count/2 > less25Count)
    {
      nColor = less50Color;
    }
    else if(count/2 <= less25Count)
    {
      nColor = less25Color;
    }
    stroke(0);
    strokeWeight(0.5);
    if(highlighted)
    {
      nColor = #FFFFFF;
    }
    fill(nColor);
    if(count<20)
    {
      ellipse(x, y, 30 + 5*count, 30+5*count);
    }
    else
    {
      ellipse(x, y, 130, 130);
    }
    
    //ellipse(x, y, count, count);
    float w = textWidth(label);

    
      fill(0);
      textAlign(CENTER, CENTER);
      text(label, x, y);
    
  }
}

