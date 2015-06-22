class Person extends Node{
  
  private int connections;
  
  public Person(Node n, String l)
  {
    super(l);
    this.connections = n.connections;   
  }

  void getConnections(Node n)
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
  
}
