
Vertex[] matrix = new Vertex[16];
PVector matrixPos;
float matrixSize = 260; 

StringList twoAddresses = new StringList(); 
StringList nAddresses = new StringList(); 



void setup(){
 background(255); 
 size(900, 900); 
 //fullScreen(); 
 
 rectMode(CENTER);

 matrixPos = new PVector(width/2 - 200, height/2 + 250); 
 
 for(int i = 0; i < matrix.length; i++){
   matrix[i] = new Vertex(); 
   matrix[i].type = "Button"; 
   matrix[i].MoveType = "Fixed"; 
   matrix[i].size = new PVector(60, 60); 
   matrix[i].selected = floor(random(0, 2)) == 0; 
 }
 
 int count = 0;
  
 for(int i = 0; i < 4; i++){
   float mx = map(i, 0, 4, matrixPos.x - matrixSize/2, 
                           matrixPos.x + matrixSize/2); 
                           
   for(int j = 0; j < 4; j++){
   float my = map(j, 0, 4, matrixPos.y - matrixSize/2, 
                           matrixPos.y + matrixSize/2);
                           
     matrix[count % 16].position = new PVector(mx, my);
     matrix[count % 16].name = str(i) + str(j);
     count++; 
     
     nAddresses.append(str(i) + str(j)); 
   }
 }
 
}

void draw(){ // *********************************************** DRAW
  background(255); 
  twoAddresses.clear();
   
  for(int i = 0; i < matrix.length; i++){
   matrix[i].run();  
   if(matrix[i].selected){
    twoAddresses.append(matrix[i].name);  
   }
  }
  
  for(String s: popString(twoAddresses, 8)){// change the 6 to whatever you want for better quality (this does not affect the dimension calculation)
    square P0 = new square(new PVector(width/2 - 20, height/2 - 200), 450, "");
    //square P1 = new square(new PVector(width/2 + 200, height/2 - 180), 250*sqrt(3), "");
    f(P0, s);  
    //g(P1, s);
  } 
  
  
  pushStyle();
    fill(255, 153, 153); 
    text(0, width/2 - 260, height/2 + 40); 
    text(1, width/2 + 205, height/2 + 40); 
    text(2, width/2 + 210, height/2 - 425); 
    text(3, width/2 - 260, height/2 - 425);
    
    stroke(153, 153, 255); 
    strokeWeight(3); 
    line(width/2 - 245, height/2 + 25, width/2 + 205, height/2 + 25); 
    line(width/2 + 205, height/2 + 25, width/2 + 205, height/2 - 425); 
    line(width/2 + 205, height/2 - 425, width/2 - 245, height/2 - 425); 
    line(width/2 - 245, height/2 - 425, width/2 - 245, height/2 + 25); 
  popStyle(); 
  
 PVector DIM = dim(twoAddresses, nAddresses); 
 
 text("log(N(r)) = " + DIM.x + " log(1/r) + " + DIM.y, matrixPos.x, matrixPos.y + 150); 
 

 if(keyPressed) saveStrings("test.txt", exportState()); 
 
 //displayExponent(); 
}  

String reversify(String k){
  String k1 = new StringBuilder(k).reverse().toString();
  //println(k + " -> " + k1);
  
  return k1;
}

String[] exportState(){
  String[] states = new String[twoAddresses.size() + 9];
  
  for(int i = 0; i <states.length; i++){
    if(i < twoAddresses.size()) states[i] = twoAddresses.get(i); 
    if(i == twoAddresses.size()) states[i] = ":";
    if(i > twoAddresses.size()) states[i] = "" + popString(twoAddresses, i -twoAddresses.size()).size(); 
  }
  return states; 
}

void displayExponent(){
  pushStyle();
  stroke(0); 
  strokeWeight(3); 
  PVector origin = new PVector(matrixPos.x + matrixSize/2, matrixPos.y + matrixSize/3); 
   line(origin.x, origin.y, origin.x, origin.y - .8*matrixSize); 
   line(origin.x, origin.y, origin.x + 1.5*matrixSize, origin.y); 
   
   int[] dataPoints = new int[10]; 
   int maximum = 0; 
   
   for(int i = 0; i < dataPoints.length; i++){
    dataPoints[i] = popString(twoAddresses, i).size();  
    
    if( dataPoints[i] >= maximum) maximum = dataPoints[i]; 
   }
   
   fill(255, 153, 153); 
   noStroke(); 
   
   for(int i = 0; i < dataPoints.length; i++){
     float x = map(i, 0, dataPoints.length, origin.x, origin.x + 1.5*matrixSize); 
     float y = map(dataPoints[i], 0, maximum, origin.y, origin.y - .8*matrixSize); 
     
     ellipse(x, y, 10, 10); 
   }
   
   PVector P1 = new PVector(dataPoints[1], 1); 
   PVector P2 = new PVector(dataPoints[2], 2); 
   
   float b = log(P1.y / P2.y) / (log(2) * (P1.x - P2.x)); 
   float a = P1.y / (pow(2, b*P1.x)); 
   
   fill(0); 
   text("f(x) = (" + a +") 2^("+ b +"x)", origin.x +50, origin.y +25); 
   
  popStyle(); 
}

PVector dim(StringList A0, StringList C0){  // *********************************************** DIMENSION
  PVector result = new PVector(0, 0); 
  StringList Attractor = A0; 
  
  Attractor = popString(Attractor, 4); 
  
  int N1 = Attractor.size(); 
  
  Attractor = A0;  
  Attractor = popString(Attractor, 5); 
  
  int N2 = Attractor.size(); 
  
  float dr = -4*log(2) + 5*log(2); 
  float dN = log(N1) - log(N2); 
  
  result.x = abs(dN/dr); 
  result.y = log(N2) + result.x*5*log(2); 
  
  return  result;
}

// *********************************************** POP STRING

StringList popString(StringList S1, int n){
 StringList S0 = new StringList(); 
 StringList temp = new StringList();
 
 String[] AS1 = new String[S1.size()];
 for(int h = 0; h < AS1.length; h++){
   AS1[h] = S1.get(h);
   S0.append(AS1[h]);
 }
 
 for(int k = 0; k < n; k++){  
  temp.clear();
   
   for(int i = 0; i < S0.size(); i++){
     String s = S0.get(i); 
     
     for(int j = 0; j < AS1.length; j++){
       String q = AS1[j]; 
       
       if(q.charAt(q.length() -2) == s.charAt(s.length() -1)){
         temp.append(s + (q.charAt(q.length() -1)));
       }
     }
   } 
   
   S0.clear(); 
   for(String p: temp) S0.append(p); 
 }
  
 return S0; 
}

void f(square S1, String N){ // *********************************************** IFS STATES, FAMILY
     square S0 = S1; 
     
     int dirX = 1; 
     int dirY = 1; 
     
     for(int i = N.length()-1; i > 1; i--){
       char q = N.charAt(i); 
       
       if(q == '0'){ dirX = -1; dirY = +1; }
       if(q == '1'){ dirX = +1; dirY = +1; }
       if(q == '2'){ dirX = +1; dirY = -1; }
       if(q == '3'){ dirX = -1; dirY = -1; }
       
       S0.size /= 2; 
       S0.pos.x = S0.pos.x + (dirX * S0.size *.5);
       S0.pos.y = S0.pos.y + (dirY * S0.size *.5);
     }
     S0.disp(); 
}

void g(square S1, String N){ // *********************************************** IFS STATES, FAMILY
     square S0 = S1; 
     float theta = 0; 
     
     float dirX = 1; 
     float dirY = 1; 
     
     for(int i = 2; i < N.length(); i++){
       char q = N.charAt(i); 
       //println(theta); 
       
       if(q == '0'){ dirX = 0; dirY = 0; theta += 60; }
       if(q == '1'){ dirX = cos(radians(-330 + theta)); dirY = sin(radians(-330 + theta));}
       if(q == '2'){ dirX = cos(radians(-210 + theta)); dirY = sin(radians(-210 + theta));}
       if(q == '3'){ dirX = cos(radians(-90 + theta)); dirY = sin(radians(-90 + theta));}
       
       S0.size /= 2; 
       S0.pos.x = S0.pos.x + (dirX * S0.size *.5);
       S0.pos.y = S0.pos.y + (dirY * S0.size *.5);
     }
     
     S0.disp(); 
}

class square{ // *********************************************** SQUARE CLASS
  PVector pos; 
  float size; 
  String name; 
  
  square(){
   pos = new PVector(0, 0); 
   size = 0;
   name = "";  
  }
  
  square(PVector P0, float L, String N){
    pos = P0; 
    size = L;
    name = N; 
  }
  
  void disp(){
   fill(0, 200);
   noStroke(); 
   rect(pos.x, pos.y, size, size);
  }
}

void mousePressed(){
  for(Vertex v: matrix){
   v.pressed();  
  }
}

void mouseReleased(){
  for(Vertex v: matrix){
   v.released();  
  }
}

void keyPressed(){  
  for(Vertex V0: matrix) V0.selected = (0 == floor(random(0, 2)));  
}

PVector mobiusTransform(PVector P0, PVector P1,  float a){
  PVector P2 = PVector.sub(P0, P1); 
  float r = mag(P2.x, P2.y);
  float newr = pow(a/2, 2) / r; 
  
  P2.normalize(); 
  P2.mult(-newr);
  P2.add(P0); 
 
  return P2; 
}