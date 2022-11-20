public class Sprite {

  PImage spriteSheet;
    
  int frameCount = 3;
  float frameDurationSeconds = 0.1;
  int frameWidth = 32;
  
  float secondsSinceAnimationStarted = 0;
  
  public Sprite(PImage spriteSheet) {
    this.spriteSheet = spriteSheet;
  }
  
  void updateAnimation(float secondsElapsed) {
    secondsSinceAnimationStarted += secondsElapsed;
  }
  
  void draw() {
    // Figure out which frame we should be drawing currently
    int currentFrameIndex = (int) (secondsSinceAnimationStarted / frameDurationSeconds);
    currentFrameIndex %= frameCount;
    
    drawAnimationFrame(currentFrameIndex);
  }
  
  void drawAnimationFrame(int frameIndex) {
    // Crop out and draw the appropriate part of the image
    imageMode(CENTER);
    
    int frameStartX = frameWidth * frameIndex;
    
    image(
          spriteSheet,
          0, 0,
          frameWidth, frameWidth,                       // Size to draw
          frameStartX, 0,                               // Top-left of the section to draw
          frameStartX + frameWidth, frameWidth          // Borrom-right
    );
    
  }

}
