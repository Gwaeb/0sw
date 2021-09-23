import processing.sound.*;
SoundFile file;


int currentTime;
int previousTime;
int deltaTime;

static int contact = 1;

Vaisseau v;

ArrayList<Bullet> bullets;
int bulletId;

ArrayList<Mover> flock;
int flockSize = 20;

int lvl = 1;
boolean goNextlvl = false;
int score = 0;
boolean gainLife = false;


void setup () {
  size (1920, 1000);  
  reset();  
}

void draw () {
  update();
  display();   
}

PVector thrusters = new PVector(0, -0.02);

/***
  The calculations should go here
*/
void update() {
  for (Mover m : flock) {
    if(m.isDisplay == false){
      goNextlvl = true;
    }
    else{
      goNextlvl = false;
      break;
    }
  }
  
  if(goNextlvl){
    nextlvl();
  }
  
  for (Mover m : flock) {
    
    
    m.flock(flock);
    m.update();
    if(v.isCollidingHitbox(v.radiusHitbox,v.location,m.radiusHitbox,m.location) && m.isDisplay == true){
      println("YA EU CONTACT CAPITAINE!!! " + contact++);
      m.isDisplay = false;
      v.nbrLives--;
      
    }
  }
  if (keyPressed) {
    switch (key) {
      case ' ':
        v.thrust();
        break;
      case 'a':
        v.pivote(-.03);
        break;
      case 'd':
        v.pivote(.03);
        break;
      case 'w':
        currentTime = millis();
        if(deltaTime < currentTime){
          deltaTime +=1000;
          Bullet bTempo = new Bullet(bulletId, v.location.copy(), (v.heading), v.size);
          bulletId++;
          bTempo.setDirection();
          bTempo.setLocation();
          bTempo.activate();
          bullets.add(bTempo);
          file.play();
        }
        break;             
    }
    
  }
  
  v.update();
  if(score%10 == 0 && score != 0 && gainLife == false){
    v.nbrLives++;
    gainLife = true;    
  }
  for ( Bullet b : bullets) {
    b.update(b.id);
    for(Mover m : flock){    
      if(b.isCollidingHitbox(b.radiusBullet,b.location,m.radiusHitbox,m.location) && m.isDisplay == true){
        println("ET ÇA FAIT BIM BAM BOUM!!!");
        score++;
        m.isDisplay = false;
        b.isVisible = false;
        gainLife = false;
      }
    }
    if(b.isCollidingHitbox(b.radiusBullet,b.location,v.radiusHitbox,v.location) && b.isVisible == true){
        println("FRIENDLY FIRE CAPITAINE!!!!");
        v.nbrLives--;
        b.isVisible = false;
    }    
  }
  //println("");
}

/***
  The rendering should go here
*/
void display () {
  background(0);
  if(v.nbrLives <=0){
    v.nbrLives = 0;
  }
  
  if(v.nbrLives == 0){
    v.isDisplay = false;
    fill(255,0,0);
    textSize(40);
    textAlign(CENTER);
    text("You died! Press 'R' to restart", width/2, height/22);
    
  }
  else{
    //Affichage des données
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text("Lives: " + v.nbrLives, width/2 - 100, height - 30);
    text("LVL: " + lvl, width/2 , height - 30);
    text("Score: " + score, width/2 + 100 , height - 30);
    
    v.display();
    for ( Bullet b : bullets) {
      b.display();
    }
    
    for (Mover m : flock) {
      m.display();
    }
  }
  
  
  
  
  
}

void keyPressed(){
  switch (key) {
      case 'q':
        for (Mover m : flock) {
          m.debug = !flock.get(0).debug;
        }
        break;
    }
   
}

void keyReleased() {
    switch (key) {
      case ' ':
        v.noThrust();
        break;
      case 'r':
        reset();
        break;
    }  
}

void reset(){
  currentTime = millis();
  previousTime = millis();
  
  file.stop();
  
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  
  score = 0;
  lvl = 1;
  
  bullets = new ArrayList<Bullet>();
  bulletId = 1;
  
  file = new SoundFile(this, "pewpew.mp3");
  
  flock = new ArrayList<Mover>();
  flockSize =20;
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
    while(m.location.x <= (v.location.x + (v.size*10)) && m.location.x >= (v.location.x - (v.size*10)) && m.location.y <= (v.location.y + (v.size*10)) && m.location.y >= (v.location.y - (v.size*10))){
      m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
    }
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime; 
}

void nextlvl(){
  file.stop();
  lvl++;
  currentTime = millis();
  previousTime = millis();
  
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  
  bullets = new ArrayList<Bullet>();
  bulletId = 1;
  
  flock = new ArrayList<Mover>();
  flockSize +=5;
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(random(255), random(255), random(255));
    flock.add(m);
  }
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime; 
}
