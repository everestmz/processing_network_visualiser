import java.io.*;
import java.util.*;
int time;

PFont font;

///FILE HANDLING VARIABLES and GRAPH THEORY DATA\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

//File Handling GLobal Variables
boolean fileLoaded = false;
XML xml;
String fileName="";
String title = "";

boolean loadCorrectFile = false;

//Graph Theory Global Variables
int nodeCount;
Person[] persons;
Node[] nodes;
HashMap nodeTable = new HashMap();
int edgeCount;
Edge[] edges;

///NODE COLORS AND AESTHETICS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

//Variables to store the breakpoints for what color the nodes are
int largestCount=0;
int less75Count;
int less50Count;
int less25Count;

//Colors for nodes based on number of connections, and edge colors
static final color largeColor   = #BA413B;
static final color less75Color = #BAA63B;
static final color less50Color = #5E9EB9;
static final color less25Color = #2E903A;
static final color selectColor = #FF3030;
static final color fixedColor  = #FF8080;
static final color edgeColor   = #FFFFFF;

///RIGHT CLICK STATE VARIABLES\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//The node the right click is closest to
Node rightSelection;
//Is there a right click menu currently open?
boolean right = false;


///CLICK HANDLING\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

///Rect Button Variables

int rectX, rectY;      // Position of square button
int rectSize = 200;     // Diameter of rect
color rectColor, circleColor, baseColor;
color rectHighlight, circleHighlight;
color currentColor;
boolean rectOver = false;

///Rect Button Handlers

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void update(int x, int y) {
  if ( overRect(rectX, rectY, rectSize, rectSize) ) {
    rectOver = true;
    
  } else {
    rectOver = false;
  }
}




//This is the currently selected node
Node selection; 

void mousePressed() {
  
  //Left Click Handling
  if(mouseButton == LEFT)
  {
    //If the mouse is further than this from the center of the menu item, it wasn't clicked
    float menuClosest = 20;

    if(!fileLoaded)
    {
      float d = dist(mouseX, mouseY, width/2, height/2);
      if(d<100)
      {
        selectInput("Select a file to process:", "fileSelected");
      }  
    }
    
    //If there is a right click active, check if menu items have been clicked on
    if(right)
    {
      float d = dist(mouseX, mouseY, rightSelection.x+52, rightSelection.y+45);
      if(d<menuClosest)
      {
        highlightConnections(rightSelection); 
      }
      d = dist(mouseX, mouseY, rightSelection.x+52, rightSelection.y+70);
      if(d<menuClosest)
      {
        //cycle(rightSelection); 
      }
      d = dist(mouseX, mouseY, rightSelection.x+52, rightSelection.y+95);
      if(d<menuClosest)
      {
        firstDegree(rightSelection);
      }
    }
    
    right=false;
    // Ignore anything greater than this distance
    float closest = 20;
    for (int i = 0; i < nodeCount; i++) {
      Node n = nodes[i];
      float d = dist(mouseX, mouseY, n.x, n.y);
      if (d < closest) {
        selection = n;
        closest = d;
      }
    }
    if (selection != null) {
      if (mouseButton == LEFT) {
        selection.fixed = true;
      } else if (mouseButton == RIGHT) {
        selection.fixed = false;
      }
    }
  }
  //Right Click Handling
  else if(mouseButton == RIGHT)
  {
    // Ignore anything greater than this distance
    float closest = 20;
    for (int i = 0; i < nodeCount; i++) {
      Node n = nodes[i];
      float d = dist(mouseX, mouseY, n.x, n.y);
      if (d < closest) {
        selection = n;
        closest = d;
      }
    }
    if(selection != null)
    {
      rightSelection = selection;
      right = true;
    }  
  }
  
}


void mouseDragged() {
  if (selection != null) {
    if(mouseX > width)
    {
      selection.x = width;
    }
    else if(mouseX < 0)
    {
      selection.x = 0;
    }
    else
    {
      selection.x = mouseX;
    }
    if(mouseY > height)
    {
      selection.y = height;
    }
    else if(mouseY < 0)
    {
      selection.y = 0;
    }
    else
    {
      selection.y = mouseY;
    }
  }
}


void mouseReleased() {
  selection = null;
}

///KEYBOARD PRESS HANDLING\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

boolean record;
int increment = 50;
int wait = 500;
void keyPressed() {
  if(key == 'c')
  {
    for(int i=0;i<edgeCount;i++)
    {
      edges[i].eColor = #FFFFFF;
    } 
    for(int i=0;i<nodeCount;i++)
    {
      nodes[i].highlighted = false;      
    }
  }
  if (key == 'r') {
    record = true;
  }
  if(keyCode==UP ){
    for(int i=0;i<nodeCount;i++)
    {
      
      nodes[i].y += 50;
     
    }
  }
  if(keyCode==DOWN){
    for(int i=0;i<nodeCount;i++)
    {
      nodes[i].y -= increment;
    }
  }
  if(keyCode==LEFT){
    for(int i=0;i<nodeCount;i++)
    {
      nodes[i].x += increment;
    }
  }
  if(keyCode==RIGHT){
    for(int i=0;i<nodeCount;i++)
    {
      nodes[i].x -= increment;
    }
  }
}


///FILE SELECTION CODE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  } else {
    fileName = selection.getAbsolutePath();
    loadData();
  }
}

///XML LOADING AND READING HANDLING\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

void loadData() {
  
  if(!fileName.substring(fileName.length()-4, fileName.length()).equals(".xml"))
  {
    loadCorrectFile = true; 
    fileLoaded = false; 
  }  
  
  xml = loadXML(fileName);
  title = xml.getChild("title").getContent();
  XML[] people = xml.getChildren("person");
  nodes = new Node[people.length];
  edges = new Edge[nodes.length*nodes.length];
  persons = new Person[people.length];
  for (int i = 0; i < people.length; i++) {
    // Make this phrase lowercase
    String connections = people[i].getString("connections");
    // Split each phrase into individual words at one or more spaces
    Scanner sc = new Scanner(connections);
    sc.useDelimiter(", ");
    while(sc.hasNext()) {
      addEdge(people[i].getContent(), sc.next());
    }
  }
  fileLoaded = true;
}

///ADDING A NEW EDGE TO THE GRAPH\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

void addEdge(String fromLabel, String toLabel) {
  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);
  from.increment();
  from.connections++;
  if(from.connections>largestCount)
  {largestCount = from.connections/2;}
  to.increment();
  to.connections++;
  if(to.connections>largestCount)
  {largestCount = to.connections/2;}
  
  less75Count = ceil(largestCount*0.75);
  less50Count = ceil(largestCount*0.5);
  less25Count = ceil(largestCount*0.25);
  
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      edges[i].increment();
      return;
    }
  } 
  
  Edge e = new Edge(from, to);
  e.increment();
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
}

///CHECK IF A NODE EXISTS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Node findNode(String label) {
  //label = label.toLowerCase();
  Node n = (Node) nodeTable.get(label);
  if (n == null) {
    return addNode(label);
  }
  return n;
}


///CREATE A NEW NODE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Node addNode(String label) {
  Node n = new Node(label);  
  if (nodeCount == nodes.length) {
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n; 
  return n;
}

///GRAPH ALGORITHMS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//This highlights all edges adjacent to Node n
void highlightConnections(Node n)
{
  
  for(int i=0;i<nodeCount;i++)
  {
    if(nodes[i].x==width/2 && nodes[i].y==height/2)
    {
      float multiplier = random(-1,2);
      if(multiplier==0)
      {
        multiplier=-1;
      }
      nodes[i].x+=random(-1,2)*int(random(200, 600));
      nodes[i].y+=random(-1,2)*int(random(200, 400));
    }
  }
  
  for(int i=0;i<edgeCount;i++)
  {
    n.x = width/2;
    n.y = height/2;
    if(edges[i].to==n||edges[i].from==n)
    {
     edges[i].eColor = #ADFF2F;
    }
    else
    {
     edges[i].eColor = #FFFFFF; 
    }
  }
  
}
//This algorithm highlights all first degree connection nodes
void firstDegree(Node n)
{
  for(int i=0;i<edgeCount;i++)
  {
    n.x = width/2;
    n.y = height/2;
    if(edges[i].to==n)
    {
      edges[i].from.highlighted = true;
    }
    else if(edges[i].from==n)
    {
      edges[i].to.highlighted = true;
    }
  }
   
}

///PROCESSING SETUP AND DRAW METHODS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

void setup() {
  size(displayWidth, displayHeight-100);  
  //Create the initial font style
  font = createFont("SansSerif", 10);
  textFont(font); 
 
  ///BUTTON SETUP
  rectColor = color(0);
  rectHighlight = color(51);
  rectX = width/2-rectSize/2;
  rectY = height/2-rectSize/2;
  
  time = millis();
  
}

void draw() {
  
  
  if(fileLoaded)
  {
    background(0, 0, 0);
    
    if (record) {
      beginRecord(PDF, "output.pdf");
    }
     
    smooth();
    ///DRAWING\\\
    for (int i = 0 ; i < edgeCount ; i++) {
      //edges[i].relax();
    }
    for (int i = 0; i < nodeCount; i++) {
      nodes[i].relax();
    }
    for (int i = 0; i < nodeCount; i++) {
      //nodes[i].update();
    }
    for (int i = 0 ; i < edgeCount ; i++) {
      edges[i].draw();
    }
    for (int i = 0 ; i < nodeCount ; i++) {
      nodes[i].draw();
    }
    
    if (record) {
      endRecord();
      record = false;
    }
    
    if(right)
    {
      fill(255, 255, 255);
      rect(rightSelection.x, rightSelection.y, 100, 200); 
      fill(0, 0, 0);
      rect(rightSelection.x, rightSelection.y+20, 100, 10);
      textAlign(LEFT);
      textSize(15);
      text(rightSelection.label, rightSelection.x+5, rightSelection.y+15);
      text("Connections", rightSelection.x+5, rightSelection.y+45);
      text("Cycles", rightSelection.x+5, rightSelection.y+70);
      text("First Degree", rightSelection.x+5, rightSelection.y+95);
      text("Clusters", rightSelection.x+5, rightSelection.y+120);
    }
    
    fill(255, 255, 255);
    textAlign(LEFT);
    textSize(20);
    text(title, 0, 20);
    textSize(15);
    text("People: "+nodeCount, 0, 35);
    text("Connections: "+edgeCount, 0, 50);
    textSize(10);
    text("File loaded: "+fileName, 0, height-10);
    fill(255, 255, 255);
    rect(10, 70, 175, 210);
    fill(0, 0, 0);
    rect(15, 75, 165, 200);
    ///
    fill(255, 255, 255);
    rect(21, 91, 22, 22);
    fill(largeColor);
    rect(25, 95, 20, 20);
    fill(255, 255, 255);
    text("Over "+less75Count+" connections", 48, 110);
    ///
    fill(255, 255, 255);
    rect(21, 131, 22, 22);
    fill(less75Color);
    rect(25, 135, 20, 20);
    fill(255, 255, 255);
    text("Over "+less50Count+" connections", 48, 150);
    ///
    fill(255, 255, 255);
    rect(21, 171, 22, 22);
    fill(less50Color);
    rect(25, 175, 20, 20);
    fill(255, 255, 255);
    text("Over "+less25Count+" connections", 48, 190);
    ///
    fill(255, 255, 255);
    rect(21, 211, 22, 22);
    fill(less25Color);
    rect(25, 215, 20, 20);
    fill(255, 255, 255);
    text(less25Count+" or less connections", 48, 230);
    text("Arrow keys to pan", 20, 255);
    text("\"C\" to clear edge highlights", 20, 270);
  }
  else
  {
    /*background(0, 0, 0);
    fill(255, 255, 255);
    rect(width/2-200, height/2-100, 400, 200);
    textSize(20);
    textAlign(CENTER);
    fill(0, 0, 0);
    text("Load file", width/2, height/2);*/
    
    if(loadCorrectFile)
    {
      smooth();
      fill(255, 0, 0);
      textSize(20);
      textAlign(CENTER);
      smooth();
      text("Please choose a correctly formatted XML file.", width/2, height/2-300);  
    }
    
    smooth();
    fill(0, 0, 0);
    textSize(30);
    textAlign(CENTER);
    text("Network Visualiser", width/2, height/2-200);
    
    update(mouseX, mouseY);
    
    if (rectOver) {
      fill(rectHighlight);
    } else {
      fill(rectColor);
    }
    stroke(255);
    rect(rectX, rectY+50, rectSize, rectSize/2);
    fill(255, 255, 255);
    textSize(15);
    textAlign(CENTER);
    text("Click to load file", width/2, height/2+5);
  
    
  }
}


