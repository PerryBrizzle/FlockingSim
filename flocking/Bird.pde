class Bird {
  // Visual sprite
  Sprite sprite;
  
  // Physics/state stuff
  PVector position;
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  
  // Most recent flocking forces
  PVector separationForce = new PVector(0, 0);
  PVector alignmentForce = new PVector(0, 0);
  
  // Debugging flag
  boolean isBirdZero;
  
  public Bird(Sprite _sprite, PVector _position) {
    this.sprite = _sprite;
    this.position = _position;
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
    
    // Wrap birds around the grid
    if (position.x > width) { position.x -= width; }
    else if (position.x < 0) { position.x += width; }
    
    if (position.y > height) { position.y -= height; }
    else if (position.y < 0) { position.y += height; }
  }
  
  public void calculateAcceleration(ArrayList<Bird> allBirds) {
    // Calculate acceleration
    acceleration.set(0,0);
    
    
    // Steer towards mouse position
    PVector target = mousePressed ? new PVector(mouseX, mouseY) : new PVector (width/2, height/2);
    PVector vectorToTarget = target.sub(position);
    PVector accelerationTowardsTarget = vectorToTarget.setMag(BIRD_MOUSE_FOLLOW_STRENGTH);
    acceleration.add(accelerationTowardsTarget);
    
    
    // Seperation - avoid neighbouring birds
    separationForce.set(0, 0);
    for (Bird otherBird : allBirds) {
      
      // Don't compare a bird with itself
      if (otherBird == this) continue;
      
      PVector vectorToOtherBird = PVector.sub(otherBird.position, position);
      float squareDistanceToOtherBird = vectorToOtherBird.magSq();
      
      // Too far away - ignore
      if (squareDistanceToOtherBird > BIRD_SEPARATION_RADIUS*BIRD_SEPARATION_RADIUS) continue;
      
      // Repel from other bird
      separationForce.add(vectorToOtherBird.setMag(-BIRD_SEPARATION_STRENGTH));
      acceleration.add(separationForce);
    }
    
    
    // Alignment - move in same direction as neighbouring birds
    
    alignmentForce.set(0, 0);
    PVector averageVelocityOfNeighbours = new PVector(0, 0);
    int alignmentNeighbourCount = 0;
    
    for (Bird otherBird : allBirds) {
      
      // Don't compare a bird with itself
      if (otherBird == this) continue;
      
      PVector vectorToOtherBird = PVector.sub(otherBird.position, position);
      float squareDistanceToOtherBird = vectorToOtherBird.magSq();
      
      // Too far away - ignore
      if (squareDistanceToOtherBird > BIRD_ALIGNMENT_RADIUS*BIRD_ALIGNMENT_RADIUS) continue;
      
      // Accumulate average heading
      ++alignmentNeighbourCount;
      averageVelocityOfNeighbours.add(otherBird.velocity);
    }
    
    if (alignmentNeighbourCount > 0) {
      averageVelocityOfNeighbours.mult(1f / alignmentNeighbourCount);
      alignmentForce.set(averageVelocityOfNeighbours.setMag(BIRD_ALIGNMENT_STRENGTH));
      acceleration.add(alignmentForce);
    }
  }
  
  public void draw(boolean debugDraw) {
    pushMatrix();
      translate(position.x, position.y);
      
      if (debugDraw) {
        noFill();
        
        // Separation
        stroke(255, 0, 0);
        ellipse(0, 0, BIRD_SEPARATION_RADIUS*2, BIRD_SEPARATION_RADIUS*2);
        line(0, 0, separationForce.x, separationForce.y);
        
        // Alignment
        stroke(255, 255, 0);
        ellipse(0, 0, BIRD_ALIGNMENT_RADIUS*2, BIRD_ALIGNMENT_RADIUS*2);
        line(0, 0, alignmentForce.x, alignmentForce.y);
      }
      
      float angle = atan2(velocity.y, velocity.x);
      rotate(angle);
      sprite.draw();
    popMatrix();
  }
}
