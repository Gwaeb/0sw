abstract class GraphicObject{
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float heading = 0.0;
  
  color fillColor = color (255);
  color strokeColor = color (255);
  float strokeWeight = 1;
  
  
  boolean isCollidingHitbox(float radius1, PVector location1, float radius2, PVector location2) {
    
    float distance = PVector.dist(location1, location2);
    
    if ((radius1 + radius2) >= distance) {
      return true;
    }
    
    
    return false;
  }
  
  abstract void display();
  

}
