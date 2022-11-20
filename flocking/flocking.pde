PImage birdSpritesheet;

ArrayList<Bird> birds = new ArrayList<>();

void setup() {
  size(600, 600, P3D);
  
  birdSpritesheet = loadImage("bird_sprite.png");
  
  for (int i=0; i<100; ++i) {
      PVector randomPosition = new PVector(random(0, width), random(0, height));
      Bird bird = new Bird(new Sprite(birdSpritesheet), randomPosition);
      birds.add(bird);
  }
  //bird.velocity.y = 0;
  //bird.velocity.x = 0;
}

int previousMillis;

void draw() {
  // Calculate delta time since last frame
  int millisElapsed = millis() - previousMillis;
  float secondsElapsed = millisElapsed / 1000f;
  previousMillis = millis();
  
  background(123, 216, 237);
  
  for (Bird bird : birds) {
    bird.update(secondsElapsed);
    bird.draw();
  }
}
