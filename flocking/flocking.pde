PImage birdSpritesheet;

Bird bird;

void setup() {
  size(400, 400, P3D);
  birdSpritesheet = loadImage("bird_sprite.png");
  bird = new Bird(new Sprite(birdSpritesheet), new PVector(300, 300));
}

int previousMillis;

void draw() {
  // Calculate delta time since last frame
  int millisElapsed = millis() - previousMillis;
  float secondsElapsed = millisElapsed / 1000f;
  previousMillis = millis();
  
  background(123, 216, 237);
  
  bird.update(secondsElapsed);
  bird.draw();
}
