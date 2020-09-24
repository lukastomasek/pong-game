
enum GameState {
  START, PLAYING, GAMEOVER
};

float w = 30;
float h = 70;
float xPos;
float yPos;
float xPos2;
float yPos2;


int startCounter;
int done = 50;

String time = "50";
int timer = 0;
// actual timer count
int interval = 30;
// keep track of millis to reset it
float millis;
float startTime;
int scoreCount1, scoreCount2;

int bWidth, bHeight;
float ballSpeed = 3f;
float xBPos, yBPos;
int xBDir = 1;
int yBDir = 1;

Boolean isKeyDownOne = false;
Boolean isKeyUpOne = false;
Boolean isKeyUpTwo = false;
Boolean isKeyDownTwo = false;
Boolean playerLScored = false;
Boolean playerRScored = false;
Boolean paused = false;
Boolean restared = false;
Boolean collided = false;

GameState gameState;

float rBtnX, rBtnY;
float rBtnW, rBtnH;

float speed = 8;

float boundY;

PImage playerOne;
PImage playerTwo;
PImage bg;
PImage ball;
PImage panel;

PFont txtFont;

Button restartBtn;
Button quitBtn;



void setup() {
  size(720, 500);
  // keep track of millis
  startTime= millis();

  txtFont = createFont("Sportsball.ttf", 32);

  textFont(txtFont);

  if (!restared) {
    gameState = GameState.START;
  } else {
    gameState = GameState.PLAYING;
    interval+= 20;
  }
  loop();

  textAlign(CENTER, CENTER);
  rBtnX = width/2;
  rBtnY = height/2;
  rBtnW = 350;
  rBtnH = 80;

  surface.setTitle("Hockey Pong Game");
  scoreCount1 = 0;
  scoreCount2 = 0;
  bWidth = 50;
  bHeight = 50;

  restartBtn =  new Button("RESTART", width/2 + 50, height/2- 20, 100, 50);
  quitBtn = new Button("QUIT", width/2 - 150, height/2 -20, 100, 50);
  playerOne = loadImage("player_one.png");
  playerTwo = loadImage("player_two.png");
  ball  = loadImage("ball.png");
  bg = loadImage("stadium_2.png");
  panel = loadImage("hockey panel.png");

  bg.resize(720, 500);
  ball.resize(bWidth, bWidth);
  playerOne.resize(70, 70);
  playerTwo.resize(70, 70);

  xPos = (width/2) - 220;
  yPos = height/2;

  xPos2 = (width/2) + 150;
  yPos2 = height/2;

  xBPos = (width/2) - 20;
  yBPos = (height/2) - 20;

  boundY = height;
}
void enableButtons() {
  quitBtn.Draw();
  restartBtn.Draw();
}

void showWinTxt() {
  String txt = "";
  textSize(20);
  if (scoreCount1 > scoreCount2) {
    txt = "YOU WON !";
    fill(36, 48, 255);
  } else if (scoreCount1 < scoreCount2) {
    txt = "PLAYER TWO WON !";
    fill(255, 0, 0);
  } else if (scoreCount1 == scoreCount2) {
    txt = "DRAW !";
    fill(41, 240, 18);
  }

  textAlign(CENTER, CENTER);
  text(txt, width/2 - 10, height/2 - 50);
}

void draw() {
  background(bg);
  millis = millis();
  image(playerOne, xPos, yPos);
  image(playerTwo, xPos2, yPos2);
  image(ball, xBPos, yBPos);
  input();
  moveBall();
  checkBounds();
  collideWithPlayers();
  countScore();
  gui();

  //=========================================================================
  // GAME STATES
  //=========================================================================
  if (gameState == GameState.START) {
    background(0);
    thread("loadingScreen");
    delay(100);
  } else if (gameState == GameState.PLAYING) {
    loop();
  } else if (gameState == GameState.GAMEOVER) {
    enableButtons();
    showWinTxt();
    disableInp();
    // reset millis to start time
    millis = startTime;
  }
}
void simpleDelay(float t) {

  while (t>= 0) {
    t --;
  }

  if (t <= 0) {
    collided = false;
  }
}

//========================================================
// SHOW START SCREEN FOR THE FIRST TIME PROGRAM STARTS
//=======================================================

void loadingScreen() {
  while (startCounter < done) {
    delay(150);
    startCounter++;
    if (startCounter == done) {
      rect(width/2 - 150, height/2 - 20, 300, 20);
      gameState = GameState.PLAYING;
      break;
    }

    textSize(12);
    fill(255);
    text("LOADING", width/2, height/2 - 40);
    fill(134, 136, 138);
    rect(width/2 - 150, height/2 - 20, 300, 20);
    fill(255);
    rect(width/2 - 150, height/2 - 20, startCounter * 10/2, 20);
  }
}

void moveBall() {
  xBPos += ballSpeed * xBDir;
  yBPos += ballSpeed * yBDir;
  if (xBPos > width - 85 || xBPos < 85) {
    xBDir *= -1;
  }
  if (yBPos > height - 85 || yBPos < 85) {
    yBDir *= -1;
  }
}

void collideWithPlayers() {
  if (xPos > xBPos - bWidth
    && xPos < xBPos + bWidth
    && yPos > yBPos - bHeight
    && yPos < yBPos + bHeight) {
    xBDir *= -1;
    ballSpeed = random(ballSpeed, 4);
    collided = true;
    return;
  } else if (xPos2 > xBPos - bWidth - 5
    && xPos2 < xBPos + bWidth + 5
    && yPos2 > yBPos - bHeight -5
    && yPos2 < yBPos + bHeight + 5) {
    xBDir *= -1;
    ballSpeed = random(ballSpeed, 4);
    return;
  }
}

void countScore() {

  if (xBPos < xPos - 40 && !playerLScored) {
    playerRScored = true;
    // preventing from increasing count multiple times
    xBPos = (width/2) - 20;
    return;
  } 

  if (xBPos > xPos2 + 40 && !playerRScored ) {
    playerLScored = true;
    // preventing from increasing count multiple times
    xBPos = (width/2) -20;
    return;
  }
}


void gui() {
  if (playerLScored) {
    fill(255, 0, 0);
  } 

  image(panel, width/2 - 175, height/2 - panel.height - 180);
  circle(width/2 - 95, height/2 - 210, 20);

  noStroke();


  if (playerRScored) {
    fill(255, 0, 0);
  }
  circle(width/2 + 95, height/2 - 210, 20);

  if (playerLScored) {
    scoreCount1++;
    playerLScored = false;
  } else if (playerRScored) {
    scoreCount2++;
    playerRScored = false;
  }
  textSize(24);
  // count down
  // add startime for the second round
  timer = interval-int(millis/1000) + int(startTime/1000);
  time = nf(timer, 2);

  fill(255);
  text(time, (width/2) - 5, (height/2) - 225);
  text(scoreCount1, (width/2) - 135, (height/2) - 225);
  text(scoreCount2, (width/2) + 135, (height/2) - 225);
  textSize(40);

  if (timer == 0) {
    gameState = GameState.GAMEOVER;
    interval = 10;
    // timer = interval-int(millis()/1000);
    timer = 0;
    time = "0";
    millis = startTime;
  }
}

void input() {

  if (isKeyDownOne) {
    yPos -=  speed;
  }
  if (isKeyUpOne) {
    yPos += speed;
  }

  if (isKeyUpTwo) {
    yPos2 += speed;
  }

  if (isKeyDownTwo) {
    yPos2 -= speed;
  }
}

void checkBounds() {
  if (yPos >= boundY - h - 35) {
    float result = boundY - h - 35;
    yPos = result;
  } else if (yPos <= 35) {
    float result = 35;
    yPos = result;
  }
  if (yPos2 >= boundY - h - 35) {
    float result = boundY - h - 35;
    yPos2 = result;
  } else if (yPos2 <= 35) {
    float result = 35;
    yPos2 = result;
  }
}

void keyPressed() {

  if (key == 'w') {
    isKeyDownOne = true;
  }
  if (key == 's') {
    isKeyUpOne = true;
  }

  // arrow input
  if (keyCode == UP) {
    isKeyDownTwo = true;
  }
  if (keyCode == DOWN) {
    isKeyUpTwo = true;
  }
}

void keyReleased() {
  if (key == 'w') {
    isKeyDownOne = false;
  }
  if (key == 's') {
    isKeyUpOne = false;
  }
  // arrow input
  if (keyCode == UP) {
    isKeyDownTwo = false;
  }
  if (keyCode == DOWN) {
    isKeyUpTwo = false;
  }
}

void mousePressed() {

  if (restartBtn.MouseIsOver()) {
    restared = true;
    fill(47, 77, 255);
    setup();
  }

  if (quitBtn.MouseIsOver()) {
    exit();
  }
}

void disableInp() {
  noLoop();
}

//=============================================================
// BUTTON CLASS
//=============================================================
class Button {
  String label; // button label
  float x;      // top left corner x position
  float y;      // top left corner y position
  float w;      // width of button
  float h;      // height of button

  // constructor
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }

  void Draw() {

    if (MouseIsOver()) {
      fill(47, 77, 255);
    } else {    
      fill(55, 141, 255);
    }
    stroke(255);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    textSize(12);
    fill(255);
    text(label, x + (w / 2), y + (h / 2));
  }

  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}
