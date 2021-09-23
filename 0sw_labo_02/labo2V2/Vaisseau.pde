class Vaisseau extends GraphicObject {
  float angularVelocity = 0.0;
  float angularAcceleration = 0.0;
  
  float angle = 0.0;  
  
  
  float w = 20;
  float h = 10;
  
  float mass = 1.0;
  
  float speedLimit = 3;
  boolean thrusting = false;
  
  //Hitbox
  float diameterHitbox = 40;
  float radiusHitbox = diameterHitbox/2;
  
  int nbrLives = 3;
  
  boolean isDisplay = true;

  Vaisseau() {
    initValues();
  }
  
  void initValues() {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }
  
  void applyForce (PVector force) {
    PVector f;
    
    if (mass != 1)
      f = PVector.div (force, mass);
    else
      f = force;
   
    this.acceleration.add(f);
  }
  
  void checkEdges() {
    if (location.x < -size) location.x = width + size;
    if (location.y < -size) location.y = height + size;
    if (location.x > width + size) location.x = -size;
    if (location.y > height + size) location.y = -size;
  }
  
  void thrust(){
    float angle = heading - PI/2;
    
    PVector force = new PVector (cos(angle), sin(angle));
    force.mult(0.1);
    
    applyForce(force);
    
    thrusting = true;    
  }
  
  void update() {
    checkEdges();
    
    velocity.add(acceleration);
    
    velocity.limit(speedLimit);
    
    location.add(velocity);
    
    acceleration.mult(0);
    
    angularVelocity += angularAcceleration;
    angle += angularVelocity;
    
    angularAcceleration = 0.0;
  }
  
  float size = 20;
  
  void display() {
    if(isDisplay){
      pushMatrix();
        translate (location.x, location.y);
        rotate (heading);
        
        fill(200);
        noStroke();
        
        beginShape(TRIANGLES);        
          vertex(0, -size);
          vertex(size, size);
          vertex(-size, size);
        endShape();
       
        
        
        if (thrusting) {
          fill(200, 0, 0);
        }
        rect(-size + (size/4), size, size / 2, size / 2);
        rect(size - ((size/4) + size/2), size, size / 2, size / 2);
        
        //Hitbox
        stroke(255, 0, 127);
        fill(0,0,0,0);
        circle(0,0,diameterHitbox);
      popMatrix();
      //Point Orange
        //fill(200,100,0);
       // ellipse(cos(heading-HALF_PI) * size + location.x, sin(heading-HALF_PI) * size + location.y, 10,10);
    }
  }
  
  void pivote(float angle) {
    heading += angle;
  }
  
  void noThrust() {
    thrusting = false;
  }
}
