PImage birdSpritesheet;
PImage panda;
PVector pandaPos = new PVector(300, 400);

ArrayList<Bird> birds = new ArrayList<>();

enum DebugMode { OFF, ALL, SINGLE };
DebugMode debugMode = DebugMode.OFF;

SpatialGrid grid;

// Bird/flocking tuning parameters
float BIRD_MAX_SPEED = 200;  

float BIRD_MOUSE_FOLLOW_STRENGTH = 250;  

float BIRD_SEPARATION_RADIUS = 65f;
float BIRD_SEPARATION_STRENGTH = 100;

float BIRD_ALIGNMENT_RADIUS = 100f;
float BIRD_ALIGNMENT_STRENGTH = 50f;

void setup() {
  // Create window
  size(1000, 800, P3D);
  
  // Load image assets
  birdSpritesheet = loadImage("bird_sprite.png");
  panda = loadImage("panda_sprite.png");
  
  // Create a group of birds at random positions
  for (int i=0; i<100; ++i) {
      PVector randomPosition = new PVector(random(0, width), random(0, height));
      Bird bird = new Bird(new Sprite(birdSpritesheet), randomPosition);
      birds.add(bird);
  }
  
  // Pick one bird arbitrarily for single-bird debug view
  birds.get(0).isBirdZero = true;
  
  // Init spatial grid
  grid = new SpatialGrid(50);
}

int previousMillis;

void draw() {
  
  // Reassigning these here to allow use in Tweak Mode
  BIRD_MAX_SPEED = 200;  
  BIRD_MOUSE_FOLLOW_STRENGTH = 250;  
  BIRD_SEPARATION_RADIUS = 65f;
  BIRD_SEPARATION_STRENGTH = 100f;
  BIRD_ALIGNMENT_RADIUS = 100f;
  BIRD_ALIGNMENT_STRENGTH = 200f;
  
  // Calculate delta time since last frame
  int millisElapsed = millis() - previousMillis;
  println("FPS: " + millisElapsed);
  float secondsElapsed = millisElapsed / 1000f;
  previousMillis = millis();
  
  // Draw the sky
  background(123, 216, 237);
  
  // Populate spatial grid
  grid.empty();
  for (Bird bird : birds) {
    grid.add(bird, bird.position.x, bird.position.y);
  }
  
  imageMode(CENTER);
  image(panda, pandaPos.x, pandaPos.y);
  
  if (debugMode != DebugMode.OFF) {
    grid.debugDraw();
  }
  
  // Calculate forces on birds
  for (Bird bird : birds) {
    bird.calculateAcceleration(grid);
  }
  
  // Update and draw the birds
  for (Bird bird : birds) {
    bird.update(secondsElapsed, birds);
    
    // Figure out if we should enable debug drawing for this particular bird
    boolean debugDraw = debugMode == DebugMode.ALL || (debugMode == DebugMode.SINGLE && bird.isBirdZero);
    bird.draw(debugDraw);
  }
}

// Toggle debug mode when 'd' key pressed
void keyPressed() {
  if (key == 'd') {
    if (debugMode == DebugMode.OFF) { debugMode = DebugMode.SINGLE; }
    else if (debugMode == DebugMode.SINGLE) { debugMode = DebugMode.ALL; }
    else if (debugMode == DebugMode.ALL) { debugMode = DebugMode.OFF; }
  }
}
