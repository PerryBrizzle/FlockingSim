class Bird {
  Sprite sprite;
  PVector position;
  
  public Bird(Sprite _sprite, PVector _position) {
    this.sprite = _sprite;
    this.position = _position;
  }
  
  public void update(float secondElapsed) {
    sprite.updateAnimation(secondElapsed);
  }
  public void draw() {
    pushMatrix();
      translate(position.x, position.y);
      sprite.draw();
    popMatrix();
  }
}
