// https://petapixel.com/2022/05/05/a-review-of-the-nintendo-game-boy-camera-24-years-later/
// Based on ASCII Video by Ben Fry.

import processing.video.*;

Capture video;
boolean firstRun;
PShader shader;
PGraphics buffer;

void setup() {
  size(640, 480, P2D);
  buffer = createGraphics(640, 480, P2D);
  
  video = new Capture(this, 640, 480);
  video.start(); 
  setupDelay();
  
  shader = loadShader("gb.glsl");
  shader.set("iResolution", float(buffer.width), float(buffer.height));
}

void draw() {
  background(0);
  
  updateDelay();
    
  shader.set("tex0", buffer);
  shader(shader);
  
  image(buffer, 0, 0, width, height);
  
  surface.setTitle("" + frameRate);
}

void captureEvent(Capture c) {
  c.read();
}
