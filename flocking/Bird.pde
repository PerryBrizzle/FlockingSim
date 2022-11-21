class Bird {
  Sprite sprite;
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  boolean isBirdZero;
  
  public Bird(Sprite _sprite, PVector _position) {
    this.sprite = _sprite;
    this.position = _position;
    this.velocity = new PVector(0,0);
    this.acceleration = new PVector(0,0);
  }
  
  public void update(float secondsElapsed, ArrayList<Bird> allBirds) {
    sprite.updateAnimation(secondsElapsed);
    
    calculateAcceleration(allBirds);
        
    // Acceleration changes our velocity
    velocity.add(PVector.mult(acceleration, secondsElapsed));
    
    // Limit velocity
    if (velocity.magSq() > BIRD_MAX_SPEED*BIRD_MAX_SPEED) {
      velocity.setMag(BIRD_MAX_SPEED);
    }
    
    // Velocity changes our position
    position.add(PVector.mult(velocity, secondsElapsed));
  }
  
  public void calculateAcceleration(ArrayList<Bird> allBirds) {
    // Calculate acceleration
    acceleration.set(0,0);
    
    if (mousePressed) {
    // Steer towards mouse position
      PVector vectorToTarget = new PVector(mouseX, mouseY).sub(position);
      PVector accelerationTowardsTarget = vectorToTarget.setMag(BIRD_MOUSE_FOLLOW_STRENGTH);
      acceleration.add(accelerationTowardsTarget);
    }
    
    // Seperation - avoid neighbouring birds
    for (Bird otherBird : allBirds) {
      
      // Don't compare a bird with itself
      if (otherBird == this) continue;
      
      PVector vectorToOtherBird = PVector.sub(otherBird.position, position);
      float squareDistanceToOtherBird = vectorToOtherBird.magSq();
      
      // Too far away - ignore
      if (squareDistanceToOtherBird > BIRD_SEPARATION_RADIUS*BIRD_SEPARATION_RADIUS) continue;
      
      // Repel from other bird
      PVector separationForce = vectorToOtherBird.setMag(-BIRD_SEPARATION_STRENGTH);
      acceleration.add(separationForce);
    }
  }
  
  public void draw(boolean debugDraw) {
    pushMatrix();
      translate(position.x, position.y);
      
      if (debugDraw) {
        noFill();
        stroke(0, 255, 0);
        ellipse(0, 0, BIRD_SEPARATION_RADIUS*2, BIRD_SEPARATION_RADIUS*2);
      }
      
      float angle = atan2(velocity.y, velocity.x);
      rotate(angle);
      sprite.draw();
    popMatrix();
  }
}
