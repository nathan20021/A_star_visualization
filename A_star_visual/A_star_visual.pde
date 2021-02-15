int grid_size = 20;
ArrayList<Node> closedList = new ArrayList<Node>();
ArrayList<Node> openList = new ArrayList<Node>();
int scale;
Node current;
Node[][] matrix = new Node[grid_size][grid_size];
PVector origin = new PVector(0,0);
PVector hover = new PVector(-1,-1);
PVector start = new PVector(15,15);
PVector end = new PVector(0,0);
int lowest = 0;
int lowestIndex = 0;
boolean drawing_wall = true;
ArrayList<Node> path = new ArrayList<Node>();
ArrayList<Integer> low = new ArrayList<Integer>();

int calc_d(Node node, PVector end){
  int d=0;
  int delta_x = (int) Math.abs(node.x-end.x);
  int delta_y = (int) Math.abs(node.y-end.y);
  d = 14*min(delta_x, delta_y);
  d += (max(delta_x, delta_y)-min(delta_x, delta_y)) *10;
  return d;
}


void trace(Node end){
  Node child = end;
  println(end.parent.x+" "+end.parent.y);
  while(true){ 
    Node parent_node = child.parent;
    path.add(parent_node);
    child = matrix[parent_node.x][parent_node.y];
    println(parent_node.parent);
    parent_node = child.parent;
    println(parent_node.x+" "+parent_node.y);
    if(parent_node.x == start.x&&parent_node.y==start.y){
     break; 
    }
  }
  path.add(matrix[(int)start.x][(int)start.y]);
}
void setup(){
  size(1000,1000);
  scale = width/grid_size;
  //frameRate(5);
  for(int i = 0; i<matrix.length; i++){
   for(int j = 0; j<matrix[i].length;j++){
     matrix[i][j] = new Node(i,j);
     if(i==start.x&&j==start.y){
      openList.add(matrix[i][j]); 
     }
   }
  }
  
  matrix[(int)start.x][(int)start.y].setStart();
  matrix[(int)start.x][(int)start.y].f_cost = calc_d(matrix[(int)start.x][(int)start.y], end);
  openList.add(matrix[(int)start.x][(int)start.y]);
  matrix[(int)start.x][(int)start.y].open = true;
  matrix[(int)end.x][(int)end.y].setEnd();
  
}

void draw(){
  if(drawing_wall){
    matrix[(int)start.x][(int)start.y].setStart();
    matrix[(int)end.x][(int)end.y].setEnd();
    hover.x = (int)mouseX/scale;
    hover.y = (int)mouseY/scale;
    for(Node[] nodeArray:matrix){
     for(Node node:nodeArray){   
       node.show(origin,scale);
     }
    }   
  }else{
    //Calculate the position of the hovering mouse
    if(openList.size()>0){
      lowest = openList.get(0).f_cost;
      lowestIndex = 0;
      //loop through openList<> to find the lowest f_cost
      for(int i = 0; i<openList.size();i++){
        Node node = openList.get(i);
        node.f_cost = calc_d(node, start)+calc_d(node, end);
        if(node.f_cost<lowest){
          lowest = node.f_cost;
          lowestIndex = i;
        }
      }
      //loop through again to pull out all the lowest f_cost into  low<>
      for(int i = 0; i<openList.size();i++){
        Node node = openList.get(i);
        println(node.f_cost);
        if(node.f_cost==lowest){
          node.h_cost = calc_d(node, end);
          low.add(i);
        }
      }
      
      int lowest_h = openList.get(low.get(0)).h_cost;
      for(int index:low){
       Node lowest_f_cost = openList.get(index);
       if(lowest_f_cost.h_cost<lowest_h){
         lowestIndex = index;
       }
      }
      
      current = openList.get(lowestIndex);
      low.clear();
      openList.remove(current);
      current.open = false;
      closedList.add(current);
      current.close = true;
      //println("CURRENT: "+current.x+" "+current.y);
      
      for(int a = current.x-1; a<= current.x+1; a++){
        for(int b = current.y-1; b<=current.y+1;b++){
         if(a>=0 && a<grid_size && b>=0 &&b<grid_size){
           if(a==current.x&&b==current.y){
            continue; 
           }
           if(matrix[a][b].wall){
             continue;
           }
          if(a==current.x || b==current.y){
             Node neighbor = matrix[a][b];
             //println("NEIGHBOR: "+neighbor.x+" "+neighbor.y);
  
  
             if(neighbor.x==end.x && neighbor.y==end.y){
               matrix[(int)end.x][(int)end.y].set_parent(current.x, current.y);
               trace(matrix[(int)end.x][(int)end.y]);
               for(Node node:path){
                 matrix[node.x][node.y].setPath();
                matrix[node.x][node.y].show(origin, scale); 
               }
              noLoop(); 
              println("FOUND");
             }
             int tentative_g_cost = calc_d(current, start) +calc_d(current, new PVector(neighbor.x, neighbor.y));
             //println(tentative_g_cost<=calc_d(neighbor, start));
             if(tentative_g_cost<calc_d(neighbor, start) || (!neighbor.open && !neighbor.close) ){
                neighbor.set_parent(current.x, current.y); 
                neighbor.g_cost = tentative_g_cost;
                neighbor.f_cost = calc_d(neighbor, start)+calc_d(neighbor, end);
                if(neighbor.open == false){
                 openList.add(neighbor);
                 neighbor.open = true;
                 neighbor.close = false;
                }
             }
             }
           }
          }
        }
      for(Node[] nodeArray:matrix){
       for(Node node:nodeArray){   
         fill(230, 218, 221);
         node.show(origin,scale);
       }
      }
    }else if(openList.size() == 0){
     noLoop(); 
     println("No path");
    }
  }
}

void mouseClicked(){
  if(drawing_wall){
    hover.x = (int)mouseX/scale;
    hover.y = (int)mouseY/scale;
    for(Node[] nodeArray:matrix){
     for(Node node:nodeArray){
       if(node.x == hover.x && node.y == hover.y){
         if(node.wall == false){
          node.wall = true; 
         }else{
          node.wall = false; 
         }
       }
     }
    }
  }
}


void keyPressed(){
 if(key =='f'){
  drawing_wall = false; 
 }
  
}
