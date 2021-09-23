class Bullet extends GraphicObject{
  
  
  
  
  int id;
  float speed = 5;
  float shipSize;
  
  boolean isVisible = false;
  
  color c = color(51, 204, 255);
  
  float diameterBullet = 3;
  float radiusBullet = diameterBullet/2;
  
  
  //location du vaisseau, heading du vaisseau, size du vaisseau
  public Bullet(int id, PVector location, float heading, float size){
    this.id = id;
    this.location = location;
    this.heading = heading;
    this.shipSize = size; 
    
  }
  
  void setLocation(){  
    //println(location);
    this.location.x = cos(heading-HALF_PI) * shipSize + location.x;
    this.location.y = sin(heading-HALF_PI) * shipSize + location.y;
    //println("AFTER SET: " + this.location);
  }
  
  void setDirection(){    
   velocity = PVector.fromAngle(heading - HALF_PI).mult(speed);
  }
  
   void activate() {
    isVisible = true;
  }
  
  

  void update(int id){
    location.add(velocity);
    //println("UPDATE de la bullet " + id + "    LOCATION: " + location + "    Visibility: " + isVisible);
    
    
    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) {
      isVisible = false;
    }
  }
  
  @Override
  void display(){
   
    if (isVisible) {
      pushMatrix();
        translate (location.x, location.y);
        fill(c);
        circle (0, 0, diameterBullet);
      popMatrix();
    }    
  }    
}
