class Node{
  
 int x, y, f_cost, g_cost, h_cost;
 Node parent;
 boolean wall = false;
 boolean start = false;
 boolean end = false;
 boolean open = false;
 boolean close = false;
 boolean current = false;
 boolean path = false;
 
 Node(int x, int y){
   this.x = x;
   this.y = y;
   this.f_cost = 0;
   this.g_cost = 0;
   this.h_cost = 0;
 }
 
 public void show(PVector origin, float scale){
   fill(230, 218, 221);
   if(this.path){
     fill(219, 215, 79);
   }else if(this.wall == true&&(this.start == false||this.end == false)){
    fill(10,10,10); 
   }else if(this.start||this.end){
    fill(0,255,0); 
   }else if(this.open){
     fill(0,255,255);
   }else if(this.close){
     fill(219, 64, 110);
   }
   stroke(0);
   strokeWeight(0.5);
   rect(origin.x+(scale*this.x), origin.y+(scale*this.y), scale, scale);
 }
 
 public void set_parent(int x, int y){
   this.parent = new Node(x,y);
 }
 
 public void setStart(){
   this.start = true;
   this.wall = false;
   this.end = false;
 }
 public void setEnd(){
   this.start = false;
   this.wall = false;
   this.end = true;
 }
 
 void setPath(){
   this.path = true;
 }
}
