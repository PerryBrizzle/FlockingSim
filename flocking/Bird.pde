class Bird {
  Sprite sprite;
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float maxSpeed = 200;
  
  public Bird(Sprite _sprite, PVector _position) {
    this.sprite = _sprite;
    this.position = _position;
    this.velocity = new PVector(0,0);
    this.acceleration = new PVector(0,0);
  }
  
  public void update(float secondsElapsed) {
    sprite.updateAnimation(secondsElapsed);
    
    calculateAcceleration();
    
    
    
    
    // Acceleration changes our velocity
    velocity.add(PVector.mult(acceleration, secondsElapsed));
    
    // Limit velocity
    if (velocity.mag() > maxSpeed) {
      velocity.setMag(maxSpeed);
    }
    
    // Velocity changes our position
    position.add(PVector.mult(velocity, secondsElapsed));
  }
  
  public void calculateAcceleration() {
    // Calculate accerleration
    acceleration.set(0,0);
    
    // Steer towards mouse position
    PVector vectorToTarget = new PVector(mouseX, mouseY).sub(position);
    PVector accelerationTowardsTarget = vectorToTarget.setMag(250);
    acceleration.add(accelerationTowardsTarget);
    
    // Seperation - avoid neighbouring birds
    
  }
  
  public void draw() {
    pushMatrix();
      translate(position.x, position.y);
      
      float angle = atan2(velocity.y, velocity.x);
      rotate(angle);
      sprite.draw();
    popMatrix();
  }
}
