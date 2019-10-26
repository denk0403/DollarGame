import processing.sound.*;
import java.util.*;

public static Node[] nodeList;
public static ArrayList<Edge> edgeList;
public static boolean allPositive = false;
public static boolean isWon = false;
SoundFile music;
SoundFile wonSound;
SoundFile clickSound;

void setup() {
  frameRate(60);
  size(800,800);
  music = new SoundFile(this, "Almost New.mp3");
  wonSound = new SoundFile(this, "Correct Answer Sound Effect.mp3");
  //clickSound = new SoundFile(this, "Simple bell sound effect.mp3");
  //clickSound.amp(0.5);
  createGame();
  music.play();
  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
}

void draw() {
  if (!music.isPlaying()) {
    music.play();
  }
  colorMode(RGB);
  background(255);
  textSize(15);
  fill(0);
  text("Game by: Dennis Kats", width-85, height-15);
  textSize(11);
  for (Edge edge : edgeList) {
    line(edge.nd1.x, edge.nd1.y, edge.nd2.x, edge.nd2.y);
  }
  allPositive = true;
  
  //draws circles
  for(Node node : nodeList) {
    if(node.money < 0) {
      allPositive = false;
      //stroke( (255 + (node.money * 9)) % 256, (255 + (node.money * 17)) % 256, (230 + (node.money * 15)) % 256);
      fill( (255 + (node.money * 9)) % 256, (255 + (node.money * 17)) % 256, (230 + (node.money * 15)) % 256);
    } else {
      //stroke( (255 - (node.money * 12)) % 256, 255, (230 - (node.money * 11)) % 256);
      fill( (255 - (node.money * 12)) % 256, 255, (230 - (node.money * 11)) % 256);
    }
    ellipse(node.x, node.y, 30, 30);
    //stroke(0);
    fill(0);
    text(node.money,node.x,node.y);
  }
  
  //Gameover screen
  if(allPositive) {
    if (!isWon) {
      wonSound.play();
    }
    isWon = true;
    fill(128, 192);
    rectMode(CORNER);
    rect(0, 0.375*height, width, height/4);
    fill(0,127,230);
    rectMode(CENTER);
    noStroke();
    rect(width/2, height*0.625-20, 100, 25,5);
    stroke(1);
    fill(255);
    textSize(15);
    text("Play Again?", width/2, height*0.625-22);
    textSize(150);
    colorMode(HSB);
    fill(frameCount%256, 255, 255);
    text("You Win!", width/2, height/2-35);
  }
}

//creates edges between Nodes
void formConnections(Node node) {
  double distance;
  here: while (true) {
    node.x = (int)random(width * 0.25, 0.75 * width);
    node.y = (int)random(height * 0.25, 0.75 * height);
    for (int i = 0; i < nodeList.length; i++) {
      Node other = nodeList[i];
      if (other != node && other.displayed == true) {
        distance = Math.sqrt( Math.pow((node.x-other.x),2) + Math.pow((node.y-other.y),2) );
        if (distance < 40) {
          continue here;
        }
        
        //for (Float angle: other.angles) {
        //  System.out.println("Node " + i + ": " + other.angles);
        //  if (node.x-other.x == 0.0) {
        //    continue here;
        //  }
        //  System.out.println(degrees((float)Math.atan( (other.y-node.y)/(node.x-other.x))));
        //  System.out.println(degrees(angle));
        //  delay(4000);
        //  if ( Math.abs(Math.abs(Math.atan( (other.y-node.y)/(node.x-other.x))) - angle) < radians(1)) {
        //    System.out.println("TOO CLOSE");
        //    for (int j = 0; j < i; j++) {
        //      nodeList[j].angles.remove(nodeList[j].angles.size()-1);
        //    }
        //    System.out.println("Node " + i + ": " + other.angles);
        //    continue here;
        //  }
        //}
        //float angle = Math.abs((float)Math.atan( (other.y-node.y)/(node.x-other.x)));
        //node.angles.add(angle);
        //other.angles.add(angle);
        
      }
    }
    break;
  }
  node.displayed = true;
  int j = 0;
  for (Node connected : node.connections) {
    if (connected.displayed == false) {
      formConnections(connected);
    } 
  }
}

//sets up Game
void createGame() {
  isWon = false;
  Node.total = 0;
  int nodeNum = (int)(random(5,12));
  //System.out.println("There are " + nodeNum + " nodes.");
 
  //creates graph storage
  nodeList = new Node[nodeNum];
  edgeList = new ArrayList<Edge>();
  
  int edgeNum = -1;
  while ( (edgeNum - nodeNum + 1) < 1) {
    edgeNum = (int)(random(nodeNum-1, nodeNum*(nodeNum-1)*0.5)); //gives edgeNum value between min and max # of edges
  }
  //edgeList = new Edge[edgeNum];
  int genus = edgeNum - nodeNum + 1;
  for (int i = 0; i < nodeNum; i++) {
      nodeList[i] = new Node((int)random((-nodeNum+1),-nodeNum/3)); // generates Random money //*add editor later
  }
  //System.out.println("There are " + edgeNum + " edges.");
  
  int edgeRemain = edgeNum;
  //initial connections
  for (int i = 0; i < nodeNum - 1; i++) {
      nodeList[i].connections.add(nodeList[i+1]);
      nodeList[i+1].connections.add(nodeList[i]);
      edgeList.add(new Edge(nodeList[i], nodeList[i+1]));
      edgeRemain--;
  }

  while (edgeRemain > 0) {
      int index1 = (int)(nodeNum * Math.random());
      int index2 = (int)(nodeNum * Math.random());
      if ( (index1 != index2) && !nodeList[index1].connections.contains(nodeList[index2]) ) {
          nodeList[index1].connections.add(nodeList[index2]);
          nodeList[index2].connections.add(nodeList[index1]);
          edgeList.add(new Edge(nodeList[index1], nodeList[index2]));
          edgeRemain--;
      } else {
          continue;
      }
  }
  
  while (Node.total < genus) {
    int index = (int)random(nodeNum/1.75);
    nodeList[index].money += 1;
    Node.total += 1;
  }
  formConnections(nodeList[0]);
  DisplayGUI GUI = new DisplayGUI("\nHelp everyone out of debt!\n\t There are " + nodeNum + " nodes\n\t     and " + edgeNum + " edges.");
}

//checks for mouse events
void mousePressed() {
  if (isWon && mouseX > width/2-50 && mouseX < width/2+50 && mouseY > height*0.625-44 && mouseY < height*0.625+4) {
    createGame();
  }
  for (Node node : nodeList) {
    if (Math.sqrt( Math.pow((node.x-mouseX),2) + Math.pow((node.y-mouseY),2) ) < 14) {
      //clickSound.play();
      node.money -= node.connections.size();
      strokeWeight(3);
      noFill();
      ellipse(node.x,node.y, 42,42);
      for (Node connection : node.connections) {
        connection.money++;
      }
    }
  }
  strokeWeight(1);
}
