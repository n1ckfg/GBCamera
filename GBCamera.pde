// https://petapixel.com/2022/05/05/a-review-of-the-nintendo-game-boy-camera-24-years-later/
// Based on ASCII Video by Ben Fry.

import processing.video.*;

Capture video;
boolean firstRun;
PShader shader;

void setup() {
  size(640, 480, P2D);

  video = new Capture(this, 640, 480);
  video.start(); 
  
  shader = loadShader("gb.glsl");
  shader.set("iResolution", float(width), float(height));
}

void draw() {
  background(0);

  shader.set("tex0", video);
  shader(shader);
  
  image(video, 0, 0);
  
  surface.setTitle("" + frameRate);
}

void captureEvent(Capture c) {
  c.read();
}
