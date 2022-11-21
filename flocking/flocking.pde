PImage birdSpritesheet;

ArrayList<Bird> birds = new ArrayList<>();

enum DebugMode { OFF, ALL, SINGLE };
DebugMode debugMode = DebugMode.OFF;


// Bird/flocking tuning parameters
float BIRD_MAX_SPEED = 200;  
float BIRD_MOUSE_FOLLOW_STRENGTH = 250;  
float BIRD_SEPARATION_RADIUS = 65f;
float BIRD_SEPARATION_STRENGTH = 100;

void setup() {
  size(1000, 800, P3D);
  
  birdSpritesheet = loadImage("bird_sprite.png");
  
  for (int i=0; i<100; ++i) {
      PVector randomPosition = new PVector(random(0, width), random(0, height));
      Bird bird = new Bird(new Sprite(birdSpritesheet), randomPosition);
      birds.add(bird);
  }
  birds.get(0).isBirdZero = true;
}

int previousMillis;

void draw() {
  
  BIRD_MAX_SPEED = 200;  
  BIRD_MOUSE_FOLLOW_STRENGTH = 250;  
  BIRD_SEPARATION_RADIUS = 65f;
  BIRD_SEPARATION_STRENGTH = 100f;
  // Calculate delta time since last frame
  int millisElapsed = millis() - previousMillis;
  float secondsElapsed = millisElapsed / 1000f;
  previousMillis = millis();
  
  background(123, 216, 237);
  
  for (Bird bird : birds) {
    bird.update(secondsElapsed, birds);
    boolean debugDraw = debugMode == DebugMode.ALL || (debugMode == DebugMode.SINGLE && bird.isBirdZero);
    bird.draw(debugDraw);
  }
}

void keyPressed() {
  if (key == 'd') {
    if (debugMode == DebugMode.OFF) { debugMode = DebugMode.SINGLE; }
    else if (debugMode == DebugMode.SINGLE) { debugMode = DebugMode.ALL; }
    else if (debugMode == DebugMode.ALL) { debugMode = DebugMode.OFF; }
  }
}
